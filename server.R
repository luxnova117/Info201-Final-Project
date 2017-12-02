library(shiny)
library(dplyr)
library(tidyr)

library("ggplot2")
library("maps")
library("plotly")
library("RColorBrewer")

source("WDI_data_wrangling.R")

migration.data <- getData("SM.POP.NETM", start.year = 2000, end.year = 2005)
migration.data <- na.omit(migration.data)

df <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv', stringsAsFactors = FALSE)
data.w.codes <- left_join(migration.data, df, by = c("country" = "COUNTRY"))
migration <- na.omit(data.w.codes)S

# new stuff
g <- list(
  showframe = FALSE,
  showcoastlines = FALSE,
  scope = "world"
)

p <- plot_geo(migration) %>%
  add_trace(
    z = ~SM.POP.NETM, color = ~SM.POP.NETM, colors = 'Blues', locations = ~CODE,
    text = ~paste0(migration$SM.POP.NETM), type = "choropleth"
  ) %>%
  layout(
    title = 'It Worked?',
    geo = g
  )


# this part reads the provided info
# raw.data <- 

shinyServer(function(input, output) {
  
  # this bit renders the plot to be displayed
  output$plot <- renderPlotly({
    
    plot_ly(x = "", 
            y = "",
            type="scatter") %>% 
      layout(xaxis=list(title=""), title = "") 
    
  })
  
})


