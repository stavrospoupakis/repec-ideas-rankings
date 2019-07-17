# R main code for Historical Rankings
# Summary: Downloads tables from IDEAS, creates dataset and runs shiny app
# Author: Stavros Poupakis 
# Last modified: 16-07-2019
# ----------------------------------------------------------------------

# The project directory "ideas-repec-rankings" contains: main.R and download-*.R files
# In "ideas-repec-rankings" is a folder named "ideas-repec-rankings" (the shiny app) with: global.R, server.R, ui.R

rm(list=ls())
setwd("./")

# Download and prepare Rdata for Institutions Rankings
source("download-institutions.R")
save(rankings,file="./econrankings/rankings.institutions.Rdata")

# Download and prepare Rdata for Journals Rankings
source("download-journals.R")
save(rankings,file="./econrankings/rankings.journals.Rdata")

# Run shiny app 
runApp("./econrankings")
