###############################################
# Introduction to GGPLOT2 part 2
# for the series: from spss to r
# 2016-02-24 RMHogervorst
# 
# file used origin: # file information: https://www.duo.nl/open_onderwijsdata/databestanden/ho/Ingeschreven/wo_ingeschr/Ingeschrevenen_wo1.jsp
# transformed it to tidy data with: https://github.com/RMHogervorst/cleancodeexamples/blob/master/scripts/tidyr-on-duo-data.R
###############################################

#location of files: "https://github.com/RMHogervorst/cleancodeexamples/blob/master/files"

link<-"https://raw.githubusercontent.com/RMHogervorst/cleancodeexamples/master/files/duo2015_tidy.csv"
# Libraries to use
library(dplyr) # yes I use it almost daily
library(ggplot2)
library(readr)
# load the data
duo2015_tidy<- read_csv(link)
# This is the same file we used in: https://rmhogervorst.github.io/cleancode/blog/2016/02/24/creating-tidy-data.html
# This file contains the number of students per year per gender per program 
# between 2011 and 2015.
#
# To get some meaningul insights from this file we need to slice and filter 
# variables. 
# First filter on 2015, full time and bachelor.
duo2015_tidy %>% filter(YEAR == 2015 & OPLEIDINGSVORM == "voltijd onderwijs" &
                                OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>% View
# You will see that every program has 2 rows, one for males and one for females
# What are the numbers combined?
duo2015_tidy %>% filter(YEAR == 2015 & 
                                OPLEIDINGSVORM == "voltijd onderwijs" &
                                OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>%
        group_by(OPLEIDINGSNAAM.ACTUEEL) %>% summarise(combinedMF = sum(FREQUENCY)) %>%
        View
# Did it change in the years?
duo2015_tidy %>% filter(YEAR == 2014 & 
                                OPLEIDINGSVORM == "voltijd onderwijs" &
                                OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>%
        group_by(OPLEIDINGSNAAM.ACTUEEL) %>% summarise(combinedMF = sum(FREQUENCY)) %>%
        View
# that's too much information. Let's plot it
duo2015_tidy %>% filter( OPLEIDINGSVORM == "voltijd onderwijs" &
                                OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>%
        group_by(OPLEIDINGSNAAM.ACTUEEL, YEAR) %>% summarise(combinedMF = sum(FREQUENCY)) %>%
        ggplot(aes(YEAR, combinedMF)) + geom_line(aes(group = OPLEIDINGSNAAM.ACTUEEL)) # note that we don't
        # have to specify the data because the chaining puts the end result in the first place
# So... Well there is a plot, but there's too many lines. How many programs were there?
length(unique(duo2015_tidy$OPLEIDINGSNAAM.ACTUEEL)) # display all unique names, count lenght of vector
# there are 866 programs, 
# how many in bachelor propedeuse?
duo2015_tidy %>% filter(OPLEIDINGSVORM == "voltijd onderwijs" &
                                OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>%
        distinct(OPLEIDINGSNAAM.ACTUEEL) # still 141 
# Let's explore the numbers. If you still have the viewer open with the 2014 data
# You can click on the numbers in the viewer and sort them from large to small.
# But we can also create a histogram
duo2015_tidy %>% filter(YEAR == 2015 & 
                                OPLEIDINGSVORM == "voltijd onderwijs" &
                                OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>%
        group_by(OPLEIDINGSNAAM.ACTUEEL) %>% summarise(combinedMF = sum(FREQUENCY)) %>%
        ggplot(aes(combinedMF)) + geom_histogram()  # note the warning about binsize.
# It is possible to save a ggplot item and work with that.
# I use it here to filter all the data and put that into the ggplot() item.
# I have also specified the x axis. 
g<-duo2015_tidy %>% filter(YEAR == 2015 & 
                                OPLEIDINGSVORM == "voltijd onderwijs" &
                                OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>%
        group_by(OPLEIDINGSNAAM.ACTUEEL) %>% summarise(combinedMF = sum(FREQUENCY)) %>%
        ggplot(aes(combinedMF))
g  # if we plot the g element, nothing really happens. 
g + geom_histogram() # recreates the previous plot
g + geom_histogram(bins = 141) # I have specified the bins to exaclty the number of programs.
# There is a large peak at... the 0. Let's throw the zeros out.
g<-duo2015_tidy %>% filter(YEAR == 2015 & 
                                   OPLEIDINGSVORM == "voltijd onderwijs" &
                                   OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>%
        group_by(OPLEIDINGSNAAM.ACTUEEL) %>% summarise(combinedMF = sum(FREQUENCY)) %>%
        filter(combinedMF >0) %>%   # only cases larger then zero 
        ggplot(aes(combinedMF))
g+ geom_histogram(bins = 50) # somewhat better.
# Now we see that most of the programs that are not zero are below 1000
# perhaps we can add a median line?
g2<-g + geom_histogram(bins = 70)+ 
        geom_vline(aes(xintercept=median(combinedMF, na.rm=T)), color = "red") +
        geom_vline(aes(xintercept=mean(combinedMF, na.rm=T)), color = "blue")
# let's take the programs with less then 500 people in 2014.
smallprograms<-duo2015_tidy %>% filter(YEAR == 2015 & 
                                OPLEIDINGSVORM == "voltijd onderwijs" &
                                OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>%
        group_by(OPLEIDINGSNAAM.ACTUEEL) %>% summarise(combinedMF = sum(FREQUENCY)) %>%
        filter(combinedMF <500 & combinedMF > 200)
smallprograms$OPLEIDINGSNAAM.ACTUEEL # this is then a vector of small studies in 2015
# that we can use to select from the large datafile
d<-duo2015_tidy %>% filter(OPLEIDINGSNAAM.ACTUEEL %in% smallprograms$OPLEIDINGSNAAM.ACTUEEL) %>%
        filter(OPLEIDINGSVORM == "voltijd onderwijs" & OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor")
#View(d)
d %>% filter(GENDER == "VROUW") %>%
ggplot(aes(YEAR , FREQUENCY) ) + geom_line(aes(group = OPLEIDINGSNAAM.ACTUEEL, color = PROVINCIE))

##
## alleen grote studies dan maar?
hugeprograms<-duo2015_tidy %>% filter(YEAR == 2015 & 
                                OPLEIDINGSVORM == "voltijd onderwijs" &
                                OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>%
        group_by(OPLEIDINGSNAAM.ACTUEEL) %>% summarise(combinedMF = sum(FREQUENCY)) %>%
        filter(combinedMF > 900)
h<-duo2015_tidy %>% filter(OPLEIDINGSNAAM.ACTUEEL %in% hugeprograms$OPLEIDINGSNAAM.ACTUEEL) %>%
        filter(OPLEIDINGSVORM == "voltijd onderwijs" & OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor")
h%>% #filter(GENDER == "VROUW") %>%
        ggplot(aes(YEAR , FREQUENCY) ) + geom_line(aes(group = OPLEIDINGSNAAM.ACTUEEL)) +
        facet(  GENDER)
# per uni leiden
