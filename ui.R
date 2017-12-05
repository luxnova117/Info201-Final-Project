library(shiny)
library(dplyr)
library(plotly)

source("WDI_data_wrangling.R")
my.ui <- fluidPage(
  
  # title
  titlePanel("Where are people moving to these days? Who is moving and how has it changed over time?"),
  
  sidebarLayout(
    sidebarPanel(
      
      mainPanel(
        plotlyOutput("plot")
      )
    )
    
  )
)
  
  shinyUI(my.ui)
  