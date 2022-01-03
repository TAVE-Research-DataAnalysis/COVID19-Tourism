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
library(wordcloud2) # 워드클라우드 패키지 (인터랙티브,반응형 워드클라우드)
library(RColorBrewer) # 워드클라우드 커스터마이징 라이브러리
library(ggthemes)

## 폰트 설정
library(extrafont)
library(showtext)
font_add_google("Noto Sans KR", "notosans")
showtext.auto()
loadfonts(device="win")


### 데이터 Load
setwd("C://Users/olivi/Rdataframe/Tourism")
Sys.getlocale()
Sys.setlocale("LC_ALL", "C")
jan20 = read.csv("20-01.csv", encoding="UTF-8")
Sys.setlocale("LC_ALL", "Korean")

# 컬럼명 변경 (컬럼명이 한글일 경우 제대로 load되지 않을 수 있음)
colnames(jan20)[1] <- "date"
colnames(jan20)[3] <- "title"
colnames(jan20)[4] <- "contents"
colnames(jan20)[6] <- "user"
head(jan20[,c("title", "contents")])
View(jan20)


### 단어 빈도표 생성

## Step1. 데이터 전처리

# null 값 row drop
jan20 <- jan20[!(jan20$contents == ""),]


## Step2. 명사 추출 

nouns_ls <- extractNoun(jan20$contents) 
class(nouns_ls) # list
dim(nouns_ls)# NULL
View(nouns_ls)


## Step3. 데이터 프레임 생성

# 명사 list를 문자열 vector로 변환
contents_jan20 <- table(unlist(nouns_jan20))
class(contents_jan20) # table
# 데이터프레임 변환
df_jan20 <- as.data.frame(contents_jan20, stringAsFactors=F)
# 변수명 수정
df_jan20 <- rename(df_jan20,
                   word = Var1,
                   freq = Freq)


## Step4. 필터링 및 빈도표 출력

# 두글자 이상의 단어만 추출
df_jan20 <- filter(df_jan20, str_length(word) >= 2)

head(df_jan20)
View(df_jan20)
class(df_jan20) # data.frame
dim(df_jan20)
summary(df_jan20)
# 빈도수 상위 20개 단어 추출 (내림차순 정렬)
top_20 <- df_jan20 %>% 
  arrange(desc(freq)) %>% 
  head(20)

# stopwords 설정 (보완필요)
stop_words <- c("^", "♡", "'", "☆", "2020", "@", "-", "_", "~", "♥", ";")
df_jan20 <- df_jan20[str_detect(df_jan20, stop_words) == FALSE,]
# 특수문자 제거 (보완 필요)
top_20 <- top_20[which(!top_20$word %in% c("ㅋ", "^", "[~!@#$%^&*()_+=?]<>'")),]


View(top_20)
# 빈도수 상위 500개 단어 추출 (내림차순 정렬)
top_500 <- df_jan20 %>% 
  arrange(desc(freq)) %>% 
  head(500)
str(top_500)

### 시각화
# 바차트
top_20 %>% 
  ggplot(aes(x=reorder(word, freq), y=freq, fill=freq)) +
  geom_bar(stat="identity", colour="black") +
  coord_flip() +
  labs(x="word", y=NULL) +
  scale_fill_continuous(low="#ed85a2", high="#859ced") +
  theme_few() +
  theme(plot.title = element_text(hjust=0.5, size=18, family="notosans"),
        axis.text=element_text(family="notosans")) +
  ggtitle("2020년 1월 제주 여행 리뷰 빈도수 상위 20개 키워드")


# 워드클라우드
wordcloud2(top_500, size=1.5, col="random-light", fontFamily = "NanumGothic")
