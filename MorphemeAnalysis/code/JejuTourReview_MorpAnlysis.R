### Package Import
library(readr) # csv ÆÄÀÏ ÀĞ¾î¿À±â
library(dplyr) # µ¥ÀÌÅÍ ÀüÃ³¸®¸¦ À§ÇÑ '%>%' »ç¿ëÀ» °¡´ÉÇÏ°Ô ÇÔ 
library(tidytext) # ¹®ÀÚ¿­ ´Ù·ç±â
library(stringr)
library(tidyr) # µ¥ÀÌÅÍÇÁ·¹ÀÓ ´Ù·ç±â
library(ggplot2) # ÀÎÅÍ·¢Æ¼ºê ±×·¡ÇÁ ½Ã°¢È­
library(KoNLP) # ÇÑ±Û ÇüÅÂ¼Ò ºĞ¼® ¶óÀÌºê·¯¸®
useNIADic()
useSejongDic()

### µ¥ÀÌÅÍ Load
setwd("C://Users/olivi/Rdataframe/Tourism")
Sys.getlocale()
Sys.setlocale("LC_ALL", "C")
data = read.csv("21-12.csv", encoding="UTF-8") # csv ÆÄÀÏ¸í ³Ö¾îÁÖ±â
Sys.setlocale("LC_ALL", "Korean")

# ÄÃ·³¸í º¯°æ (ÄÃ·³¸íÀÌ ÇÑ±ÛÀÏ °æ¿ì Á¦´ë·Î loadµÇÁö ¾ÊÀ» ¼ö ÀÖÀ½)
colnames(data)[2] <- "date"
colnames(data)[5] <- "title"
colnames(data)[6] <- "contents"
View(data)

# 21.01~21.06 µ¥ÀÌÅÍÇÁ·¹ÀÓ¿¡¸¸ Àû¿ë, ¿ùº°·Î ÇÁ·¹ÀÓ ³ª´©±â
# data <- data %>% 
#   select(date, title, contents) %>% 
#   filter(substr(date, 7, 7) == 6)
# View(data)

### ´Ü¾î ºóµµÇ¥ »ı¼º

## Step1. µ¥ÀÌÅÍ ÀüÃ³¸®
# null °ª row drop
data <- data[!(data$contents == ""),]


## Step2. ¸í»ç ÃßÃâ 
nouns_ls <- extractNoun(data$contents) 
View(nouns_ls)

## Step3. µ¥ÀÌÅÍ ÇÁ·¹ÀÓ »ı¼º
# ¸í»ç list¸¦ ¹®ÀÚ¿­ vector·Î º¯È¯
contents_ls <- table(unlist(nouns_ls))
# µ¥ÀÌÅÍÇÁ·¹ÀÓ º¯È¯
result_df <- as.data.frame(contents_ls, stringAsFactors=F)
# º¯¼ö¸í ¼öÁ¤
result_df <- rename(result_df,
                    word = Var1,
                    freq = Freq)
# µ¥ÀÌÅÍÇÁ·¹ÀÓ Å¸ÀÔ º¯°æ
result_df$word <- as.character(result_df$word)

## Step4. ÇÊÅÍ¸µ ¹× ºóµµÇ¥ Ãâ·Â
# stopwords ÁöÁ¤ ¹× Á¦°Å
result_df$word <- str_replace_all(result_df$word, "\\W", "") # Æ¯¼ö¹®ÀÚ Á¦¿Ü
result_df$word<-gsub("\\d+","",result_df$word) # ¼ıÀÚ Á¦¿Ü
result_df$word<-gsub("\\n+","",result_df$word) # ÁÙ¹Ù²Ş Á¦¿Ü
result_df$word<-gsub("[A-Z]","",result_df$word) # ¿µ¾î ¾ËÆÄºª 1°³ Á¦¿Ü
result_df$word<-gsub("[0-9]","",result_df$word) # ¼ıÀÚ Æ÷ÇÔ ±ÛÀÚ Á¦¿Ü
result_df$word<-gsub("a","",result_df$word) # °¡~ÆR, ¤¡~¤¾, ¤¿~¤Ò, A-Z, a-z µî stopwords ÁöÁ¤ °¡´É
result_df$word<-gsub("[[:cntrl:]]","",result_df$word) 


# µÎ±ÛÀÚ ÀÌ»óÀÇ ´Ü¾î¸¸ ÃßÃâ, °ø¹é Çà Á¦°Å
result_df <- result_df %>%
  filter(nchar(word) >= 2, word != "    " | word != "   ")

View(result_df)
write.csv(result_df, file="final_21-12.csv", quote=FALSE) # ÀúÀåÇÒ ÆÄÀÏ¸í ³Ö¾îÁÖ±â

