library(shiny)
library(dplyr)
library(tidyr)

# this part reads the provided info
raw.data <- 

shinyServer(function(input, output) {
  
  # this bit renders the plot to be displayed
  output$plot <- renderPlotly({
    
    plot_ly(x = "", 
            y = "",
            type="scatter") %>% 
      layout(xaxis=list(title=""), title = "") 
    
  })
  
})


