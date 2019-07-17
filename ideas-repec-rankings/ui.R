# IDEAS RePEC Historical Rankings - ui.R
# Author: Stavros Poupakis 
# Date: 17-07-2019
# ----------------------------------------------------------------------

shinyUI(fluidPage(
  
  titlePanel(tags$div(
    HTML('<h3>RePEc/IDEAS historical rankings: Top Institutions and Journals (Aggregate rankings all years) </h3> <p><p>
         </h5>  '))),

  sidebarLayout(
    sidebarPanel(
      radioButtons("ranking", label = h4("Ranking"), choices = c("Institutions", "Journals"), selected = "Institutions"),
      sliderInput("slider", label = h4("Date Range:"), min = as.Date(min(data.instutions$date)), max = as.Date(max(data.instutions$date)), 
                  value = c(as.Date(min(data.instutions$date)), as.Date(max(data.instutions$date))), timeFormat="%m/%y"),
      uiOutput("ui.search"),
      uiOutput("ui.check")
    ),
    mainPanel(
      plotOutput("scatter",height = "600px"),
      HTML('<h6> Credits: Application created by <a href=http://spoupakis.com target=_blank>Stavros Poupakis</a>.
           Code can be found on <a href=https://github.com/spoupakis/repec-ideas-rankings target=_blank>GitHub</a>. 
           Data obtained from RePEC <a href=https://ideas.repec.org/top target=_blank>historical rankings</a>. 
           </h6>')
  )
)))
