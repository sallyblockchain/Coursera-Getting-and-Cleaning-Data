# Quiz 2.
# Problem 1.
library(httr)
oauth_endpoints("github")
# 
myapp <- oauth_app("github", "ClientID", "ClientSecret")
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)
req <- GET("https://api.github.com/rate_limit", config(token = github_token))
stop_for_status(req)
content(req)
# curl -u Access Token:x-oauth-basic "https://api.github.com/users/jtleek/repos"
BROWSE("https://api.github.com/users/jtleek/repos",authenticate("Access Token","x-oauth-basic","basic"))
# 2013-11-07T13:25:07Z

# Problem 2.
library(sqldf)
setwd("~/Desktop/Online Coursera/Coursera-Getting-and-Cleaning-Data/week2/data/")
acs <- read.csv("./getdata-data-ss06pid.csv", header=T, sep=",")
head(acs)
sqldf("select pwgtp1 from acs where AGEP < 50")
# Problem 3.
sqldf("select distinct AGEP from acs")
length(unique(acs$AGEP)) # 91
# Problem 4.
hurl <- "http://biostat.jhsph.edu/~jleek/contact.html" 
con <- url(hurl)
htmlCode <- readLines(con)
close(con)
sapply(htmlCode[c(10, 20, 30, 100)], nchar)
#<meta name="Distribution" content="Global" /> 
#    45 
#<script type="text/javascript"> 
#    31 
#})(); 
#7 
#\t\t\t\t<ul class="sidemenu"> 
#    25
# Problem 5.
list.files()
data <- read.csv("./getdata-wksst8110.for", header=T)
head(data)
dim(data)
file_name <- "./getdata-wksst8110.for"
df <- read.fwf(file=file_name,widths=c(-1,9,-5,4,4,-5,4,4,-5,4,4,-5,4,4), skip=4)
head(df)
sum(df[, 4])
# 32426.7