library(shiny)
library(plotly)
library(shinythemes)



source("WDI_data_wrangling.R")

my.ui <- navbarPage(
  title = "Gloryyy!",
  position = "static-top",
  fluid = TRUE,
  theme = shinytheme("cosmo"),
  footer = tags$img(HTML("<img src='https://www.nextedition.com.ng/wp-content/uploads/2017/10/The-World-Bank-logo.png' alt = 'The Wolrd Bank Logo' width = 150, height = 80")),
    tabPanel("Net Migration Numbers",
             tags$style(HTML("#con {background: red}")),
             fluidRow(
               column(12,
                      align = "center",
                      titlePanel(HTML("<strong>Where are people moving to these days? Who is moving and how has it changed over time?</strong>")),
                      offset = 1.5),
               column(12,
                      plotlyOutput("net.migration.map")),
               column(12,
                      sliderInput(inputId = "year.netm",
                                  label = "Year:",
                                  min = 1962,
                                  max = 2012,
                                  value = 15,
                                  step = 5,
                                  sep = "",
                                  animate = TRUE,
                                  width = "80%"),
                      offset = 1
               )
             ),
             #plotlyOutput("net.migration.map"),
             
             sidebarLayout(
               sidebarPanel(
                 selectInput("con", 'Select Country to Analyze', choices = country.codes.net.mig$name)

               ),

               mainPanel(plotlyOutput("plot2")
               )

             )
    ),
    tabPanel("International Migrant Stock",
             titlePanel("Where are people moving to these days? Who is moving and how has it changed over time?"),
             
             sidebarLayout(
               sidebarPanel(
                 # a slider to change the year dataset displayed
                 # years from 1962 to 2012 that jumps by 5
                 sliderInput(inputId = "year2",
                             label = "Year:",
                             min = 1960,
                             max = 2015,
                             value = 1960,
                             step = 5,
                             sep = "",
                             animate = TRUE),
                 #,
                 
                 # a checkbox input seems fairly appropriate, it would let the user choose
                 # what they want to view from the data very specifically
                 selectInput("con2", 'Select Country to Analyze', choices = country.codes.net.mig$name)
               ),
               
               mainPanel(
                 plotlyOutput("migrant.stock.map"),
                 plotlyOutput("plot3")
               )
             )
    ),
    tabPanel("Refugee Population By Country or Terriory of Asylum",
             titlePanel("Where are people moving to these days? Who is moving and how has it changed over time?"),
             
             sidebarLayout(
               sidebarPanel(
                 # a slider to change the year dataset displayed
                 # years from 1962 to 2012 that jumps by 5
                 sliderInput(inputId = "year3",
                             label = "Year:",
                             min = 1990,
                             max = 2016,
                             value = 1990,
                             sep = "",
                             animate = TRUE),
                 selectInput("con3", 'Select Country to Analyze', choices = country.codes.net.mig$name)
               ),
               
               mainPanel(plotlyOutput("refugee_asylum"),
                 plotlyOutput("plot5")
               )
             )
    ),
    tabPanel("Refugee Population by Country or Terriory of Origin",
             titlePanel("Where are people moving to these days? Who is moving and how has it changed over time?"),
             
             sidebarLayout(
               sidebarPanel(
                 # a slider to change the year dataset displayed
                 # years from 1962 to 2012 that jumps by 5
                 sliderInput(inputId = "year4",
                             label = "Year:",
                             min = 1990,
                             max = 2016,
                             value = 1990,
                             sep = "",
                             animate = TRUE),
                 selectInput("con4", 'Select Country to Analyze', choices = country.codes.net.mig$name)
               ),
               
               mainPanel(plotlyOutput("refugee_origin"),
                 plotlyOutput("plot6")
               )
             )
    )
  
)


# Define UI for application
shinyUI(my.ui)
