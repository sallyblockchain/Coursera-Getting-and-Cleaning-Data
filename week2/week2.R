# Reading from mySQL
library(RMySQL)
# http://genome.ucsc.edu
ucscDb <- dbConnect(MySQL(), user="genome", host="genome-mysql.cse.ucsc.edu")
result <- dbGetQuery(ucscDb, "show databases;")
dbDisconnect(ucscDb)
result
hg19 <- dbConnect(MySQL(), user="genome", db="hg19", host="genome-mysql.cse.ucsc.edu")
allTables <- dbListTables(hg19)
length(allTables)
allTables[1:5]
dbListFields(hg19, "affyU133Plus2")
dbGetQuery(hg19, "select count(*) from affyU133Plus2")
dbGetQuery(hg19, "select * from affyU133Plus2 limit 1")
# Read from table
affyData <- dbReadTable(hg19, "affyU133Plus2")
head(affyData)
# Select a subset
query <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches 
                     between 1 and 3")
affyMis <- fetch(query)
quantile(affyMis$misMatches)
affyMisSmall <- fetch(query, n=10)
dbClearResult(query)
dim(affyMisSmall)
# Reading from HDF5
source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")
library(rhdf5)
created <- h5createFile("example.h5")
created
# Create groups
created <- h5createGroup("example.h5", "foo")
created <- h5createGroup("example.h5", "baa")
created <- h5createGroup("example.h5", "foo/foobaa")
h5ls("example.h5")
#  group   name     otype dclass dim
#    0     /         baa H5I_GROUP           
#    1     /         foo H5I_GROUP           
#    2    /foo      foobaa H5I_GROUP
# Write to groups
A <- matrix(1:10, nr=5, nc=2)
h5write(A, "example.h5", "foo/A")
B <- array(seq(0.1, 2.0, by=0.1), dim=c(5,2,2))
attr(B, "scale") <- "liter"
h5write(B, "example.h5", "foo/foobaa/B")
h5ls("example.h5")
#group   name   otype     dclass                 dim
# 0        /    baa      H5I_GROUP                  
# 1        /    foo      H5I_GROUP                  
# 2      /foo    A      H5I_DATASET INTEGER      5 x 2
# 3      /foo   foobaa   H5I_GROUP                  
# 4  /foo/foobaa  B    H5I_DATASET   FLOAT        5 x 2 x 2
# Write a data set
df <- data.frame(1L:5L, seq(0, 1, length.out=5),
                 c("ab", "cde","fghi","a","s"), stringsAsFactors=FALSE)
h5write(df, "example.h5", "df")
h5ls("example.h5")
# Reading data
readA <- h5read("example.h5", "foo/A")
readB <- h5read("example.h5", "foo/foobaa/B")
readdf <- h5read("example.h5", "df")
readA
readdf
# Writing and reading chunks
h5write(c(12, 13, 14), "example.h5", "foo/A", index=list(1:3, 1)) # row/col
h5read("example.h5", "foo/A")
# Reading from the web
# Getting data off webpages 
con <- url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode <- readLines(con)
close(con)
htmlCode
# Parsing with XML
library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html <- htmlTreeParse(url, useInternalNodes=T)
xpathSApply(html, "//title", xmlValue)
xpathSApply(html, "//td[@id='col-citedby']", xmlValue)
# GET from the httr package
library(httr)
html2 <- GET(url)
content2 <- content(html2, as="text")
parsedHTML <- htmlParse(content2, asText=TRUE)
xpathSApply(parsedHTML, "//title", xmlValue)
# Accessing websites with passwords
pg1 <- GET("http://httpbin.org/basic-auth/user/passwd")
pg1 # Status: 401
pg2 <- GET("http://httpbin.org/basic-auth/user/passwd", authenticate("user", "passwd"))
pg2 # Status: 200
names(pg2)
# Using handles
google <- handle("http://google.com")
pg1 <- GET(handle=google, path="/")
pg2 <- GET(handle=google, path="search")
# Reading data from APIs
# Accessing Twitter from R
myapp <- oauth_app("twitter", key="JAJfWyoYnKgvpdZe9jXIz5wDW", 
                   secret="tsmiqgWd4H51wc3TSvQ53cndpAYdoTM7F134WdGkjF7ZMZwK8E")
sig <- sign_oauth1.0(myapp, token="216575848-UXH6IIzFoolcJcPYBUCnt0DfuN43d8I0WvIVPTfs", 
                     token_secret="LBRQghqoa6mw3796Ul8z5DCd7Xl00WuNIpLgjZLAnwJj2")
homeTL <- GET("https://api.twitter.com/1.1/statuses/home_timeline.json", sig)
homeTL
library(jsonlite)
json1<-content(homeTL, "text", "\n")
json2<-jsonlite::fromJSON(json1)
json2[1:1:4]
# https://dev.twitter.com/docs/api/1.1/get/search/tweets
# https://dev.twitter.com/docs/api/1.1/overview
# httr: GET, POST, PUT, DELETE REQUESTS
# Reading from other sources
# data storage mechanism R package

# github ClientID:3dc7d0c76e4d3c7f567f 
# github ClientSecret:94eec748a4ab033f5e804cae07c8f2d4e292dc5f
# github Access Token:93d0e7b9a6f2b0c9add5bbe1ac5b1668f4d26b90


