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

df <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv', stringsAsFactors = FALSE)


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
  
  international.migrant.stock.data.for.graph <- reactive({
    selected.country <- input$con
    #selected.code <- filter(country.codes, name == selected.country) %>% select(code)
    migrant.stock.data <- getData("SM.POP.TOTL", countries = selected.country) %>% na.omit()
    colnames(migrant.stock.data)[3] <- "migrant_stock"
    migrant.stock.data$migrant_stock <- migrant.stock.data$migrant_stock / 1000000
    colnames(migrant.stock.data)[3] <- "migrant_stock_millions"
    return(migrant.stock.data)
  })
  
  net.migration.data.for.graph <- reactive({
    selected.country <- input$con
    #selected.code <- filter(country.codes, name == selected.country) %>% select(code)
    net.data <- getData("SM.POP.NETM", countries = selected.country) %>% na.omit()
    colnames(net.data)[3] <- "net_migration"
    net.data$net_migration <- net.data$net_migration / 1000000
    colnames(net.data)[3] <- "net_migration_millions"
    return(net.data)
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
  
  # if net migration chosen, renders graph
  output$plot2 <- renderPlotly({
    (ggplot(international.migrant.stock.data.for.graph(), aes(x = ~year, y = ~migrant_stock_millions)) +
       geom_line()) 
    # %>%
    # ggplotly(dynamicTicks = TRUE) %>% layout(xaxis = list(title = "Year"), yaxis = list(title = "Net Migration (millions)")) %>%
    #   animation_opts(frame = 150, transition = 0, redraw = FALSE)
  })
  
  # if international stock migrant chosen, renders graph
  output$plot3 <- renderPlotly({
    (ggplot(net.migration.data.for.graph(), aes(x = ~year, y = ~net_migration_millions)) +
       geom_line()) 
  })
  
})


