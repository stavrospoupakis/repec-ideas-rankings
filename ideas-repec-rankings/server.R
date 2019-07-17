# IDEAS RePEC Historical Rankings - server.R
# Author: Stavros Poupakis 
# Date: 17-07-2019
# ----------------------------------------------------------------------

shinyServer(function(input, output) {
  
  output$ui.search <- renderUI({
    if (is.null(input$ranking)) return()
    switch(input$ranking,
           "Institutions" = selectInput("checkGroup1", h4("Search an instution:"), k.instutions, multiple=TRUE, selectize=TRUE),
           "Journals"     = selectInput("checkGroup1", h4("Search a journal:"), k.journals, multiple=TRUE, selectize=TRUE))
  })
  output$ui.check <- renderUI({
    if (is.null(input$ranking)) return()
    switch(input$ranking,
           "Institutions" = checkboxGroupInput("checkGroup2", label = h4("Departments list:"), choices = top.instutions100,selected = NULL),
           "Journals"     = checkboxGroupInput("checkGroup2", label = h4("Journals list:"),    choices = top.journals100, selected = NULL))
  })
  
  output$scatter <- renderPlot({
  
    if(input$ranking=="Institutions") {
    date.range <- input$slider
    query      <- c(input$checkGroup1, input$checkGroup2)
    data_to_plot <- data.instutions[data.instutions$variable %in% query & data.instutions$date>=date.range[1] & data.instutions$date<=date.range[2], ]
    }

    if(input$ranking=="Journals") {
      date.range <- input$slider
      query      <- c(input$checkGroup1, input$checkGroup2)
      data_to_plot <- data.journals[data.journals$variable %in% query & data.journals$date>=date.range[1] & data.journals$date<=date.range[2], ]
    }
    
    p <- ggplot(data=data_to_plot, aes(x=date, y=value, colour=variable)) +
         geom_line(size=1.5) + scale_y_reverse() + ylab("Rank") + xlab("Date") +
         theme(legend.title = element_blank(), legend.position="bottom", legend.text = element_text(size = 15), 
         legend.direction = "vertical", axis.text = element_text(size = 15))  +
         guides(col = guide_legend(keywidth = 5)) 
    print(p)
    })
    
})
    

