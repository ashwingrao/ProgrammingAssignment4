install.packages("RMySQL")
library(RMySQL)
ucscDb <- dbConnect(MySQL(), user="genome", host="genome-mysql.cse.ucsc.edu")
result <- dbGetQuery(ucscDb, "show databases;")
dbDisconnect(ucscDb)
hg19 <- dbConnect(MySQL(), user="genome", db="hg19", host="genome-mysql.cse.ucsc.edu")
allTables <- dbListTables(hg19)
length(allTables)
allTables[1:5]
dbListFields(hg19, "affyU133Plus2")
dbGetQuery(hg19, "select count(*) from affyU133Plus2")
affyData <- dbReadTable(hg19, "affyU133Plus2")
head affyData

dbReadMap <- function(con,table){
  statement <- paste("DESCRIBE ",table,sep="")
  desc <- dbGetQuery(con=con,statement)[,1:2]
  
  # strip row_names if exists because it's an attribute and not real column
  # otherweise it causes problems with the row count if the table has a row_names col
  if(length(grep(pattern="row_names",x=desc)) != 0){
    x <- grep(pattern="row_names",x=desc)
    desc <- desc[-x,]
  }
  
  
  
  # replace length output in brackets that is returned by describe
  desc[,2] <- gsub("[^a-z]","",desc[,2])
  
  # building a dictionary 
  fieldtypes <- c("int","tinyint","bigint","float","double","date","character","varchar","text")
  rclasses <- c("as.numeric","as.numeric","as.numeric","as.numeric","as.numeric","as.Date","as.character","as.character","as.character") 
  fieldtype_to_rclass = cbind(fieldtypes,rclasses)
  
  map <- merge(fieldtype_to_rclass,desc,by.x="fieldtypes",by.y="Type")
  map$rclasses <- as.character(map$rclasses)
  #get data
  res <- dbReadTable(con=con,table)
  
  
  
  i=1
  for(i in 1:length(map$rclasses)) {
    cvn <- call(map$rclasses[i],res[,map$Field[i]])
    res[map$Field[i]] <- eval(cvn)
  }
  
  
  return(res)
}

affyData <- dbReadMap(hg19, "affyU133Plus2")
head (affyData)

query <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3")
affyMiss <- fetch(query)
quantile(affyMiss$misMatches)

affyMissSmall <- fetch(query, n=10); dbClearResult(query)
dim(affyMissSmall)
dbDisconnect(hg19)
