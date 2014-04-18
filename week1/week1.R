setwd("./Online Coursera/Coursera-Getting-and-Cleaning-Data")
getwd()
list.files()
if(!file.exists("data")) {
    dir.create("data")
}
list.files()
# download Baltimore camera data 
fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl, destfile="./data/cameras.csv", method="curl")
list.files("./data")
dateDownloaded <- date()
dateDownloaded
cameraData <- read.table("./data/cameras.csv", sep=",", header=TRUE)
head(cameraData)
fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xlsx?accessType=DOWNLOAD"
download.file(fileUrl, destfile="./data/cameras.xlsx", method="curl")
dateDownloaded <- date()
library(xlsx)
list.files()
cameraData <- read.xlsx("./data/cameras.xlsx", sheetIndex=1, header=TRUE)
head(cameraData)
colIndex <- 2:3
rowIndex <- 1:4
cameraDataSubset <- read.xlsx("./data/cameras.xlsx", sheetIndex=1, colIndex=colIndex, rowIndex=rowIndex)
cameraDataSubset
## Reading XML
library(XML)
fileUrl <- "http://www.w3schools.com/xml/simple.xml"
doc <- xmlTreeParse(fileUrl, useInternal=TRUE)
doc
rootNode <- xmlRoot(doc)
rootNode
xmlName(rootNode)
names(rootNode)
rootNode[[1]]
rootNode[[1]][[3]]
xmlSApply(rootNode, xmlValue)
xpathSApply(rootNode, "//name", xmlValue)
xpathSApply(rootNode, "//price", xmlValue)
xpathSApply(rootNode, "//description", xmlValue)
xpathSApply(rootNode, "//calories", xmlValue)
## Reading 
fileUrl <- "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
doc <- htmlTreeParse(fileUrl, useInternal=TRUE)
scores <- xpathSApply(doc, "//li[@class='score']", xmlValue)
teams <- xpathSApply(doc, "//li[@class='team-name']", xmlValue)
scores
teams
## Reading JSON
library(jsonlite)
jsonData <- fromJSON("https://api.github.com/users/jtleek/repos")
names(jsonData)
names(jsonData$owner)
jsonData$owner$login
myjson <- toJSON(iris, pretty=TRUE)
cat(myjson)
iris2 <- fromJSON(myjson)
head(iris2)
## Using data.table
library(data.table)
DF <- data.frame(x=rnorm(9), y=rep(c("a","b","c"), each=3), z=rnorm(9))
head(DF, 3)
DT <- data.table(x=rnorm(9), y=rep(c("a","b","c"), each=3), z=rnorm(9))
head(DT, 3)
DT[2, ]
DT[DT$y=="a", ]
DT[c(2, 3)]
DT[, c(2,3)] # not subsetting the columns
{
    x = 1
    y = 2
}
k = {print(10); 5} # 10
print(k) # 5
tables()
DT[, list(mean(x), sum(z))]
DT[, table(y)]
DT[, w:=z^2]
DT
DT2 <- DT
DT[, y:=2]
DT
DT2 # it is changed as well
head(DT, n=3)
DT[, m:={tmp <- (x+z); log2(tmp+5)}]
DT
DT2 # it is changed as well; they point to the same address
DT[, a:=x>0]
DT
DT[, b:=mean(x+w), by=a]
DT
set.seed(123)
DT <- data.table(x=sample(letters[1:3], 1E5, TRUE))
DT[, .N, by=x]
# keys
DT <- data.table(x=rep(c("a", "b", "c"), each=100), y=rnorm(300))
setkey(DT, x)
DT['a']
# use keys to do joins
DT1 <- data.table(x=c('a', 'a', 'b', 'dt1'), y=1:4)
DT2 <- data.table(x=c('a', 'b', 'dt2'), z=5:7)
setkey(DT1, x) 
setkey(DT2, x)
merge(DT1, DT2)
# use keys to fast reading
big_df <- data.frame(x=rnorm(1E6), y=rnorm(1E6))
file <- tempfile()
write.table(big_df, file=file, row.names=FALSE, col.names=TRUE, sep="\t", quote=FALSE)
system.time(fread(file))
system.time(read.table(file, header=TRUE, sep="\t")) # so slow
# Quiz 1
# Problem 1
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile="./data/microdata.csv", method="curl")
list.files("./data")
microData <- read.table("./data/microdata.csv", sep=",", header=TRUE)
head(microData)
dim(microData) # 6496x188
sum(!is.na(microData$VAL[microData$VAL==24])) # 53
# Problem 2
microData$FES
# Problem 3
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(fileUrl, destfile="./data/nga.xlsx", method="curl")
dateDownloaded <- date()
library(xlsx)
list.files("./data")
colIndex <- 7:15
rowIndex <- 18:23
dat <- read.xlsx("./data/nga.xlsx", sheetIndex=1, header=TRUE, colIndex=colIndex, rowIndex=rowIndex)
head(dat)
sum(dat$Zip*dat$Ext,na.rm=T) # 36534720
# Problem 4
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
doc <- xmlTreeParse(fileUrl, useInternal=TRUE)
doc
rootNode <- xmlRoot(doc)
rootNode
xmlName(rootNode)
names(rootNode)
sum(xpathSApply(rootNode, "//zipcode", xmlValue)==21231) # 127
# Problem 5
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl, destfile="./data/microdata3.csv", method="curl")
DT <- fread("./data/microdata3.csv")
file.info("./data/microdata3.csv")$size
system.time(DT[,mean(pwgtp15),by=SEX])
system.time(mean(DT[DT$SEX==1,]$pwgtp15))+system.time(mean(DT[DT$SEX==2,]$pwgtp15))
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
system.time(mean(DT$pwgtp15,by=DT$SEX))
system.time(tapply(DT$pwgtp15,DT$SEX,mean))
system.time(rowMeans(DT)[DT$SEX==1])+system.time(rowMeans(DT)[DT$SEX==2]
)
#A
st = proc.time()
for (i in 1:100){
  sapply(split(DT$pwgtp15,DT$SEX),mean)
}
print (proc.time() - st)

#B
st = proc.time()
for (i in 1:100){
  rowMeans(DT)[DT$SEX==1];rowMeans(DT)[DT$SEX==2]
}
print (proc.time() - st)

#C
st = proc.time()
for (i in 1:100){
  mean(DT$pwgtp15,by=DT$SEX)
}
print (proc.time() - st)

#D
st = proc.time()
for (i in 1:100){
  tapply(DT$pwgtp15,DT$SEX,mean)
}
print (proc.time() - st)

#E
st = proc.time()
for (i in 1:100){
  mean(DT[DT$SEX==1,]$pwgtp15);mean(DT[DT$SEX==2,]$pwgtp15)
}
print (proc.time() - st)

#F
st = proc.time()
for (i in 1:100){
  DT[,mean(pwgtp15),by=SEX]
}
print (proc.time() - st)