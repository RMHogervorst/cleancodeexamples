# NSE in dplyr
# dplyr (and many other packages )uses non standard evaluation. 
# But what does that mean?
# It is recommended to use the standard evalation of the functions for use
# in packages. so how does this work?
# 
# There are three ways to quote that dplyr understands:
# with a formula ~mean(mpg)
# with quote()   quote(mean(mpg))
# as a string  "mean(mpg)"
select(duo2015_tidy, OPLEIDINGSNAAM.ACTUEEL, FREQUENCY, YEAR, OPLEIDINGSFASE.ACTUEEL)
# standard
select_(duo2015_tidy, ~OPLEIDINGSNAAM.ACTUEEL)
select_(duo2015_tidy, ~OPLEIDINGSNAAM.ACTUEEL, ~FREQUENCY) # comma doesn't work, + doesn't work
select_(duo2015_tidy, quote(OPLEIDINGSNAAM.ACTUEEL, FREQUENCY, YEAR, OPLEIDINGSFASE.ACTUEEL)) # nope
select_(duo2015_tidy, quote(OPLEIDINGSNAAM.ACTUEEL), quote(FREQUENCY)) # yes!
select_(duo2015_tidy, "OPLEIDINGSNAAM.ACTUEEL", "FREQUENCY", "YEAR", "OPLEIDINGSFASE.ACTUEEL") # works

filter(duo2015_tidy, YEAR ==2015) %>% select(OPLEIDINGSNAAM.ACTUEEL, FREQUENCY)
filter_(duo2015_tidy, ~YEAR ==2015) %>% select_(~OPLEIDINGSNAAM.ACTUEEL, ~FREQUENCY)
filter_(duo2015_tidy, quote(YEAR ==2015)) %>% select_(~OPLEIDINGSNAAM.ACTUEEL, ~FREQUENCY)
filter_(duo2015_tidy, "YEAR ==2015") %>% select_(~OPLEIDINGSNAAM.ACTUEEL, ~FREQUENCY)
# or with a list to dots.
dotsfilter <- list(~OPLEIDINGSNAAM.ACTUEEL, ~FREQUENCY)
filter_(duo2015_tidy, "YEAR ==2015") %>% select_(.dots = dotsfilter)

#It's best to use a formula, because formula captures both expression and evnironment.
 
group_by(duo2015_tidy, GENDER) %>% summarise(total = n())
# group by in SE, and summarize with NSE
group_by_(duo2015_tidy, ~GENDER) %>% summarise(total = sum(FREQUENCY))
# both NSE, pass list of arguments to .dots
group_by_(duo2015_tidy, ~GENDER) %>% summarise_(.dots = list(~total = sum(FREQUENCY))) # does not work
group_by_(duo2015_tidy, ~GENDER) %>% summarise_(.dots = list(~sum(FREQUENCY))) # does work. 
dots <- list(~sum(FREQUENCY))
group_by_(duo2015_tidy, ~GENDER) %>% summarise_(.dots = dots)
group_by_(duo2015_tidy, ~GENDER) %>% summarise_(.dots = setNames(dots, "total"))
group_by_(duo2015_tidy, ~GENDER) %>% summarise_("sum(FREQUENCY)")
group_by_(duo2015_tidy, ~GENDER) %>% summarise_(~sum(FREQUENCY))

arrange()
#slice()
slice(mtcars, 1L) # eerste
# is identical but faster then filter(mtcars, row_number() == 1L)
slice(mtcars, n()) #laatste
# or filter(mtcars, row_number()==n())
slice(mtcars, 5:n()) # nr 5 tot laatste
#   filter(mtcars, between(row_number(), 5, n()))
transmute() # drops existing variables


mutate()


## example from NSE vignette in dplyr



# NSE version:
summarise(mtcars, mean(mpg))
#>   mean(mpg)
#> 1  20.09062

# SE versions:
summarise_(mtcars, ~mean(mpg))
#>   mean(mpg)
#> 1  20.09062
summarise_(mtcars, quote(mean(mpg)))
#>   mean(mpg)
#> 1  20.09062
summarise_(mtcars, "mean(mpg)")
#>   mean(mpg)
#> 1  20.09062


mtcars %>% mutate(new_col_name = col1 + col2)
mtcars %>% mutate(new_column = mpg + wt)

mtcars %>% mutate_(new_col_name = col1 + col2)
mtcars %>% mutate_(.dots = setNames(list(~mpg+wt), "sum mpg wt"))
mtcars %>% mutate_(.dots = list(~mpg+wt))
