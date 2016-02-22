# opening a .sav file in Rstudio, and manipulating with dplyr ####
# 2016-02-22  RMHogervorst
# 
# file information: https://www.duo.nl/open_onderwijsdata/databestanden/ho/Ingeschreven/wo_ingeschr/Ingeschrevenen_wo1.jsp
# DUTCH DESCRIPTION FROM THE WEBSITE:
# "Het aantal ingeschrevenen (natuurlijke personen)
# in het wetenschappelijk onderwijs naar studiejaar (in 2015) en geslacht. Er worden vijf
# studiejaren gepresenteerd. De aantallen staan weergegeven per provincie,
# gemeente, instelling, croho (sub)onderdeel, opleiding, opleidingsvorm en
# opleidingsfase."
# 
# So number of people in higher education (universities) in the Netherlands per Year and a sex. 
#
#  ============README ==================
# I wrote comments right after the code 
# or/and  below and above the code. 
# Which could be annoying, but lucky for 
# you the Rstudio IDE makes comments grey
# and other code in different colors.
# Some comments are more like notes 
# or thoughts, I've used the ### *  for that. 
# ======================================
# 
# necessary packages: #### 
library(haven)
library(dplyr)
# location of the datafile online ####
link <- "https://rmhogervorst.github.io/cleancode/datasets/ingeschrevenwo2015.sav" 
# or refer to where you downloaded the file for example
link2 <- "C://Users/roel/Downloads/ingeschrevenwo2015.sav"
# load the .sav file into R using the link ####
wo2015 <- read_sav(link) 
### * I assign (<-) the output of the read_sav function to wo2015
### * which magically becomes a dataframe. =look=over=there=in=Environment,=Data==>
#
# exploring wo2015 with base R ####
### * You can actually check a lot of information when you click on the blue play
### * button in Rstudio.
str(wo2015)# str is short for structure and displays in your console ||
# this looks alot like the blue button information                   \/
names(wo2015) # what are the columnsnames?
table(wo2015$PROVINCIE) # create a table
# The result is a bit ugly, is Gelderland 2 or 284? 
# Check what happens with : View(table(wo2015$PROVINCIE))  # type over or select and pres ctrl -r
sapply(wo2015, class) # apply a function over all columns, the function is class in this case
# Most of the columns are of class character, some are numeric, and two are of
# the class "labelled". 
### * When you work with spss data this happens a lot.
### * The haven package created the class labelled to retain information that 
### * you would lose otherwise.
# let's look at the toppart of the data. ### * of course you can also use View(wo2015)
head(wo2015)  #shows the top part of the data, there is also a tail() function
View(table(wo2015$SOORT.INSTELLING)) # R commands are often nested , this 
# command translates to: 
# - take column SOORT.INSTELLING from dataframe wo2015 [wo2015$SOORT.INSTELLING]
# - create a table of that [table()]
# - put the result into the Viewer [View()]
### * so most R commands are interpreted from in to out, logical, but not really 
### * easy to understand. 
# 
# Look at the table in the viewer ^ (the tab tabl(wo2015$SOOR) etc  )
# you can see the frequencies of the types of SOORT INSTELLING (type of university).
# Do the same thing (display a table of frequencies) with INSTELLINGSNAAM.ACTUEEL (name of university)
# !!!!
# How many universities are there?
# 
# Some haven and spss specific things ####
# As you know SPSS cannot work with factor (nominal) values. 
# You have to tell SPSS that the variable is a nominal variable 
# and you have to create numbered values, with a label assigned to the values.
# When you import a .sav file into R that information can get lost. But on the 
# other hand you might want to use the numbered information. As an compromise
# the haven package imports the numbers, and the labels. So can we find the labels?
class(wo2015$OPLEIDINGSVORM) # no, that just tells us that it's labelled. 
attributes(wo2015$OPLEIDINGSVORM) # the command attributes gives you back all the metadata
# you can see the labels and numbers. 1 = deeltijd (part time eduction), 
# 2 = duaal (), 3 is voltijd(full time)
# The attributes command works on everything
attributes(wo2015) # this prints all the names, the class and 
# row names (which is quite useless information in this case)
attributes(wo2015[1,2]) # attributes of the first item of the second row
#
# So we can display the labels with number. but we would rather use that information 
# in R. R has no problem with nominal variables. And furthermore you won't make
# mistakes about which form of eduction your talking about.
# 
# the haven package has a function as_labeled
?as_factor  # this will display the help information in your right bottom help window.
# so let's make the OPLEIDINGSVORM column a bit more informative:
as_factor(wo2015$OPLEIDINGSVORM)  
# Now look back at wo2015
# Nothing has changed!
# That's right, you need to assign the result of the operation back to a column
wo2015$OPLEIDINGSVORM2 <- as_factor(wo2015$OPLEIDINGSVORM) 
### * or you could assign it to OPLEIDINGSVORM 
# Let's do the same thing to OPLEIDINGSFASE.ACTUEEL
# 
# Working with dplyr  ####
library(dplyr)  # probably not necesary, but it doesn't hurt
# dplyr has 7 verbs to manipulate your dataframe. 
# all the verbs have the same arguments: first = dataframe, all the others, variables.
# SELECT (dataframe, variablename1, variablename2, etc)
# select is used to select variables (columns) in your data frame.
select(wo2015, PROVINCIE, OPLEIDINGSVORM2,j2012.MAN, j2013.MAN ) 
# We have selected 4 variables. as you can see in the output.
#  it also says: Source: local data frame [2,417 x 4]  meaning 2417 cases and 4 variables.
#  
#  FILTER (dataframe, ways to filter)
#  Filter selects cases. 
filter(wo2015, PROVINCIE == "Limburg") # this filters the cases where provincie equals limburg
# The endresult is a data frame [91 x 24] with all columns but 
# with only the cases in the Limburg province
# Can we combine this?
# yes!
select(filter(wo2015, PROVINCIE == "Limburg"),PROVINCIE, OPLEIDINGSVORM2,j2012.MAN, j2013.MAN )
# I will show you a more readable form later on, but this works.
# The dataframe has teh 91 cases from the filter action and the 4 columns from 
# the select action. This even works the other way around. 
filter(select(wo2015, PROVINCIE, OPLEIDINGSVORM2,j2012.MAN, j2013.MAN ), PROVINCIE == "Limburg")
# But not always:
filter(select(wo2015, OPLEIDINGSVORM2,j2012.MAN, j2013.MAN ), PROVINCIE == "Limburg")
# why doesn't this work?
# 
# The different functions accept data.frames and give a data frame as output.
# The data frame from the select action does not contain the column PROVINCIE.
# Therefore the filter function can't select on that variable.
#
# The functions arrange() and distinct() sort the data and select the unique values from a data frame
arrange(wo2015, GEMEENTENUMMER) # data frame [2,417 x 24]
distinct(wo2015, GEMEENTENAAM)  # data frame [16 x 24]  (all the variables, only unique gemeentenamen)
#
# MUTATE(dataframe, name_of new variable = action)
# mutate creates new variables
mutate(wo2015, from14to15M = j2015.MAN - j2014.MAN)
# Ok, but what happened?
# We can't see the new variable from14to15M but 
# it is there, the output says:
#  Variables not shown: CROHO.ONDERDEEL (chr), [......] from14to15M (dbl)
# 
test<-mutate(wo2015, from14to15M = j2015.MAN - j2014.MAN)
View(test)  # scroll to the end. or use test$from14to15M
# or we could select only the variables needed.
select(mutate(wo2015, from14to15M = j2015.MAN - j2014.MAN), from14to15M, PROVINCIE)
# Still it gets complicated very fast. 
# You can't really see what happens here.
# 
# There is an easier way
# 
# With the pipe operator (%>%) you can chain the commands together.
# The functions work the same but it is much easier to read.
# From:
select(mutate(wo2015, from14to15M = j2015.MAN - j2014.MAN), from14to15M, PROVINCIE)
# to
wo2015 %>% mutate(from14to15M = j2015.MAN - j2014.MAN) %>% select(from14to15M, PROVINCIE)
# take the dataframe, THEN mutate                       THEN select these variables.
# 
# 
# Even better, the pipe operator puts the dataframe created in the left side
# as first argument in the right side. 
# 
# SUMMARIZE / SUMMARISE (both work)

