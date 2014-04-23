## Edting text variables
# Fixing character vectors - tolower(), toupper()
setwd("./Online Coursera/Coursera-Getting-and-Cleaning-Data/")
cameraData <- read.csv("./data/cameras.csv")
names(cameraData)
tolower(names(cameraData))
# - strsplit()
splitNames <- strsplit(names(cameraData), "\\.")
splitNames[[5]]
splitNames[[6]]
# Quick aside - lists
mylist <- list(letters=c("A","B","C"), numbers=1:3, matrix(1:25, ncol=5)) 
mylist
mylist[1]
mylist$letters # [1] "A" "B" "C"
mylist[[1]] # [1] "A" "B" "C"
# - sapply()
splitNames[[6]][1]
firstElement <- function(x) {x[1]}
sapply(splitNames, firstElement)
reviews <- read.csv("./data/reviews.csv")
solutions <- read.csv("./data/solutions.csv")
head(reviews, 2)
head(solutions, 2)
# - sub()
names(reviews)
sub("_", "", names(reviews))
# - gsub()
testName <- "this_is_a_test"
sub("_", "", testName)
gsub("_" ,"", testName)
# Finding values - grep(), grepl()
grep("Alameda", cameraData$intersection)
table(grepl("Alameda", cameraData$intersection))
cameraData2 <- cameraData[!grepl("Alameda", cameraData$intersection),]
grep("Alameda", cameraData$intersection, value=T)
grep("JeffStreet", cameraData$intersection)
length(grep("JeffStreet", cameraData$intersection)) # 0
# Useful string functions
library(stringr)
nchar("Jeffery Leek")
substr("Jeffery Leek", 1, 7)
paste("Jeffery", "Leek") # [1] "Jeffery Leek"
paste0("Jeffery", "Leek") # [1] "JefferyLeek"
str_trim("Jeff       ") # [1] "Jeff"

## Regular Expressions
^i think
morning$
[Bb][Uu][Ss][Hh]
^[Ii] am
^[0-9][a-zA-Z]
[^?.]$
9.12
flood|fire
^[Gg]ood|[Bb]ad
^([Gg]ood|[Bb]ad)
[Gg]eorge( [Ww]\.)? [Bb]ush # dot here is a literal dot, not a metacharacter
(.*)
[0-9]+ (.*)[0-9]+
[Bb]ush( +[^ ]+ +){1, 5} dubate # number of words in between:1 to 5
+([a-zA-z]+) +\1 + # replication of a particular word
^s(.*)s # greedy
^s(.*?)s # not that greedy

## Dates
d1 <- date()
d1
class(d1) # [1] "character"
d2 <- Sys.Date()
d2
class(d2) # [1] "Date"
# Formatting dates
format(d2, "%a %b %d")
# Creating dates
x <- c("1jan1960", "2jan1960", "31mar1960", "30jul1960")
z <- as.Date(x, "%d%b%Y")
z
z[1]-z[2] # Time difference of -1 days
as.numeric(z[1]-z[2]) # -1
# Converting to Julian
weekdays(d2)
months(d2)
julian(d2)
# Lubridate
library(lubridate)
ymd("20140422")
ymd("20142204") # [1] NA
mdy("08/04/2013")
dmy("02-04-2013")
# Dealing with times
ymd_hms("2013-08-09 10:15:03")
ymd_hms("2013-08-09 10:15:03", tz="Pacific/Auckland")
?Sys.timezone
# 
x <- dmy(c("1jan1960", "2jan1960", "31mar1960", "30jul1960"))
wday(x[1])
wday(x[1], label=T)
# POSIXct, POSIXlt

## Data Resources
# Gapminder.com
# Survey data: asdfree.com
