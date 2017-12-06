library(shiny)
library(dplyr)
library(plotly)

source("WDI_data_wrangling.R")

my.ui <- fluidPage(
  
  # title
  titlePanel("Where are people moving to these days? Who is moving and how has it changed over time?"),
  
  sidebarLayout(
    sidebarPanel(
      #checkboxGroupInput("chosen_country", 'check all the countries you wish to compare', choices = net.migration$country)
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)
    
  

  
  shinyUI(my.ui)
  