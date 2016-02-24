# tidyR example with open govermentdata
# https://www.duo.nl/open_onderwijsdata/databestanden/ho/Ingeschreven/wo_ingeschr/Ingeschrevenen_wo1.jsp
# 
# 2016-02-24  RMHogervorst
# 
# What you need to know to know for this lesson:
#  the dplyr package, the pipe (%>%) operator
#  subsetting, data frames, basic manipulation of data
#  how to install packages
#  The file used is described in the previous script:
#  https://github.com/RMHogervorst/cleancodeexamples/blob/master/scripts/opening-spss-file-manipulate-with-dplyr-2016-feb.R
#  
# necesary packages:  ####
library(readr)
library(tidyr)
library(dplyr)
link<-"https://www.duo.nl/open_onderwijsdata/images/01.%20Ingeschrevenen%20wo-2015.csv"
ingeschreven_wo_2015<-read_csv2(link, trim_ws = T) #uses the ; notation therefore csv2
# 
# INTRODUCTION ####
# To make analyses work we often need to change the way files look.
# Sometimes information is recorded in a way that is very efficient but not 
# workable for your analyses. In other words, the data is messy and we need to
# make it tidy.
# 
# Tidy data means:
# 1. Each variable forms a column.
# 2. Each observation forms a row.
# 3. Each type of observational unit forms a table.
# 
#  From: Wickham, Hadley. “Tidy Data.” Journal of Statistical Software 59, no. 10 (2014). doi:10.18637/jss.v059.i10.
#
# The way you tidy your data depends on what you want to do with it.
# Let's look at the data we just downloaded.
View(ingeschreven_wo_2015)
# 22 variables, distinct numbers per opleidingsfase 
# but the columns 13 till 22 are actually distinct observations.
# Also look at the bottom row... these are the totals. 
# It seems that row sums up  the total of the columns males and females per year.
# 
# Tasks:
# # seperate into male/female and year as seperate observations
# meaning one observation per row with an extra variable female (yes no) 
# and year (2011-2015).
# 
# Tasks: ####
# 
# - remove final two rows. 
#       (we can sum the values is we want to and the empty rows have no information)
# - shape the data into observations in the row and variables in the columns
# 
# Removing the final three rows ####
ingeschreven_wo_2015[2415:2417,12:16]  #show the bottom part of the data.frame 
### * a note about subsetting
### * To take or manipulate a part of a dataframe we can use subset()
### * or the faster notation dataframe[rows,columns]. 
### * don't forget the comma! because:
### * duo2015[3,] is different from  duo2015[3]  select and execute to see
### * to select multiple rows use ":", like:
### * duo2015[3:5,]
duo2015<-ingeschreven_wo_2015[-2416,] #remove the 2416th row and assign rest to duo215
duo2015[2416,12] # subset duo row 2416 and variable 12 
# we don't have the missing values on row 2416 anymore
duo2015<-duo2015[-2416,]
tail(duo2015)
tail(ingeschreven_wo_2015)
# as you can see we removed the final rows.
# another way to delete the two rows in one command is:
duo2015<-ingeschreven_wo_2015[-(2416:2417),]
tail(duo2015)  # see? the same
# tidy data examples as found in the tidyr package ####
# 
# Check teh description in the vignette
vignette("tidy-data")
# Or the demos
demo(package = "tidyr") # look at example dadmon:
demo(package = "tidyr", topic = "dadmom")  # press enter
#  Or look at the vignette online: https://github.com/hadley/tidyr/blob/master/vignettes/tidy-data.Rmd
#
# Gathering the data ####
# First we shape the file from  wide to long format, the columns 13 - 22
# contain both year and gender. Which I would like to have seperated.
# In this first step we gather all the data from the columns 13 to 22
# and put turn them into cases.
# This is equivalent to Restructure in SPSS?
duo2015 %>% gather(year, frequency, c(13:22)) %>% View
# if you look at this temporary file you see that it contains 24150 cases
# But and only 14 columns. 
# Unfortunately the 13th column contains both year and gender. Let's fix this.
# 
# Separating a column that contains multiple values ####
duo2015 %>% gather(year, frequency, c(13:22)) %>% 
        separate(year, c("year", "gender" ))  %>%
        arrange(`OPLEIDINGSNAAM ACTUEEL`, year, gender) %>%  # sort on name, year gender
        View # that seems to work let's create a new dataframe
#   We use the same commands but assign it to a new name:
duo2015_tidy<-duo2015  %>% 
        gather(year, FREQUENCY, c(13:22)) %>% 
        separate(year, c("YEAR", "GENDER" ))  %>%
        arrange(`OPLEIDINGSNAAM ACTUEEL`, YEAR, GENDER) # this final step does 
# change the variables but only sorts it in a useful format.
View(duo2015_tidy)# look identical to the previous steps.        
write_csv(duo2015_tidy, "files/duo2015_tidy.csv") # you can also chain this command 
# to the previous one, it makes makes more sense gramatically: 
# dataframe THEN
#       gather variables THEN
#       separate THEN
#       arrange THEN
#       write to a file
# duo2015  %>% 
#         gather(year, frequency, c(13:22)) %>% 
#         separate(year, c("year", "gender" ))  %>%
#         arrange(`OPLEIDINGSNAAM ACTUEEL`, year, gender) %>%
#         write_csv("files/duo2015_tidy.csv") # 
#
#
### Cleaning up the variablenames ####
# However there is some problem with the names, some contain spaces, and that is 
# just annoying. Lets replace the names with a bar in place of the space.
# First the command then the explanation
names(duo2015_tidy)<-gsub(" ", "-", names(duo2015_tidy))
# The command names()  returns the variablenames,
# the command gsub uses pattern recognition and replacement. ?gsub
# The first argument is what to recognize, (" ") meaning whitespace
# the second argument is the replacement. I chose a bar ("-"), but nothing ("") or 
# a dot (".") would work equaly well.
# The third argument is the vector to apply this principle on, the names of the variables 
# in this case. Finally we assign the endresult of that command to names(duo2015).
# So in one line we replaced the spaces in the names of the variables.
# 
# Then save it again to a file (this will replace the old one)
write_csv(duo2015_tidy, "files/duo2015_tidy.csv")
