###############################################
# Introduction to GGPLOT2 part 1
# for the series: from spss to r
# 2016-02-24 RMHogervorst
# 
 

# in ggplot 
# qplot
# ggplot

library(ggplot)

# is many layers on top of each other Most basic example, using the build-in
# data set: mtcars. According to ?mtcars: "The data was extracted from the 1974
# Motor Trend US magazine, and comprises fuel consumption and 10 aspects of
# automobile design and performance for 32 automobiles (1973–74 models)."
#
# We will first start with a simple scatterplot
ggplot(data = mtcars, aes(x= mpg, y= wt) ) + geom_point() #or:
ggplot() + geom_point(data = mtcars, aes(x= mpg, y= wt) )
# We started a new plot with the ggplot command. Then we add a point element. 
# Now let's add color
ggplot(data = mtcars, aes(x= mpg, y= wt )) + geom_point( color = "red" )
# or set the color to an other variable in mtcars.
str(mtcars)
ggplot(data = mtcars, aes(mpg,  wt )) + geom_point(aes(color = gear)) # first is x second is y
# SO let's look back. 
# We have a ggplot element that starts the plot.
# Then we add a "geom" a geometric representation of data. There are points, histograms 
# lines etc. We tell the plot where the data is and give it some aestetics,
# x and y (for the axis). But we can add more aestetics f.i. color: 
# with aes(color= name of variable) the color changes based on that variable.
# 
# However...
# the color goes from light blue to dark blue...
# Because ggplot2 thinks that gear is a numeric variable. 
# But no one has 3,5 gears, not even in 1974.
# let's check
table(mtcars$gear)
# nope, 3,4, or 5 gears. Lets turn that into factors.
ggplot(data = mtcars) + geom_point( aes(x= mpg, y= wt, color = as.factor(gear) ))
# Factor variables are distinct and the colors are as distinct as possible too.
# Look back at the plot you created, there seems to be a relation between weight 
# and miles per gallon. Let's plot a smooth line on top of that.
ggplot(data = mtcars, aes(x= mpg, y= wt, group = as.factor(gear))) + 
        geom_point(aes( color = as.factor(gear) )) +
        geom_smooth(method = lm) # a linear model Y ~ x smoothing
# As you add layers, each layer has their elements specified by you
# or inherits them from the base element (ggplot()).
# In the above example geom_smooth inherits aes(x, y) from
#  ggplot(data = mtcars, aes(x= mpg, y= wt)).
ggplot()+geom_point(data = mtcars, aes(x= mpg, y= wt)) +geom_smooth(method = lm)
# this doesn't work. The smoothing layer doesn't know wher to find its x and y.
# But if we specify those, it will work.
ggplot()+geom_point(data = mtcars, aes(x= mpg, y= wt)) +
        geom_smooth(data = mtcars, aes(x= mpg, y= wt), method = lm)
# So think about that when you build a plot.
# 
# Let's look at some other geoms
# 
# http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_%28ggplot2%29/
# 
# bargraph
ggplot(data = mtcars, aes(as.factor(cyl))) + geom_bar(stat ="count")
# identity case
dat<-data.frame(
        Name = c("hork", "dork", "bork"),
        Frequency = c(5, 8,12)
)
ggplot(dat, aes(Name, Frequency)) + geom_bar(stat ="identity")

ggplot(chickwts, aes(feed, weight)) + geom_boxplot()
ggplot(chickwts, aes(feed, weight)) + geom_violin()

ggplot(chickwts, aes(feed, weight)) + geom_point()
ggplot(chickwts, aes(feed, weight)) + geom_jitter()

ggplot(chickwts, aes(feed, weight)) + geom_boxplot() + geom_jitter()
ggplot(chickwts, aes(feed, weight)) + geom_boxplot() + geom_point()

ggplot(chickwts, aes(feed, weight)) + geom_violin() + geom_jitter()

ggplot(mtcars, aes(as.factor(cyl), mpg)) +geom_boxplot() +geom_point()
ggplot(mtcars, aes(as.factor(cyl), mpg)) +geom_violin() +geom_jitter( aes(color = as.factor(am)))


g <- ggplot(mtcars, aes(as.factor(cyl), mpg)) +geom_violin() +geom_jitter( aes(color = as.factor(am)))
g + theme_bw()
g + theme_dark()
g + theme_void()

library(ggthemes)
g + theme_wsj()
g + theme_tufte()  # very clean theme based on edward tufte 's ideas about graphs
g + theme_base()
g + theme_excel()  # you will love this, especially the description
g + theme_fivethirtyeight()

# Many more examples in cookbook for r. Really good. 
# IN next lesson we will use the real world data about students in Dutch Universities.
