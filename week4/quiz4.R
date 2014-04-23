## Quiz 4.
# Problem 1.
data <- read.csv("./data/microdata.csv")
names(data)[123]
strsplit(names(data)[123], "wgtp")
# [[1]]
# [1] ""   "15"
# Problem 2.
gdp_data <- read.csv("./data/gdp.csv")
cleaned_data <- gsub(",", "", gdp_data[5:194, 5])
num_data <- as.numeric(cleaned_data)
mean(num_data) 
# [1] 377652.4
# Problem 3.
countryNames <- gdp_data[5:194,4]
regexec("^United", countryNames)
# 3
# Problem 4. 
new_gdp_data <- gdp_data[6:194, c(1, 2, 4, 5)]
colnames(new_gdp_data) <- c("CountryCode", "Ranking", "Economy", "GDP")
rownames(new_gdp_data) <- NULL # renumbering
education_data <- read.csv("./data/education.csv")
names(education_data)
mergedData <- merge(new_gdp_data, education_data, by.x="CountryCode", by.y="CountryCode", all=TRUE)
head(mergedData)
names(mergedData) <- tolower(names(mergedData))
a <- as.character(mergedData[,13])
length(grep("Fiscal year end: June", a))
# 13
# Problem 5.
library(quantmod)
amzn <- getSymbols("AMZN",auto.assign=FALSE)
sampleTimes <- index(amzn)
length(sampleTimes)
bool1 <- year(sampleTimes) == 2012
length(sampleTimes[bool1]) # 250
bool2 <- weekdays(sampleTimes)=="Monday"
length(sampleTimes[bool1 & bool2]) # 47
