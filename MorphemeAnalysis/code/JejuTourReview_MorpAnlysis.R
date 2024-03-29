### Package Import
library(readr) # csv 파일 읽어오기
library(dplyr) # 데이터 전처리를 위한 '%>%' 사용을 가능하게 함 
library(tidytext) # 문자열 다루기
library(stringr)
library(tidyr) # 데이터프레임 다루기
library(ggplot2) # 인터랙티브 그래프 시각화
library(KoNLP) # 한글 형태소 분석 라이브러리
useNIADic()
useSejongDic()

### 데이터 Load
setwd("C://Users/olivi/Rdataframe/Tourism")
Sys.getlocale()
Sys.setlocale("LC_ALL", "C")
data = read.csv("21-12.csv", encoding="UTF-8") # csv 파일명 넣어주기
Sys.setlocale("LC_ALL", "Korean")

# 컬럼명 변경 (컬럼명이 한글일 경우 제대로 load되지 않을 수 있음)
colnames(data)[2] <- "date"
colnames(data)[5] <- "title"
colnames(data)[6] <- "contents"
View(data)

# 21.01~21.06 데이터프레임에만 적용, 월별로 프레임 나누기
# data <- data %>% 
#   select(date, title, contents) %>% 
#   filter(substr(date, 7, 7) == 6)
# View(data)

### 단어 빈도표 생성

## Step1. 데이터 전처리
# null 값 row drop
data <- data[!(data$contents == ""),]


## Step2. 명사 추출 
nouns_ls <- extractNoun(data$contents) 
View(nouns_ls)

## Step3. 데이터 프레임 생성
# 명사 list를 문자열 vector로 변환
contents_ls <- table(unlist(nouns_ls))
# 데이터프레임 변환
result_df <- as.data.frame(contents_ls, stringAsFactors=F)
# 변수명 수정
result_df <- rename(result_df,
                    word = Var1,
                    freq = Freq)
# 데이터프레임 타입 변경
result_df$word <- as.character(result_df$word)

## Step4. 필터링 및 빈도표 출력
# stopwords 지정 및 제거
result_df$word <- str_replace_all(result_df$word, "\\W", "") # 특수문자 제외
result_df$word<-gsub("\\d+","",result_df$word) # 숫자 제외
result_df$word<-gsub("\\n+","",result_df$word) # 줄바꿈 제외
result_df$word<-gsub("[A-Z]","",result_df$word) # 영어 알파벳 1개 제외
result_df$word<-gsub("[0-9]","",result_df$word) # 숫자 포함 글자 제외
result_df$word<-gsub("a","",result_df$word) # 가~힣, ㄱ~ㅎ, ㅏ~ㅢ, A-Z, a-z 등 stopwords 지정 가능
result_df$word<-gsub("[[:cntrl:]]","",result_df$word) 


# 두글자 이상의 단어만 추출, 공백 행 제거
result_df <- result_df %>%
  filter(nchar(word) >= 2, word != "    " | word != "   ")

View(result_df)
write.csv(result_df, file="final_21-12.csv", quote=FALSE) # 저장할 파일명 넣어주기

