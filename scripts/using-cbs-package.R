# cbs data
# 
# every two years 97 99 01 03
# install.packages("cbsodataR")
library(cbsodataR)
tables <- get_table_list(Language="en")
# explore data 
tables$Title
tables$ID[447]
tables$Identifier[447]
get_meta("37881eng")
daily_time_use <- get_data("37881eng")
tables$Summary[447]
tables$ShortDescription[447]
str(daily_time_use)
View(daily_time_use)
## time use in the netherlands for specific things compare male and femals. 
# WalkingCycling_78
# SpendTimeReading_77

get_meta("80066eng")
innovation <- get_data("80066eng") 
get_meta("81178ENG")
medicaldata<-get_data("81178ENG")
