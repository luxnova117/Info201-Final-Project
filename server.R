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

accumulate_by <- function(dat, var) {
  var <- lazyeval::f_eval(var, dat)
  lvls <- plotly:::getLevels(var)
  dats <- lapply(seq_along(lvls), function(x) {
    cbind(dat[var %in% lvls[seq(1, x)], ], frame = lvls[[x]])
  })
  dplyr::bind_rows(dats)
}

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
  
  map.data <- reactive({
    migration.data <- getData("SM.POP.NETM", start.year = input$year, end.year = input$year) %>% 
      na.omit()
    
    data.w.codes <- left_join(migration.data, df, by = c("country" = "COUNTRY")) %>%
      na.omit()
    return(data.w.codes)
  })
  
  plot1.data <- reactive({
    selected.country <- input$con
    selected.code <- filter(country.codes, name == selected.country) %>% select(code)
    migration.data <- getData("SM.POP.NETM", countries = selected.code) %>% na.omit()
    colnames(migration.data)[3] <- "net_migration"
    migration.data$net_migration <- migration.data$net_migration / 1000000
    colnames(migration.data)[3] <- "net_migration_millions"
    return(migration.data)
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
  # just ues plotly jeez 
  output$plot2 <- renderPlotly({
    # (ggplot(plot1.data(), aes(x = year, y = net_migration_millions)) +
    #   geom_line()) %>%
    # ggplotly(dynamicTicks = TRUE) %>% layout(xaxis = list(title = "Year"), yaxis = list(title = "Net Migration (millions)")) %>%
    #   animation_opts(frame = 150, transition = 0, redraw = FALSE)
    plot_ly(plot1.data(), x = ~year, y = ~net_migration_millions, type = "scatter", mode = "lines+markers") %>% 
            layout(title = "Net Immigration Per Year", xaxis = list(title = "Year"), yaxis = list(title = "Net Immigration (millions)")) %>%
            animation_opts(frame = 200, transition = 0, redraw = FALSE)
    
    
  })
  
})


