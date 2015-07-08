#attach the data
attach(total)

#check names
names(total)

#matrix scatterplot of overview
plot(total)

#To fit a multiple linear regression model with repository as the response variable 
#and commits, committers, authors as the explanatory variables:
result = lm(id~ Commits + Committers + Authors + Files, data=total)
result

# We can access the results of each test by:
summary(result)

#Scatterplot of Committers against Authors
plot(Committers, Authors, main="Authors & Committers Scatterplot")

#calculate pearson correlation between the variables
cor(Committers, Authors, method="pearson")

#fit a linear regression using lm(linear model) command
#fit linear regression to the data and save it in an object
m1<-lm(Authors ~ Committers)

#to see the summary
summary(m1)

#to add regression line
abline(m1, col=2, lwd=2)

#to produce diagnostics plot
plot(m1)

#diaplaying 4plots on a screen
par(mfrow=c(2,2))
plot(m1)
