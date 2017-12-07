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

# accumulate_by <- function(dat, var) {
#   var <- lazyeval::f_eval(var, dat)
#   lvls <- plotly:::getLevels(var)
#   dats <- lapply(seq_along(lvls), function(x) {
#     cbind(dat[var %in% lvls[seq(1, x)], ], frame = lvls[[x]])
#   })
#   dplyr::bind_rows(dats)
# }

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
#selected.country <- input$con
#selected.code <- filter(country.codes, name == selected.country) %>% select(code)
migration.data <- getData("SM.POP.NETM", countries = "US") %>% na.omit()
colnames(migration.data)[3] <- "net_migration"
migration.data$net_migration <- migration.data$net_migration / 1000000
colnames(migration.data)[3] <- "net_migration_millions"


shinyServer(function(input, output) {
  
  net.migration.data <- reactive({
    migration.data <- getData("SM.POP.NETM", start.year = input$year, end.year = input$year) %>%
      na.omit()

    data.w.codes <- left_join(migration.data, df, by = c("country" = "COUNTRY")) %>%
      na.omit()
    return(data.w.codes)
  })


  # international.migrant.stock.data.for.graph <- reactive({
  #   selected.country <- input$con2
  #   selected.code <- filter(country.codes, name == selected.country) %>% select(code)
  #   migrant.stock.data <- getData("SM.POP.TOTL", countries = selected.code) %>% na.omit()
  #   colnames(migrant.stock.data)[3] <- "migrant_stock"
  #   migrant.stock.data$migrant_stock <- migrant.stock.data$migrant_stock / 1000000
  #   colnames(migrant.stock.data)[3] <- "migrant_stock_millions"
  #   return(migrant.stock.data)
  # })
  net.migration.data.for.graph <- reactive({
    selected.country <- input$con

    selected.code <- filter(country.codes, name == selected.country) %>% select(code)
    net.data <- getData("SM.POP.NETM", countries = selected.code) %>% na.omit()

    colnames(net.data)[3] <- "net_migration"
    net.data$net_migration <- net.data$net_migration / 1000000
    colnames(net.data)[3] <- "net_migration_millions"
    return(net.data)
  })

  # this bit renders the plot to be displayed
  # if net migration chosen, renders map
  output$plot <- renderPlotly ({

    plot_geo(net.migration.data()) %>%
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

  # if international stock migrant chosen, renders graph
  output$plot2 <- renderPlotly({
    
    plot_ly(net.migration.data.for.graph(), x = ~year, y = ~net_migration_millions, type = "scatter", mode = "lines+markers") %>%
            layout(title = "Net Immigration Per Year", xaxis = list(title = "Year"), yaxis = list(title = "Net Immigration (millions)")) %>%
            animation_opts(frame = 200, transition = 0, redraw = FALSE)
    # x <- c(1:100)
    # random_y <- rnorm(100, mean = 0)
    # data <- data.frame(x, random_y)
    # 
    # plot_ly(data, x = ~x, y = ~random_y, type = 'scatter', mode = 'lines')
  })
  # if net migration chosen, renders graph
  # output$plot3 <- renderPlotly({
  #   plot_ly(net.migration.for.graph(), x = ~year, y = ~net_migration_millions, type = 'scatter', mode = 'lines+markers') %>% 
  #     layout(title = 'net migration per year', xaxis = list(title = "Year"), yaxis = list(title = "net migration"))
  # })

})


