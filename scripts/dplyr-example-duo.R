#https://www.duo.nl/open_onderwijsdata/databestanden/ho/Ingeschreven/wo_ingeschr/Ingeschrevenen_wo1.jsp
#
link<-"https://www.duo.nl/open_onderwijsdata/images/01.%20Ingeschrevenen%20wo-2015.csv"
library(readr)
ingeschreven_wo_2015<-read_csv2(link, trim_ws = T) #uses the ; notation therefore csv2
dim(ingeschreven_wo_2015)
# 2417 cases with 22 variables 
# Het aantal ingeschrevenen (natuurlijke personen)
# in het wetenschappelijk onderwijs naar studiejaar en geslacht. Er worden vijf
# studiejaren gepresenteerd. De aantallen staan weergegeven per provincie,
# gemeente, instelling, croho (sub)onderdeel, opleiding, opleidingsvorm en
# opleidingsfase. Just checking some things
sapply(ingeschreven_wo_2015, class) # this returns all the columns of the dataframe
# and tells me what class . 
table(ingeschreven_wo_2015$PROVINCIE)
table(ingeschreven_wo_2015$`SOORT INSTELLING`) #silly two part names with spaces...
# because spss can't work with spaces in names, we have to replace them:
names(ingeschreven_wo_2015) <- gsub(" ", ".", names(ingeschreven_wo_2015))
# change OPLEIDINGSVORM and OPLEIDINGSFASE.ACTUEEL  to factor to show some things
ingeschreven_wo_2015$OPLEIDINGSVORM<-as.factor(ingeschreven_wo_2015$OPLEIDINGSVORM)
ingeschreven_wo_2015$OPLEIDINGSFASE.ACTUEEL<-as.factor(ingeschreven_wo_2015$OPLEIDINGSFASE.ACTUEEL)
# then write away
haven::write_sav(ingeschreven_wo_2015, "ingeschrevenwo2015.sav") # or use library(haven); write_sav(..) etc.
rm(ingeschreven_wo_2015) #cleaning up the workspace or use rm(list= ls()) to remove everything

