library(shiny)
library(dplyr)
library(tidyr)

library("ggplot2")
#library("maps")
library("plotly")
library("RColorBrewer")

source("WDI_data_wrangling.R")
#source("Visualizations_Alex.R")
source('overview.R')

#
# # new stuff
g <- list(
   showframe = FALSE,
   showcoastlines = TRUE,
   scope = "world"
)


df <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv', stringsAsFactors = FALSE)

migration.data <- getData("SM.POP.NETM", countries = "US") %>% na.omit()
colnames(migration.data)[3] <- "net_migration"
migration.data$net_migration <- migration.data$net_migration / 1000000
colnames(migration.data)[3] <- "net_migration_millions"



df <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv', stringsAsFactors = FALSE)

makeMapData <- function(year, indicator) {
  migration.all.data <- getData(indicator, start.year = year, end.year = year) %>%
    na.omit() 
    
  codes <- read.csv('all.csv', stringsAsFactors = FALSE)
  
  data.w.codes <- right_join(migration.data, codes, by = c("alpha.2" = "iso2c"))
  return(data.w.codes)
}

makeMap <- function(data, indicator, the.title) {
  plot_geo(data) %>%
    add_trace(
      z = ~eval(parse(text=indicator)),
      color = ~eval(parse(text=indicator)),
      colors = 'RdYlGn',
      locations = ~country,
      locationmode = "country names",
      text = ~paste(country, ": ", format(eval(parse(text=indicator)), big.mark=",", trim=TRUE)),
      type = "choropleth"
    ) %>%
    colorbar(title = "Number of People (Million)") %>%
    layout(
      title = the.title,
      geo = g
    )
}


shinyServer(function(input, output) {
  
  net.migration.data <- reactive({
    return(makeMapData(input$year, "SM.POP.NETM"))
  })
  
  net.migration.map <- reactive({
    return(makeMap(net.migration.data(), "SM.POP.NETM", "Net Migration"))
  })

  migrant.stock.data <- reactive({
    return(makeMapData(input$year2, "SM.POP.TOTL"))
  })
  
  migrant.stock.map <- reactive({
    return(makeMap(migrant.stock.data(), "SM.POP.TOTL", "Migrant Stock"))
  })
  
  refugee.asylum.data <- reactive({
    return(makeMapData(input$year3, "SM.POP.REFG"))
  })
  
  refugee.asylum.map <- reactive({
    return(makeMap(refugee.asylum.data(), "SM.POP.REFG", "Refugee Asylum Count"))
  })
  
  refugee.origin.data <- reactive({
    return(makeMapData(input$year4, "SM.POP.REFG.OR"))
  })
  
  refugee.origin.map <- reactive({
    return(makeMap(refugee.origin.data(), "SM.POP.REFG.OR", "Refugee Asylum Count"))
  })
  
  
  # this bit renders the plot to be displayed
  # if net migration chosen, renders map
  output$plot <- renderPlotly ({
    net.migration.map()
  })
  
  output$plot4 <- renderPlotly ({
    migrant.stock.map()
  })
  
  output$plot5 <- renderPlotly({
    refugee.asylum.map()
  })
  
  output$plot6 <- renderPlotly({
    refugee.origin.map()
  })

  international.migrant.stock.data.for.graph <- reactive({
    selected.country <- input$con2
    selected.code <- filter(country.codes, name == selected.country) %>% select(code)
    migrant.stock.data <- getData("SM.POP.TOTL", countries = selected.code) %>% na.omit()
    colnames(migrant.stock.data)[3] <- "migrant_stock"
    migrant.stock.data$migrant_stock <- migrant.stock.data$migrant_stock / 1000000
    colnames(migrant.stock.data)[3] <- "migrant_stock_millions"
    return(migrant.stock.data)
  })

  net.migration.data.for.graph <- reactive({
    selected.country <- input$con

    selected.code <- filter(country.codes, name == selected.country) %>% select(code)
    net.data <- getData("SM.POP.NETM", countries = selected.code) %>% na.omit()
    colnames(net.data)[3] <- "net_migration"
    net.data$net_migration <- net.data$net_migration / 1000000
    colnames(net.data)[3] <- "net_migration_millions"
    return(net.data)
  })

  
  


  # if international stock migrant chosen, renders graph
  output$plot2 <- renderPlotly({
    
    plot_ly(makeGraphData(input$con, 'SM.POP.NETM'), x = ~year, y = ~SM.POP.NETM, type = "scatter", mode = "lines+markers") %>%
            layout(title = "Net Immigration Per Year", xaxis = list(title = "Year"), yaxis = list(title = "Net Immigration (millions)")) %>%
            animation_opts(frame = 200, transition = 0, redraw = FALSE)
  })
  # if net migration chosen, renders graph
  output$plot3 <- renderPlotly({
    plot_ly(makeGraphData(input$con2,'SM.POP.TOTL'), x = ~year, y = ~SM.POP.TOTL, type = 'scatter', mode = 'lines+markers') %>%
      layout(title = 'Net Migrant Stock Per Year', xaxis = list(title = "Year"), yaxis = list(title = "Net Migrant Stock"))
  })
  
    
  


})


