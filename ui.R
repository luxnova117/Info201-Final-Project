library(shiny)
library(plotly)

my.ui <- fluidPage(
  
  # title
  titlePanel("Nutrition of Cereals"),
  
  sidebarLayout(
    sidebarPanel(
      
      # select would let the user choose a country, income type, or some other variable to display
      selectInput('value_name', "Title or Question goes here", 
                  choices = list()
      ),
      
      # a slider would let the user change the range they are wanting to view
      sliderInput("value_name2",
                  "Title Goes Here",
                  min = 0,
                  max = 15,
                  value = 15),
      
      # a checkbox input seems fairly appropriate, it would let the user choose 
      # what they want to view from the data very specifically
      checkboxInput(inputId, label, value = FALSE, width = NULL)
    ),
    
    mainPanel(
      plotlyOutput("plot")
    )
  )
  
)

# Define UI for application
shinyUI(my.ui)