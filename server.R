library(shiny)
library(dplyr)
library(tidyr)

library("ggplot2")
#library("maps")
library("plotly")
library("RColorBrewer")

source("WDI_data_wrangling.R")


#
# # new stuff
g <- list(
   showframe = FALSE,
   showcoastlines = TRUE,
   scope = "world"
)

# p <- plot_geo(migration) %>%
#   add_trace(
#     z = ~SM.POP.NETM, color = ~SM.POP.NETM, colors = 'RdYlGn', locations = ~CODE,
#     text = ~paste0(migration$SM.POP.NETM), type = "choropleth"
#   ) %>%
#   layout(
#     title = 'It Worked?',
#     geo = g
#   )
#
df <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv', stringsAsFactors = FALSE)

#Returns a data frame at the given year
# YEARS GO FROM 1962 TO 2012 JUMPING BY 5 YEARS
# GetMigrationData <- function(my.year){
#   migration.data <- getData("SM.POP.NETM") %>%
#     na.omit() %>%
#     left_join(df, by = c("country" = "COUNTRY")) %>%
#     na.omit() %>%
#     select(CODE, country, SM.POP.NETM, year) %>%
#     filter(year == my.year)
#   return(migration.data)
# }
# 
# migration.data <- getData("SM.POP.NETM", start.year = input$year, end.year = input$year) %>% 
#   na.omit()
# 
# data.w.codes <- left_join(migration.data, df, by = c("country" = "COUNTRY")) %>%
                #na.omit()



shinyServer(function(input, output) {
  
  map.data <- reactive({
    migration.data <- getData("SM.POP.NETM", start.year = input$year, end.year = input$year) %>% 
      na.omit()
    
    migration.data$country[208] = "Russia"
    migration.data$country[92] = "Congo, Democratic Republic of the"
    migration.data$country[106] = "Egypt"
    migration.data$country[138] = "Iran"
    
    data.w.codes <- left_join(migration.data, df, by = c("country" = "COUNTRY")) %>%
      na.omit()
    return(data.w.codes)
  })
  
  
  # this bit renders the plot to be displayed
  output$plot <- renderPlotly ({
    
    plot_geo(map.data()) %>%
      add_trace(
        z = ~SM.POP.NETM,
        color = ~SM.POP.NETM,
        colors = 'RdYlGn',
        locations = ~CODE,
        hoverinfo = 'text',
        text = ~paste(country, ": ", format(SM.POP.NETM, big.mark=",", trim=TRUE)),
        type = "choropleth"
      ) %>%
    colorbar(title = "Number of People (Million)") %>%
      layout(
        title = 'Migration Map',
        geo = g
      )

    
    })
  
})


