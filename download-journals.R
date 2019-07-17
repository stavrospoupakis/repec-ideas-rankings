# R supplement code for Historical Rankings
# Summary: Downloads data and create table as a data.frame
# Author: Stavros Poupakis 
# Date: 17-07-2019
# ---------------------------------------------------------

library(tm)
library(plyr)
library(XML)
library(stringr)

# Set last month with available data (run after update on 5th)
last.month <- as.numeric(gsub("-","",substr(Sys.Date(),3,7)))-1 

# Define time period
range <- 1310:last.month
range <- range[which(as.numeric(substr(range,3,4))>=01 & as.numeric(substr(range,3,4))<=12)]


# Download files
for (i in range){
  download.file(paste('https://ideas.repec.org/top/old/',i,'/top.journals.all.html', sep=""),
                destfile= paste('rank', i, sep=""), method="wget")
  thepage = readLines(paste('rank', i, sep=""))
}



# Get most recent tables
nodes <- getNodeSet(htmlParse(paste("rank", range[length(range)], sep="")), "//table")
getHandles <- function(node, encoding) paste(xpathSApply(node, './a', xmlGetAttr, "name"), collapse = ",")
getRank    <- function(node, encoding) xmlValue(xmlChildren(node)$text)
journal <- readHTMLTable(nodes[[2]], elFun = getHandles)[,1]
rank    <- readHTMLTable(nodes[[2]], elFun = getRank)[,1]
for (j in 1:length(rank)) if(rank[j]=="---") rank[j]<-rank[j-1] 
rank    <- as.numeric(as.character(rank))
journal <- as.character(journal)
table <- data.frame(journal,rank, stringsAsFactors = F)
table <- table[table$journal!="",]
colnames(table) <- c("journal",paste("m",range[length(range)],sep=""))

journal.names <- data.frame(as.character(readHTMLTable(nodes[[2]])[,2])[as.character(readHTMLTable(nodes[[2]])[,2])!="Journals"], 
                            as.character(table[,1]))
colnames(journal.names) <- c("name", "journal")

# Make rankings dataframe of latest month
rankings <- data.frame(matrix(NA, nrow=dim(table)[1], ncol=2))
colnames(rankings) <- c("journal",paste("m",range[length(range)],sep=""))
rankings[,1][1:dim(table)[1]] <- as.character(table[,1])
rankings[,2][1:dim(table)[1]] <- table[,2]



# Past tables --------------------------------------


for (i in range[-length(range)]){

  
  # Get past months tables
  nodes <- getNodeSet(htmlParse(paste("rank", i, sep="")), "//table")
  getHandles <- function(node, encoding) paste(xpathSApply(node, './a', xmlGetAttr, "name"), collapse = ",")
  getRank    <- function(node, encoding) xmlValue(xmlChildren(node)$text)
  journal <- readHTMLTable(nodes[[2]], elFun = getHandles)[,1]
  rank    <- readHTMLTable(nodes[[2]], elFun = getRank)[,1]
  for (j in 1:length(rank)) if(rank[j]=="---") rank[j]<-rank[j-1] 
  rank <- as.numeric(as.character(rank))
  journal <- as.character(journal)
  table <- data.frame(journal, rank, stringsAsFactors = F)
  table <- table[table$journal!="",]
  colnames(table) <- c("journal",paste("m",i,sep=""))
  
  idx2 <- sapply(rankings$journal, grep, table$journal)
  idx1 <- sapply(seq_along(idx2), function(x) rep(x, length(idx2[[x]])))
  
  idy2 <- sapply(table$journal, grep, rankings$journal)
  idy1 <- sapply(seq_along(idy2), function(x) rep(x, length(idy2[[x]])))
  
  
  rankings <- rbind(merge(rankings,table,all = T),
                    cbind(rankings[unlist(idx1),,drop=F], table[unlist(idx2),2,drop=F]),
                    cbind(table[unlist(idy1),2,drop=F], rankings[unlist(idy2),,drop=F]))
  
  rankings <- rankings[order(rankings[,2],rankings[,dim(rankings)[2]]),]
  rankings <- rankings[!duplicated(rankings$journal),]
  print(i)
  

}

# Merge for names
rankings  <- merge(rankings,journal.names, by="journal", all=TRUE)
rankings <- rankings[,-1]
colnames(rankings)[length(colnames(rankings))] <- "journal"

# Final clean 
rankings<-rankings[,order(colnames(rankings),decreasing=FALSE)]
rankings<-rankings[rankings$journal!="" & is.na(rankings$journal)==FALSE,]


# Housekeeping (delete temp files)

dir()[grep("rank1",dir())]
file.remove(dir()[grep("rank1",dir())])

