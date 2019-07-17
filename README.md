# ideas-repec-rankings
IDEAS/RePEc Aggregate Rankings for Top Institutions and Journals

This is the code to replicate the shiny application found in [RePEc/IDEAS historical rankings: Top Institutions and Journals (Aggregate rankings all years)](https://spoupakis.shinyapps.io/rerepec-ideas-rankings). The user can plot the ranking of each institution or journal over the last years (starting October 2013 - RePEC data format is different before that, so code need to be adjusted to extend the timeline). In the webpage the user can select which institutions or journals will appear in the graph, along with the preferred time period. Institutions are indexed by their RePEC handle. Same for journals, with a slight modification that allows for change in publisher (RePEC handles include published, so they change over time). Note though that this published change has an effect in the ranking (e.g. The Quarterly Journal of Economics in [November 2015](https://ideas.repec.org/top/old/1511/top.journals.simple.html)).

***

## Outline

#### Project directory 
Run main.R to download the ranking filesw from RePEC IDEAS and create the appropriate Rdata files that will be used in the shiny app.

* main.R
* download-institutions.R
* download-journals.R

#### econrankings 
the shiny app - requires the datasets in the sane folder

* global.R
* server.R
* ui.R
* rankings.institutions.Rdata
* rankings.journals.Rdata

***

## To keep up to date

IDEAS notes that rankings are usually updated around the 3rd to 5th day of each month. The code in is written in a way to download and used all the rankings starting from October 2013 until the most recent month (provided RePEC does not change the format of the tables). 
