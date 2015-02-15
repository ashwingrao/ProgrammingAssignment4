source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")
library(rhdf5)
hd_handle <- h5createFile("example.h5")
hd_handle
hd_handle <- h5createGroup("example.h5","foo")
hd_handle <- h5createGroup("example.h5","baa")
hd_handle <- h5createGroup("example.h5","foo/foobaa")
h5ls("example.h5")
A <- matrix(1:10, nr=5, nc=2)
h5write(A,"example.h5", "foo/A")
B <- array(seq(0.1,2.0, by=0.1), dim=c(5,2,2))
attr(B,"scale") <- "liter"
h5write(B,"example.h5", "foo/foobaa/B")
h5ls("example.h5")
df <- data.frame(1L:5L, seq(0,1,length.out = 5), c("ab","cde", "fghi", "a", "s"), stringsAsFactors = FALSE)
h5write(df, "example.h5", "df")
readA <- h5read("example.h5","foo/A")
readB <- h5read("example.h5", "foo/foobaa/B")
readdf <- h5read("example.h5", "df")
readA
readB
readdf
h5write(c(12,13,14), "example.h5", "foo/A", index = list(1:3,1))
h5read("example.h5", "foo/A")
con=url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode <- readLines(con)
close(con)
htmlCode

library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html <- htmlTreeParse(url, useInternalNodes = T)

xpathApply(html,"//title", xmlValue)
test <- xpathApply(html,"//td[@id='col-citedby']", xmlValue)
test

html

install.packages("httr")
library(httr)
html2<- GET(url)
content2 <- content(html2, as="text")
parsedHtml <- htmlParse(content2,asText=TRUE)
xpathSApply(parsedHtml, "//title", xmlValue)

pg1 <- GET("http://httpbin.org/hidden-basic-auth/user/passwd")
pg1
pg2 <- GET("http://httpbin.org/basic-auth/user/passwd", authenticate("user","passwd"))

names(pg2)

content2 <- content(pg2, as="text")
parsedHtml <- htmlParse(content2,asText=TRUE)
xpathSApply(parsedHtml, "//body", xmlValue)
test <- xpathApply(html,"//td[@id='col-citedby']", xmlValue)

google <- handle("http://google.com")
pg1 <- GET(handle=google, path="/")
pg2 <- GET(handle=google, path="search")
test
content3 <- content(pg2, as="text")
parsedHtml <- htmlParse(content3,asText=TRUE)


library(jsonlite)
myapp <- oauth_app("twitter", key="g4pnENYkxZ8P9QzW7HDrU0ase", secret="YBm0P6S5tXaULyEXWVwY8zvaFOzviP5Y35cEfizcPpEHEetpuY")
sig<- sign_oauth1.0(myapp, token= "17581520-5bQYx8NXDZAS40y9gCP42AvTPoDI4vQ2cT3O8eBHu", token_secret= "DWNFW1Wg5G0CewRLApyhUTuvgwUMuWkw9ZDknx4Sg9SAM")
homeTL <- GET("https://api.twitter.com/1.1/search/tweets.json?q=ashwingrao", sig)
json1 <- content(homeTL, as="text")
json2 <- jsonlite::fromJSON(jsonlite::toJSON(json1))
parsedHtml <- htmlParse(content3,asText=TRUE)
test <- xpathApply(parsedHtml,"//td[@id='text']", xmlValue)
x <- GET("http://httpbin.org/drip?numbytes=10000&duration=1", progress())
url_success("http://mail.google.com")
url_success("http://httpbin.org/status/200")
url_success("http://httpbin.org/status/201")
url_success("http://httpbin.org/status/300")
GET("http://had.co.nz", use_proxy("64.251.21.73", 8080), verbose())


rm(list=ls())
install.packages("httr")
library(httr)

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

## Found this on the web
##github <- oauth_endpoint(NULL, "authorize", "access_token",
##  base_url = "https://github.com/login/oauth")

# 2. Register an application at https://github.com/settings/applications;
#    Use any URL you would like for the homepage URL (http://github.com is fine)
#    and http://localhost:1410 as the callback url
#
#    Insert your client ID and secret below - if secret is omitted, it will
#    look it up in the GITHUB_CONSUMER_SECRET environmental variable.
myapp <- oauth_app("github", key = "644a9e346d5caf938eb0", secret = "3d76ddea5c400e87c3e727558a3bed7059e3cd9c" )

## 
# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
content(req)

install.packages("devtools")
library(devtools)
library(jsonlite)
library(httr)
auth_endpoint <- oauth_endpoints("github")
myapp <- oauth_app("github", key = "644a9e346d5caf938eb0", secret = "3d76ddea5c400e87c3e727558a3bed7059e3cd9c" )
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
con=file("http://biostat.jhsph.edu/~jleek/contact.html",open="r")
line=readLines(con)
close(con)
long=length(line)
for (i in c(10,20,30,100)){
  
  print(nchar(line[i]))
}



fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileURL, destfile="quiz2Q2.csv", method="curl")

install.packages("sqldf")
library(tcltk)
library(sqldf)
acs <- read.csv(file="quiz2Q2.csv")
head(acs[which(acs$AGEP < 50),]$pwgtp1)
head(sqldf("select pwgtp1 from acs where AGEP < 50")$pwgtp1)

library(XML)
library(HTML)
jleek_html <- htmlTreeParse("http://biostat.jhsph.edu/~jleek/contact.html",
                            useInternal = TRUE)
# Extract all the paragraphs (HTML tag is p, starting at
# the root of the document). Unlist flattens the list to
# create a character vector.
doc.text = unlist(xpathApply(jleek_html, '//p', xmlValue))
# Replace all \n by spaces
doc.text = gsub('\\n', ' ', doc.text)
setwd("~/Documents/DropBox-AGR/Dropbox//Git//coursera//MySql")
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for" 
download.file(fileURL, destfile="quiz2Q5.txt", method="curl")
x<- read.fwf("quiz2Q5.txt", skip=4, widths=c(12, 7,4, 9,4, 9,4, 9,4))
head(x)
x[1,2]
names(x)
sqldf("select sum(v4) from x")
sum(x$V4)