# example:
summarize(wo2015, mean2015_males = mean(j2015.MAN))   # if one value is missing (NA)
# there is no mean value. 
summarize(wo2015, mean2015_males = mean(j2015.MAN, na.rm = T)) # this way we remove the missings
# But perhaps you would like to know the mean number of students per opleidingsfase?
# Summarize works with group_by, let's use the pipe operator again.
wo2015 %>% group_by(OPLEIDINGSFASE.ACTUEEL2) %>% summarise(mean2015_males = mean(j2015.MAN, na.rm = T))
# Chaining can be very easy 
# let's take numbers in zuid-holland only
wo2015 %>% filter(PROVINCIE == "Zuid-Holland") %>%      # R will continue on the following line
        group_by(OPLEIDINGSFASE.ACTUEEL2) %>%           # It also helps in readability
        summarise(mean2015_males = mean(j2015.MAN, na.rm = T))

# grouping can be done on multiple levels
wo2015 %>% group_by(PROVINCIE, OPLEIDINGSFASE.ACTUEEL2) %>%
        summarise(mean2015_males = mean(j2015.MAN, na.rm = T))
# Filters can work with multiple arguments
wo2015 %>% filter(PROVINCIE == "Zuid-Holland" | PROVINCIE == "Limburg") %>%  # | means or
        group_by(OPLEIDINGSFASE.ACTUEEL2) %>% 
        summarise(mean2015_males = mean(j2015.MAN, na.rm = T))
# That was an OR operator, there is also an AND.
wo2015 %>% filter(PROVINCIE == "Zuid-Holland" & OPLEIDINGSFASE.ACTUEEL2 == "propedeuse bachelor") %>%  
        group_by(OPLEIDINGSVORM2) %>% 
        summarise(mean2015_males = mean(j2015.MAN, na.rm = T), number = n()) # n() gives a count
# the summarize command can make multiple columns. (remember this is also a dataframe)
# Finally some filter actions with numbers
wo2015 %>% filter(j2011.VROUW <= 10) %>% # so less or equal to 10 women in 2011
        filter(OPLEIDINGSFASE.ACTUEEL2 == "propedeuse bachelor") %>% # multipe filters? no problem.
        filter(j2015.VROUW > 10)  %>% # more then 10 in 2015. 
        group_by(PROVINCIE) %>% summarize(number_of_programs = n())
#
#THATS IT FOR TODAY, GOOD LUCK!


##############################################
# in case these scripts stop working
# in the future,  here is my sesion info: (devtools::session.info())
# 
# Session info ----------------------------------------------
# setting  value                       
# version  R version 3.2.3 (2015-12-10)
# system   x86_64, mingw32             
# ui       RStudio (0.99.878)          
# language (EN)                        
# collate  Dutch_Netherlands.1252      
# tz       Europe/Berlin               
# date     2016-02-22                  
# Packages ----------------------------------------------------
#         package    * version    date       source        
#         dplyr      * 0.4.3      2015-09-01 CRAN (R 3.2.3)                    
#         haven      * 0.2.0.9000 2016-02-12 Github (hadley/haven@11fb5f5)
#         rstudioapi   0.5        2016-01-24 CRAN (R 3.2.3) 
