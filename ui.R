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
      
      selectInput('dataset', "Choose Country", 
                  choices = country.codes$name
      ),
      
      # a slider would let the user change the range they are wanting to view
      sliderInput("value_name2",
                  "Title Goes Here",
                  min = 0,
                  max = 15,
                  value = 15),
      
      # a checkbox input seems fairly appropriate, it would let the user choose 
      # what they want to view from the data very specifically
      checkboxInput("value", "label", value = FALSE, width = NULL)
    ),
    
    mainPanel(
      plotlyOutput("plot")
    )
  )
  
)

# Define UI for application
shinyUI(my.ui)