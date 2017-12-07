library(shiny)
library(dplyr)
library(tidyr)

library("ggplot2")
#library("maps")
library("plotly")
library("RColorBrewer")
library("DT")

source("WDI_data_wrangling.R")
#source("Visualizations_Alex.R")

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


makeMapData <- function(year, indicator) {
  migration.all.data <- getData(indicator, start.year = year, end.year = year) %>%
    na.omit() 
    
  codes <- read.csv('all.csv', stringsAsFactors = FALSE)
  
  data.w.codes <- inner_join(migration.all.data, codes, by = c("iso2c" = "alpha.2"))
  return(data.w.codes)
}

makeMap <- function(data, indicator, the.title, colorscheme) {
  plot_geo(data) %>%
    add_trace(
      z = ~eval(parse(text=indicator)),
      color = ~eval(parse(text=indicator)),
      colors = colorscheme,
      locations = ~country,
      locationmode = "country names",
      text = ~paste(country, ": ", format(eval(parse(text=indicator)), big.mark=",", trim=TRUE)),
      type = "choropleth"
    ) %>%
    add_markers(
      z = ~eval(parse(text=indicator)),
      locations = ~country,
      locationmode = "country names",
      text = paste0(""), 
      size = I(~eval(parse(text=indicator)))) %>% 
    colorbar(title = "Number of People (Million)") %>%
    layout(
      title = the.title,
      geo = g
    )
}


shinyServer(function(input, output) {
  
  # this bit creates the data to be used to update the maps
  net.migration.map <- reactive({
    map.data <- makeMapData(input$year.netm, "SM.POP.NETM")
    return(makeMap(map.data, "SM.POP.NETM", "Net Migration", "RdYlGn"))
  })
  
  migrant.stock.map <- reactive({
    map.data <- makeMapData(input$year.totl, "SM.POP.TOTL")
    return(makeMap(map.data, "SM.POP.TOTL", "Migrant Stock", "RdPu"))
  })
  
  refugee.asylum.map <- reactive({
    map.data <- makeMapData(input$year.refg, "SM.POP.REFG")
    return(makeMap(map.data, "SM.POP.REFG", "Refugee Asylum Count", "Greens"))
  })
  
  refugee.origin.map <- reactive({
    map.data <- makeMapData(input$year.refg.or, "SM.POP.REFG.OR")
    return(makeMap(map.data, "SM.POP.REFG.OR", "Refugee Origin County Count", "Blues"))
  })
  
  
  # These are the map outputs
  output$net.migration.map <- renderPlotly ({
    net.migration.map()
  })
  
  output$migrant.stock.map <- renderPlotly ({
    migrant.stock.map()
  })
  
  output$refugee.asylum.map <- renderPlotly({
    refugee.asylum.map()
  })
  
  output$refugee.origin.map <- renderPlotly({
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
  output$net.immigration.graph <- renderPlotly({
    
    plot_ly(makeGraphData(input$con, 'SM.POP.NETM'), x = ~year, y = ~SM.POP.NETM, type = "scatter", mode = "lines+markers") %>%
            layout(title = "Net Immigration Per Year", xaxis = list(title = "Year"), yaxis = list(title = "Net Immigration (millions)")) %>%
            animation_opts(frame = 200, transition = 0, redraw = FALSE)
  })
  # if net migration chosen, renders graph

  output$migrant.stock.graph <- renderPlotly({
    plot_ly(makeGraphData(input$con2,'SM.POP.TOTL'), x = ~year, y = ~SM.POP.TOTL, type = 'scatter', mode = 'lines+markers') %>%
      layout(title = 'Net Migrant Stock Per Year', xaxis = list(title = "Year"), yaxis = list(title = "Net Migrant Stock"))
  })
  
    
  


})


