## Subsetting and sorting
set.seed(13435)
X <- data.frame("var1"=sample(1:5), "var2"=sample(6:10), "var3"=sample(11:15))
X <- X[sample(1:5), ]
X$var2[c(1,3)] <- NA
X
X[, 1]
X[, "var1"]
X[1:2, "var2"]
X[(X$var1 <= 3 & X$var3 > 11), ]
X[(X$var1 <= 3 | X$var3 > 15), ]
# missing values
X[(X$var2 > 8), ]
X[which(X$var2 > 8), ]
# Sorting
sort(X$var1)
sort(X$var1, decreasing=T)
sort(X$var2, na.last=T) # 6  9 10 NA NA
# Ordering
X[order(X$var1), ]
X[order(X$var1, X$var3), ]
# Ordering with plyr
library(plyr)
arrange(X, var1)
arrange(X, desc(var1))
# Adding rows and columns
X$var4 <- rnorm(5)
X
Y <- cbind(X, rnorm(5))
Y
## Summarizing data
# https://data.baltimorecity.gov/Community/Restaurants/k5ry-ef3g
getwd()
setwd("~/Desktop/Online Coursera/Coursera-Getting-and-Cleaning-Data/")
list.files()
fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl, destfile="./data/restaurants.csv", method="curl")
restData <- read.csv("./data/restaurants.csv")
dim(restData)
head(restData, n=3)
tail(restData, n=3)
summary(restData)
str(restData)
quantile(restData$councilDistrict, na.rm=T)
quantile(restData$councilDistrict, probs=c(0.5, 0.75, 0.9))
table(restData$zipCode, useNA="ifany")
table(restData$councilDistrict, restData$zipCode)
# Check for missing values
sum(is.na(restData$councilDistrict))
any(is.na(restData$councilDistrict))
all(restData$zipCode > 0) # FALSE
colSums(is.na(restData)) # 0
all(colSums(is.na(restData))==0) # TRUE: no missing values
# Values with specific characteristics
table(restData$zipCode %in% c("21212"))
table(restData$zipCode %in% c("21212", "21213"))
restData[restData$zipCode %in% c("21212", "21213"), ]
# Cross tabs
data(UCBAdmissions)
DF <- as.data.frame(UCBAdmissions)
summary(DF)
xt <- xtabs(Freq ~ Gender + Admit, data=DF)
xt
# Flat tables
warpbreaks$replicate <- rep(1:9, len = 54)
xt <- xtabs(breaks ~., data=warpbreaks)
xt
ftable(xt)
# Size of a dataset
fakeData <- rnorm(1e5)
object.size(fakeData)
print(object.size(fakeData), units="Mb")

## Creating new variables
# Creating sequences
s1 <- seq(1, 10, by=2)
s1
s2 <- seq(1, 10, length=3)
s2
x <- c(1, 3, 8, 25, 100)
seq(along=x)
# Subsetting variables
restData$nearMe <- restData$neighborhood %in% c("Roland Park", "Homeland")
table(restData$nearMe)
# Creating binary variables
restData$zipWrong <- ifelse(restData$zipCode < 0, TRUE, FALSE)
table(restData$zipWrong, restData$zipCode < 0)
# Creating categorical variables
restData$zipGroup <- cut(restData$zipCode, breaks=quantile(restData$zipCode))
table(restData$zipGroup)
table(restData$zipGroup, restData$zipCode)
# Easier cutting
library(Hmisc)
restData$zipGroups <- cut2(restData$zipCode, g=4)
restData$zcf <- factor(restData$zipCode)
restData$zcf[1:10]
class(restData$zcf)
# Levels of factor variables
yesno <- sample(c("yes", "no"), size=10, replace=TRUE)
yesnofac <- factor(yesno, levels=c("yes", "no")) # low-level, high-level
relevel(yesnofac, ref="yes")
as.numeric(yesnofac)
# Cutting produces factor variables
library(Hmisc)
restData$zipGroups <- cut2(restData$zipCode, g=4)
table(restData$zipGroups)
# Using the mutate function
restData2 <- mutate(restData, zipGroups=cut2(zipCode, g=4))
table(restData2$zipGroups)
#[-21226,21205) [ 21205,21220) [ 21220,21227) [ 21227,21287] 
#338            375            300            314 

## Reshaping data
#
library(reshape2)
head(mtcars)
# Melting data frames
mtcars$carname <- rownames(mtcars)
carMelt <- melt(mtcars, id=c("carname", "gear", "cyl"), measure.vars=c("mpg", "hp"))
head(carMelt, n=3)
tail(carMelt, n=3)
# Casting data frames
cylData <- dcast(carMelt, cyl ~ variable)
cylData
cylData <- dcast(carMelt, cyl ~ variable, mean)
cylData
# Averaging values
head(InsectSprays)
tapply(InsectSprays$count, InsectSprays$spray, sum)
# Another way - split
spIns <- split(InsectSprays$count, InsectSprays$spray)
spIns
# Another way - apply
sprCount <- lapply(spIns, sum)
sprCount
# Another way - combine
unlist(sprCount)
sapply(spIns, sum)
# Another way - plyr package
ddply(InsectSprays,.(spray), summarize, sum=sum(count))
# Creating a new variable
spraySums <- ddply(InsectSprays, .(spray), summarize, sum=ave(count, FUN=sum))
dim(spraySums)
head(spraySums)

## Merging data
fileUrl1 <- "https://dl.dropboxusercontent.com/u/7710864/data/reviews-apr29.csv"
fileUrl2 <- "https://dl.dropboxusercontent.com/u/7710864/data/solutions-apr29.csv"
download.file(fileUrl1, destfile="./data/reviews.csv", method="curl")
download.file(fileUrl2, destfile="./data/solutions.csv", method="curl")
reviews <- read.csv("./data/reviews.csv")
solutions <- read.csv("./data/solutions.csv")
head(reviews, 2)
head(solutions, 2)
# merge()
names(reviews) # solution_id
names(solutions) # problem_id
mergeData <- merge(reviews, solutions, by.x="solution_id", by.y="id", all=TRUE)
head(mergeData)
# merge all common column names
intersect(names(solutions), names(reviews))
mergedData2 <- merge(reviews, solutions, all=TRUE)
head(mergedData2)
# Using join in the plyr package
df1 <- data.frame(id=sample(1:10), x=rnorm(10))
df2 <- data.frame(id=sample(1:10), y=rnorm(10))
arrange(join(df1, df2), id)
# If you have multiple data fraomes
df1 <- data.frame(id=sample(1:10), x=rnorm(10))
df2 <- data.frame(id=sample(1:10), y=rnorm(10))
df3 <- data.frame(id=sample(1:10), z=rnorm(10))
dfList <- list(df1, df2, df3)
join_all(dfList)
