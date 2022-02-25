Sys.setlocale("LC_ALL", "C")

library(reticulate)
library(writexl)
library(dplyr)

### Part1. Pickle DataSet Load
setwd("C://Users/olivi/Rdataframe/POStagging")
Sys.getlocale()
source_python("read_pkl.py")

pandemic1 <- read_pickle_file("pandemic_1.pkl")
pandemic2 <- read_pickle_file("pandemic_2.pkl")
pandemic3 <- read_pickle_file("pandemic_3.pkl")
pandemic4 <- read_pickle_file("pandemic_4.pkl")
pandemic5 <- read_pickle_file("pandemic_5.pkl")
pandemic_ext <- read_pickle_file("extra_data.pkl")
Sys.setlocale("LC_ALL", "Korean")

### Dataset Rows Filtering
pandemic1 <- subset(pandemic1, select=c("날짜", "tokenized_text", "jeju_place_google"))
pandemic2 <- subset(pandemic2, select=c("날짜", "tokenized_text", "jeju_place_google"))
pandemic3 <- subset(pandemic3, select=c("날짜", "tokenized_text", "jeju_place_google"))
pandemic4 <- subset(pandemic4, select=c("날짜", "tokenized_text", "jeju_place_google"))
pandemic5 <- subset(pandemic5, select=c("날짜", "tokenized_text", "jeju_place_google"))
pandemic_ext <- subset(pandemic_ext, select=c("날짜", "tokenized_text", "jeju_place_google"))

## jeju_place_google AND place Mapping
place = c("우도", "협재해변", "오설록티뮤지엄", "성산일출봉", "한림공원", "제주동문시장", 
          "카멜리아힐", "제주민속촌", "섭지코지", "중문색달해수욕장", "아쿠아플라넷제주", "중문관광단지", "신화테마파크")
pandemic1 <- pandemic1 %>% 
  filter(jeju_place_google %in% place, na.rm=TRUE)
pandemic2 <- pandemic2 %>% 
  filter(jeju_place_google %in% place, na.rm=TRUE)
pandemic3 <- pandemic3 %>% 
  filter(jeju_place_google %in% place, na.rm=TRUE)
pandemic4 <- pandemic4 %>% 
  filter(jeju_place_google %in% place, na.rm=TRUE)
pandemic5 <- pandemic5 %>% 
  filter(jeju_place_google %in% place, na.rm=TRUE)
pandemic_ext <- pandemic_ext %>% 
  filter(jeju_place_google %in% place, na.rm=TRUE)

write.csv(pandemic1, file="pandemic1.csv")
write.csv(pandemic2, file="pandemic2.csv")
write.csv(pandemic3, file="pandemic3.csv")
write.csv(pandemic4, file="pandemic4.csv")
write.csv(pandemic5, file="pandemic5.csv")
write.csv(pandemic_ext, file="pandemic_ext.csv")
