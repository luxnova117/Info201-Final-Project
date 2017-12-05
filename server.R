library(shiny)
library(dplyr)
library(tidyr)

library("ggplot2")
#library("maps")
library("plotly")
library("RColorBrewer")

source("WDI_data_wrangling.R")
source("Visualizations_Alex.R")
net.migration <- getData("SM.POP.NETM")
net.migration <- na.omit(net.migration)
colnames(net.migration)[3] <- "net_migration"

international.migrant.stock <- getData('SM.POP.TOTL')
international.migrant.stock <- na.omit(international.migrant.stock)
colnames(international.migrant.stock)[3] <- "international_migrant_stock"
accumulate_by <- function(dat, var) {
  var <- lazyeval::f_eval(var, dat)
  lvls <- plotly:::getLevels(var)
  dats <- lapply(seq_along(lvls), function(x) {
    cbind(dat[var %in% lvls[seq(1, x)], ], frame = lvls[[x]])
  })
  dplyr::bind_rows(dats)
}

shinyServer(function(input, output){
  net.mig <- reactive({
    temp <- filter(net.migration, country == input$chosen_country)
    temp$frame <- accumulate_by(net.mig, ~year)
    
    return(temp)
  })
    
    
    
    
    
  output$plot <- renderPlotly({
    plot2 <- ggplot(net.migration, aes(x = year, y = net_migration, frame = frame, color = country)) +
      geom_line()
    # plot2 <- ggplotly(plot2) %>% layout(xaxis = list(title = "Year"), yaxis = list(title = "Net Migration (millions)")) %>%
    #   animation_opts(frame = 200, transition = 0, redraw = FALSE)
    
  })
  
  
  
})