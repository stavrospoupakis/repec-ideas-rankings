# R supplement code for Historical Rankings
# Summary: Downloads data and create table as a data.frame
# Author: Stavros Poupakis 
# Date: 17-07-2019
# ---------------------------------------------------------

library(tm)
library(plyr)
library(XML)


# Set last month with available data (run after update on 5th)
last.month <- as.numeric(gsub("-","",substr(Sys.Date(),3,7)))-1 

# Define time period
range <- 1310:last.month
range <- range[which(as.numeric(substr(range,3,4))>=01 & as.numeric(substr(range,3,4))<=12)]


# Download files
for (i in range){
  download.file(paste('https://ideas.repec.org/top/old/',i,'/top.inst.all.html', sep=""),
                destfile= paste('rank', i, sep=""), method="wget")
  thepage = readLines(paste('rank', i, sep=""))
}

# Get tables
nodes <- getNodeSet(htmlParse(paste("rank", range[length(range)], sep="")), "//table")
getHandles <- function(node, encoding) paste(xpathSApply(node, './a', xmlGetAttr, "name"), collapse = ",")
getRank    <- function(node, encoding) xmlValue(xmlChildren(node)$text)
dept <- readHTMLTable(nodes[[2]], elFun = getHandles)[-1,1]
rank <- readHTMLTable(nodes[[2]], elFun = getRank)[-1,1]
for (j in 1:length(rank)) if(rank[j]=="---") rank[j]<-rank[j-1] 
rank <- as.numeric(as.character(rank))
table <- data.frame(dept,rank)
colnames(table) <- c("dept",paste("m",range[length(range)],sep=""))

dept.names <- data.frame(as.character(readHTMLTable(nodes[[2]])[,2])[-1], as.character(table[,1]))
colnames(dept.names) <- c("name", "dept")

# Make rankings dataframe of latest month
rankings <- data.frame(matrix(NA, nrow=1000, ncol=2))
colnames(rankings) <- c("dept",paste("m",range[length(range)],sep=""))
rankings[,1][1:dim(table)[1]] <- as.character(table[,1])
rankings[,2][1:dim(table)[1]] <- table[,2]


# Past tables --------------------------------------

for (i in range[-length(range)]){

  nodes <- getNodeSet(htmlParse(paste("rank", i, sep="")), "//table")
  dept <- readHTMLTable(nodes[[2]], elFun = getHandles)[-1,1]
  rank <- readHTMLTable(nodes[[2]], elFun = getRank)[-1,1]
  for (j in 1:length(rank)) if(rank[j]=="---") rank[j]<-rank[j-1] 
  rank <- as.numeric(as.character(rank))
  table <- data.frame(dept,rank)
  colnames(table) <- c("dept",paste("m",i,sep=""))
  
  rankings  <- merge(rankings,table, by="dept", all=TRUE)
  print(i)
  
}

# Merge for names
rankings  <- merge(rankings,dept.names, by="dept", all=TRUE)
rankings <- rankings[,-1]
colnames(rankings)[length(colnames(rankings))] <- "dept"

# Final clean 
rankings<-rankings[,order(colnames(rankings),decreasing=FALSE)]
rankings<-rankings[rankings$dept!="" & is.na(rankings$dept)==FALSE,]


# Housekeeping (delete temp files)

dir()[grep("rank1",dir())]
file.remove(dir()[grep("rank1",dir())])


