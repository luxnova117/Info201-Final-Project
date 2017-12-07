library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)
library(RColorBrewer)


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
    colorbar(title = "Number of People <br />(Million)") %>%
    layout(
      title = the.title,
      geo = g
    )
}

makeGraphData = function(coun, indicator){
  selected.code <- filter(country.codes, name == coun) %>% select(code)
  selected.data <- getData(indicator, countries = selected.code) %>% na.omit()
  return(selected.data)
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

  # if international stock migrant chosen, renders graph
  output$net.immigration.graph <- renderPlotly({
    plot_ly(net.migration.data.for.graph(),
            x = ~year,
            y = ~SM.POP.NETM,
            type = "scatter",
            mode = "lines+markers", hoverinfo = "text", text = ~paste0("Net Migration Count: ", SM.POP.NETM),
            color = I('lightseagreen')) %>%
      layout(title = paste("Net Immigration Per Year", "-", net.migration.data.for.graph()$country[[1]]),
             xaxis = list(title = "Year"),
             yaxis = list(title = "Net Immigration Count"))
    
  })
  # if net migration chosen, renders graph
  output$migration.stock.graph <- renderPlotly({
    plot_ly(international.migrant.stock.data.for.graph(),
            x = ~year,
            y = ~SM.POP.TOTL,
            type = 'scatter',
            mode = 'lines+markers',
            hoverinfo = "text",
            text = ~paste0("Total Immigrants: ", SM.POP.TOTL)) %>%
      layout(title = paste("Total Immigrants", "-", international.migrant.stock.data.for.graph()$country[[1]]),
             xaxis = list(title = "Year"),
             yaxis = list(title = "Total Immigrant Count"))
  })
  
  output$refugee_asylum <- renderPlotly({
    plot_ly(refugee.asylum.data.for.graph(),
            x = ~year,
            y = ~SM.POP.REFG,
            type = 'scatter',
            mode = 'lines+markers',
            hoverinfo = "text",
            text = ~paste0("Refugees: ", SM.POP.REFG)) %>%
      layout(title = paste('Refugee Population Of', refugee.asylum.data.for.graph()$country[[1]]),
             xaxis = list(title = "Year"),
             yaxis = list(title = "Total Refugee Count"))
  })
  
  output$refugee_asylum_an <- renderPlotly({
    plot_ly(refugee.asylum.data.for.graph(),
            x = ~year,
            y = ~SM.POP.REFG,
            type = 'scatter',
            mode = 'lines+markers',
            hoverinfo = "text",
            text = ~paste0("Refugees in ", "refugee.asylum.data.for.graph()$country[[1]]", SM.POP.REFG)) %>%
      layout(title = paste('Refugee Population In', refugee.asylum.data.for.graph()$country[[1]], type = "log"),
             xaxis = list(title = "Year"),
             yaxis = list(title = "Total Refugee Count"))
  })
  
  output$refugee_origin <- renderPlotly({
    plot_ly(refugee.origin.data.for.graph(),
            x = ~year,
            y = ~SM.POP.REFG.OR,
            type = 'scatter',
            mode = 'lines+markers',
            hoverinfo = "text",
            text = ~paste0("Refugees rom: ", refugee.origin.data.for.graph()$country[[1]], SM.POP.REFG.OR)) %>%
      layout(title = paste('Refugee Population From', refugee.origin.data.for.graph()$country[[1]]),
             xaxis = list(title = "Year"),
             yaxis = list(title = "Total Refugee Count"))
  })
})


