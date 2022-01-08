### Package Import
library(readr) # csv ���� �о����
library(dplyr) # ������ ��ó���� ���� '%>%' ����� �����ϰ� �� 
library(tidytext) # ���ڿ� �ٷ��
library(stringr)
library(tidyr) # ������������ �ٷ��
library(ggplot2) # ���ͷ�Ƽ�� �׷��� �ð�ȭ
library(KoNLP) # �ѱ� ���¼� �м� ���̺귯��
useNIADic()
useSejongDic()

### ������ Load
setwd("C://Users/olivi/Rdataframe/Tourism")
Sys.getlocale()
Sys.setlocale("LC_ALL", "C")
data = read.csv("21-12.csv", encoding="UTF-8") # csv ���ϸ� �־��ֱ�
Sys.setlocale("LC_ALL", "Korean")

# �÷��� ���� (�÷����� �ѱ��� ��� ����� load���� ���� �� ����)
colnames(data)[2] <- "date"
colnames(data)[5] <- "title"
colnames(data)[6] <- "contents"
View(data)

# 21.01~21.06 �����������ӿ��� ����, ������ ������ ������
# data <- data %>% 
#   select(date, title, contents) %>% 
#   filter(substr(date, 7, 7) == 6)
# View(data)

### �ܾ� ��ǥ ����

## Step1. ������ ��ó��
# null �� row drop
data <- data[!(data$contents == ""),]


## Step2. ���� ���� 
nouns_ls <- extractNoun(data$contents) 
View(nouns_ls)

## Step3. ������ ������ ����
# ���� list�� ���ڿ� vector�� ��ȯ
contents_ls <- table(unlist(nouns_ls))
# ������������ ��ȯ
result_df <- as.data.frame(contents_ls, stringAsFactors=F)
# ������ ����
result_df <- rename(result_df,
                    word = Var1,
                    freq = Freq)
# ������������ Ÿ�� ����
result_df$word <- as.character(result_df$word)

## Step4. ���͸� �� ��ǥ ���
# stopwords ���� �� ����
result_df$word <- str_replace_all(result_df$word, "\\W", "") # Ư������ ����
result_df$word<-gsub("\\d+","",result_df$word) # ���� ����
result_df$word<-gsub("\\n+","",result_df$word) # �ٹٲ� ����
result_df$word<-gsub("[A-Z]","",result_df$word) # ���� ���ĺ� 1�� ����
result_df$word<-gsub("[0-9]","",result_df$word) # ���� ���� ���� ����
result_df$word<-gsub("a","",result_df$word) # ��~�R, ��~��, ��~��, A-Z, a-z �� stopwords ���� ����
result_df$word<-gsub("[[:cntrl:]]","",result_df$word) 


# �α��� �̻��� �ܾ ����, ���� �� ����
result_df <- result_df %>%
  filter(nchar(word) >= 2, word != "    " | word != "   ")

View(result_df)
write.csv(result_df, file="final_21-12.csv", quote=FALSE) # ������ ���ϸ� �־��ֱ�
