# IDEAS RePEC Historical Rankings - R shiny global file 
# Author: Stavros Poupakis 
# Date: 17-07-2019
# ----------------------------------------------------------------------

library(shiny)
library(ggplot2)
library(reshape2)
library(Hmisc)
library(tm)
library(plyr)
library(XML)


setwd("./")


load("rankings.institutions.Rdata")
data.instutions <- data.frame(t(rankings[,-1]))
data.instutions$date <- seq.Date(as.Date("2013-10-01"), by="1 month", length.out=dim(data.instutions)[1])
data.instutions <- melt(data.instutions, id="date")
levels(data.instutions$variable)<-rankings[,1]
k.instutions <- as.list(levels(data.instutions$variable))
names(k.instutions) <- levels(data.instutions$variable)
data.instutions100 <- data.instutions[data.instutions$date==data.instutions$date[length(data.instutions$date)],]
data.instutions100 <- data.instutions100[data.instutions100$value<=100,]
data.instutions100 <- data.instutions100[order(data.instutions100$value),]
top.instutions100    <- as.list(as.character(data.instutions100$variable))
names(top.instutions100) <- as.character(data.instutions100$variable)


load("rankings.journals.Rdata")
data.journals <- data.frame(t(rankings[,-1]))
data.journals$date <- seq.Date(as.Date("2013-10-01"), by="1 month", length.out=dim(data.journals)[1])
data.journals <- melt(data.journals, id="date")
levels(data.journals$variable)<-rankings[,1]
k.journals <- as.list(levels(data.journals$variable))
names(k.journals) <- levels(data.journals$variable)
data.journals100 <- data.journals[data.journals$date==data.journals$date[length(data.journals$date)],]
data.journals100 <- data.journals100[data.journals100$value<=100,]
data.journals100 <- data.journals100[order(data.journals100$value),]
top.journals100    <- as.list(as.character(data.journals100$variable))
names(top.journals100) <- as.character(data.journals100$variable)
