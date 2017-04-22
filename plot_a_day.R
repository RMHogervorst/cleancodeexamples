# making a plot a day
# 
# Relationship: two variables  ###
# scatterplot. start with dataset iris
library(ggplot2)
library(dplyr)
ggplot(data = iris)+
        geom_point(aes(Sepal.Length, Petal.Length))

ggplot(data = mtcars)+
        geom_point(aes(mpg, drat))
# dich: am, vs, 
# ord: gear, carb, cyl
# numeric: mpg, disp, hp, drat, wt, qsec
# # adding a bit more information
ggplot(data = mtcars)+
        geom_point(aes(mpg, drat, color = wt, alpha = cyl, size = vs))
# three variables
# bubble chart https://stackoverflow.com/questions/26757026/bubble-chart-with-ggplot2
# with plotly: https://plot.ly/r/bubble-charts/
# other example: http://flowingdata.com/2010/11/23/how-to-make-bubble-charts/ 
# multiple variables. 
# 
# adding color
# hue  (hue and color see stackoverflow)
# https://stackoverflow.com/questions/39249457/how-can-i-combine-alpha-and-color-in-one-legend/39250295#39250295
# 
# Distribution ####
# - single variable:
# -- histogram
# -- line histogram (density plot)
# 
# - two variables 
# -- scatterplot
# - three variables
# -- 3d area chart (hier ben ik niet zo zeker van.)
# 
# Composition ####
# I FIND MOST OF THESE CHARTS UGLY AND NOT USEFUL, BUT I WILL CREATE THEM AND 
# SEE IF I CAN FIND BETTER ALTERNATIVES.
# - changing over time
# -- few periods
# --- only relative differences matter : stacked 100% column chart
# --- both relative and absolute differences matter : stacked column chart
# -- many periods
# --- only relative differences matter :stacked 100% area chart
# --- both relative and absolute differences matter : stacked area chart
# - static over time
# -- simple share of total...... pie chart
# -- accumalation of total chart :waterfall chart 
# -- components of components 
# 
# Comparison ####
# - among items
# -- two variables per item: variable width column chart
# -- one variable per item
# ---many categories table or small multiples
# --- few categories 
# ---- many items : bar chart
# ---- few items : column chart
# - over time
# --many periods
# --- cyclical data:  radial chart/ circular area chart
####weather data over time?
# --- non cyclical data: line chart
# -- few periods
# --- single or few categories: column chart
# --- many categories  line chart.
#### gapminder data
library(gapminder)
gapminder %>% names()
#  "country"   "continent" "year"      "lifeExp"  
#  "pop"       "gdpPercap"
gapminder %>% 
        filter(country == "Netherlands") %>% 
        ggplot()+ geom_line(aes(year, pop, color = lifeExp))
gapminder %>% 
        filter(country == "Belgium") %>% 
        ggplot()+ geom_line(aes(year, pop, color = lifeExp))
gapminder %>% 
        filter(country == "Germany") %>% 
        ggplot()+ geom_line(aes(year, pop, color = lifeExp))
gapminder %>% 
        filter(continent == "Europe") %>% 
        ggplot()+ geom_line(aes(year, pop, color = country))
# becomes problematic with so many countries
# more trouble. populations are of course hugely different. 
# also colors are no longer useful. 
# 
gapminder %>% 
        filter(continent == "Europe") %>% 
        ggplot()+ geom_line(aes(year, pop, group = country))+
        geom_smooth(aes(year, pop))
# make lines thinner
gapminder %>% 
        filter(continent == "Europe") %>% 
        ggplot()+ geom_line(aes(year, pop, group = country), alpha = 4/5)+
        geom_smooth(aes(year, pop))
# change into percentages.
# I thought starting number as would be nice
gapminder %>% 
        filter(continent == "Europe") %>% 
        group_by(country) %>%
        mutate(rel_pop_gain = pop - first(pop)) %>% 
        ggplot()+geom_line(aes(year, rel_pop_gain, group = country))+
        geom_smooth(aes(year, rel_pop_gain))

# other option is to use middle of chart. say 1975?
gapminder %>% 
        filter(continent == "Europe") %>% 
        group_by(country) %>%
        mutate(rel_pop_gain = pop - nth(pop, 6)) %>% 
        ggplot()+geom_line(aes(year, rel_pop_gain, group = country))+
        geom_smooth(aes(year, rel_pop_gain))
# then perhaps a percentage?
# 
# who is the big increasing one?
gapminder %>% 
        filter(continent == "Europe") %>% 
        group_by(country) %>%
        mutate(rel_pop_gain = pop - first(pop)) %>% 
        ungroup() %>% 
        arrange(rel_pop_gain) %>% 
        tail()
# turkey?
gapminder %>% 
        filter(continent == "Europe") %>% 
        group_by(country) %>%
        mutate(rel_pop_gain = pop - first(pop)) %>% 
        ggplot()+geom_line(aes(year, rel_pop_gain, 
                               group = country, color = country == "Turkey"))
# yep it is turkey.
