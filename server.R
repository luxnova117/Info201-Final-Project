library(shiny)
library(dplyr)
library(tidyr)

library("ggplot2")
#library("maps")
library("plotly")
library("RColorBrewer")

source("WDI_data_wrangling.R")

migration.data <- getData("SM.POP.NETM", start.year = 2000, end.year = 2005) %>% 
  na.omit()

df <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv', stringsAsFactors = FALSE)
data.w.codes <- left_join(migration.data, df, by = c("country" = "COUNTRY"))

migration <- data.w.codes %>% 
  na.omit() %>% 
  select(CODE, year,SM.POP.NETM, country)

# new stuff
g <- list(
  showframe = FALSE,
  showcoastlines = TRUE,
  scope = "world"
)

p <- plot_geo(migration) %>%
  add_trace(
    z = ~SM.POP.NETM, color = ~SM.POP.NETM, colors = 'RdYlGn', locations = ~CODE,
    text = ~paste0(migration$SM.POP.NETM), type = "choropleth"
  ) %>%
  layout(
    title = 'It Worked?',
    geo = g
  )


#Returns a data frame at the given year
# YEARS GO FROM 1962 TO 2012 JUMPING BY 5 YEARS
GetMigrationData <- function(my.year){
  df <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv', stringsAsFactors = FALSE)
  migration.data <- getData("SM.POP.NETM") %>% 
    na.omit() %>% 
    left_join(df, by = c("country" = "COUNTRY")) %>% 
    na.omit() %>% 
    select(CODE, country, SM.POP.NETM, year) %>% 
    filter(year == my.year)
  return(migration.data)
}

year <- GetMigrationData(1982)

shinyServer(function(input, output) {
  input$year
  # this bit renders the plot to be displayed
  output$plot <- renderPlotly({

    #filter data based on year
    map.data <-  GetMigrationData(input$year)
    
    plot_geo(map.data) %>%
      add_trace(
        z = ~SM.POP.NETM,
        color = ~SM.POP.NETM,
        colors = 'RdYlGn',
        locations = ~CODE,
        text = ~paste0(migration$SM.POP.NETM),
        type = "choropleth"
      ) 
    colorbar(title = "Number of People (Million)") %>%
      layout(
        title = 'Migration Map',
        geo = g
      )

    
    })
  
})


