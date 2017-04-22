# CRAN things
# 
# source of the file : http://www.r-bloggers.com/cran-packages-on-github-and-some-cran-description-observations/
load(url("http://public-r-data.s3-website-us-east-1.amazonaws.com/ghcran.Rdata"))
ghcran$License

# goal is to find out more about packages, what is type of licence
library(dplyr)
library(ggplot2)
ghcranroel <- ghcran %>% 
        filter(Type == "Package") %>% 
        mutate( Licence_details = ifelse(grepl("GPL", License), "GPL", 
                                        ifelse(grepl("MIT", License), "MIT", 
                                        ifelse(grepl("Mozilla Public License|MPL", License), "MPL", 
                                        ifelse(grepl("Apache", License), "Apache", "Other")))),
                testsuite = ifelse(grepl("testthat", Suggests), "testthat", 
                                   ifelse(grepl("Runit", Suggests), "runit", "none"))
                   )
ghcranroel %>% 
        ggplot(aes(Licence_details)) + geom_bar()
# when are they published?
summary(as.Date(ghcran$Date))
# On how many packages do packages depend
# 
# how many have testthat or runit dependencies (sugest)
table(ghcranroel$testsuite)
# how many have paralell capabilities
parallel_packages <- c("parallel",  "multicore" , "snow", "rpvm"," Rmpi", 
                       "pbdMPI", "nws", "snowFT", "snowfall", "foreach", "future",
                       "Rborist", "h2o", "randomForestSRC",  # explicit packages
                       "pnmath", "pnmath0", "Rdsm", "RhpcBLASctl", "Rhpc")# implicit 
ghcranroel <- ghcranroel %>% 
        mutate(parallel = ifelse(Suggests %in% parallel_packages, "yes", "no"))

# Dirk already did such  analyses:
# http://dirk.eddelbuettel.com/blog/2012/08/05/
