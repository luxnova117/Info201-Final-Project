library(shiny)
library(dplyr)
library(tidyr)

library("ggplot2")
#library("maps")
library("plotly")
library("RColorBrewer")

source("WDI_data_wrangling.R")
#source("Visualizations_Alex.R")

#
# # new stuff
g <- list(
   showframe = FALSE,
   showcoastlines = TRUE,
   scope = "world"
)

gdp.data <- getData("NY.GDP.PCAP.KD.ZG", "US") %>% na.omit()
colnames(gdp.data)[3] <- "gdp_per_cap_growth"
net.data <- getData("SM.POP.NETM", "US") %>% na.omit()
colnames(net.data)[3] <- "net_migration"
net.data$net_migration <- net.data$net_migration / 1000000
colnames(net.data)[3] <- "net_migration_millions"
net.data <- left_join(gdp.data, net.data, by = "year")
net.data <- net.data %>% na.omit()


df <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv', stringsAsFactors = FALSE)

# migration.data <- getData("SM.POP.NETM", countries = "US") %>% na.omit()
# colnames(migration.data)[3] <- "net_migration"
# migration.data$net_migration <- migration.data$net_migration / 1000000
# colnames(migration.data)[3] <- "net_migration_millions"

test.stat <- ""



df <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv', stringsAsFactors = FALSE)

makeMapData <- function(year, indicator) {
  migration.all.data <- getData(indicator, start.year = year, end.year = year) %>%
    na.omit() 
  migration.data <- migration.data[47:261,]

  return(migration.data)
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
  
  international.migrant.stock.percent <- reactive({
    selected.country <- input$con2
    selected.code <- filter(country.codes, name == selected.country) %>% select(code)
    migrant.stock.data <- getData("SM.POP.TOTL.ZS", countries = selected.code) %>% na.omit()
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
  
  gdp.per.capita.growth <- reactive({
    selected.country <- input$con
    selected.code <- filter(country.codes, name == selected.country) %>% select(code)
    gdp.data <- getData("NY.GDP.PCAP.KD.ZG", selected.code) %>% na.omit()
    colnames(gdp.data)[3] <- "gdp_per_cap_growth"
    net.data <- getData("SM.POP.NETM", countries = selected.code) %>% na.omit()
    colnames(net.data)[3] <- "net_migration"
    net.data$net_migration <- net.data$net_migration / 1000000
    colnames(net.data)[3] <- "net_migration_millions"
    net.data <- left_join(gdp.data, net.data, by = "year") %>% na.omit()
    return(net.data)
  })
  
  


  # this bit renders the plot to be displayed
  # if net migration chosen, renders map
  # output$plot <- renderPlotly ({
  #   #key <- select(net.migration.data(), country)
  #   plot_geo(net.migration.data()) %>%
  #     add_trace(
  #       z = ~SM.POP.NETM,
  #       color = ~SM.POP.NETM,
  #       colors = 'RdYlGn',
  #       locations = ~CODE,
  #       #hoverinfo = 'text',
  #       text = ~paste(country, ": ", format(SM.POP.NETM, big.mark=",", trim=TRUE)),
  #       type = "choropleth"
  #     ) %>%
  #   colorbar(title = "Number of People (Million)") %>%
  #     layout(
  #       title = 'Migration Map',
  #       geo = g
  #     )


    })
  # output$click <- renderPrint({
  #   d <- event_data("plotly_click")
  #   if (is.null(d)) {
  #     ""
  #   }
  #   else{
  #     #d["z"]
  #     test.stat <- d["z"]
  #     cat("hi")
  #            
  #     
  #   }
  #     
  # })

  # if international stock migrant chosen, renders graph
  output$plot2 <- renderPlotly({
    
    plot_ly(net.migration.data.for.graph(), x = ~year, y = ~net_migration_millions, type = "scatter", mode = "lines+markers", hoverinfo = "text", text = ~paste("Net Migration (mil)", ": ", format(net_migration_millions, big.mark=",", trim=TRUE))) %>%
            layout(title = "Net Immigration Per Year", xaxis = list(title = "Year"), yaxis = list(title = "Net Immigration (millions)")) %>%
            animation_opts(frame = 200, transition = 0, redraw = FALSE)
  })
  # if net migration chosen, renders graph
  output$plot3 <- renderPlotly({

    plot_ly(international.migrant.stock.data.for.graph(), x = ~year, y = ~migrant_stock_millions, type = 'scatter', mode = 'lines+markers', hoverinfo = "text", text = ~paste("Migrant Stock (mil)", ": ", format(migrant_stock_millions, big.mark=",", trim=TRUE))) %>%
      layout(title = 'Net Migrant Stock Per Year', xaxis = list(title = "Year"), yaxis = list(title = "Net Migrant Stock"))
  })
  
  output$plot4 <- renderPlotly({
    plot_ly(gdp.per.capita.growth(), x = ~gdp_per_cap_growth, y = ~net_migration_millions, text = ~paste("Net Migration (mil)", ": ", format(net_migration_millions, big.mark=",", trim=TRUE))) %>%
      layout(title = 'GDP Per Cap Growth vs Migration', xaxis = list(title = "GDP Per Cap Growth"), yaxis = list(title = "Net Immigration (millions)")) %>%
      add_markers(frame = ~year) %>%
      animation_opts(1000, easing = "elastic", redraw = FALSE) %>%
      animation_button(
        x = 1, xanchor = "right", y = 0, yanchor = "bottom"
      ) %>%
      animation_slider(
        currentvalue = list(prefix = "YEAR ", font = list(color="red"))
      )
  })

})


