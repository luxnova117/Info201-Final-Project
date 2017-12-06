library(shiny)
library(plotly)

source("WDI_data_wrangling.R")

my.ui <- fluidPage(
  
  # title
  titlePanel("Where are people moving to these days? Who is moving and how has it changed over time?"),
  
  sidebarLayout(
    sidebarPanel(
      
      # select would let the user choose a country, income type, or some other variable to display
      selectInput('dataset', "Make these choices into different tabs", 
                  choices = list(
                    "Net Immigration" = "SM.POP.NETM",
                    "College Education Immigration" = "SM.EMI.TERT.ZS"
                  )
      ),
      
      selectInput('con', "Choose Country", 
                  choices = country.codes$name
      ),
      
      # a slider to change the year dataset displayed
      # years from 1962 to 2012 that jumps by 5
      sliderInput(inputId = "year",
                  label = "Year:",
                  min = 1962,
                  max = 2012,
                  value = 15,
                  step = 5,
                  sep = "",
                  animate = TRUE),
      
      # a checkbox input seems fairly appropriate, it would let the user choose 
      # what they want to view from the data very specifically
      checkboxInput("value", "label", value = FALSE, width = NULL)
    ),
    
    mainPanel(
      plotlyOutput("plot"),
      plotlyOutput("plot2")
    )
  )
  
)

# Define UI for application
shinyUI(my.ui)