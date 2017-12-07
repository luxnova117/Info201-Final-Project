library(shiny)
library(plotly)
library(DT)


source("WDI_data_wrangling.R")


my.ui <- fluidPage(
  titlePanel("Where are people moving to these days? Who is moving and how has it changed over time?"),
  tabsetPanel(
    tabPanel("Net Migration",
             
             sidebarLayout(
               sidebarPanel(
                 # a slider to change the year dataset displayed
                 # years from 1962 to 2012 that jumps by 5
                 sliderInput(inputId = "year.netm",
                             label = "Update the map to a specified year, or select Play to watch the progression:",
                             min = 1962,
                             max = 2012,
                             value = 15,
                             step = 5,
                             sep = "",
                             animate = TRUE),
                 
                 selectInput("con", 'check all the countries you wish to compare', choices = country.codes$name),
                 p("Net migration looks at the net increase or decrease of people moving in and out of a country. 
                   Green on a country shows that more people were moving in than out. And red shows that there were 
                   more people leaving that particular country during the selected timeframe.")

               ),
               mainPanel(plotlyOutput("net.migration.map"),
                         plotlyOutput("net.immigration.graph")
               )
             )
    ),
    tabPanel("International Migrant Stock",

             sidebarLayout(
               sidebarPanel(
                 p("TESTING"),
                 # a slider to change the year dataset displayed
                 # years from 1962 to 2012 that jumps by 5
                 sliderInput(inputId = "year.totl",
                             label = "Update the map to a specified year, or select Play to watch the progression:",
                             min = 1960,
                             max = 2015,
                             value = 1960,
                             step = 5,
                             sep = "",
                             animate = TRUE),
                 #,

                 # a checkbox input seems fairly appropriate, it would let the user choose
                 # what they want to view from the data very specifically
                 selectInput("con2", 'check all the countries you wish to compare', choices = country.codes$name),
                 p("Paragraph goes here")
               ),

               mainPanel(
                  plotlyOutput("migrant.stock.map"),
                  plotlyOutput("migrant.stock.graph")
               )
             )
    ),
    tabPanel("Refugee Population by Country or Terriory of Asylum",
             
             sidebarLayout(
               sidebarPanel(
                 # a slider to change the year dataset displayed
                 # years from 1962 to 2012 that jumps by 5
                 sliderInput(inputId = "year.refg",
                             label = "Update the map to a specified year, or select Play to watch the progression:",
                             min = 1990,
                             max = 2016,
                             value = 1990,
                             sep = "",
                             animate = TRUE),
                 p("Paragraph goes here")
               ),
               
               mainPanel(
                 plotlyOutput("refugee.asylum.map")
               )
             )
    ),
    tabPanel("Refugee Population by Country or Terriory of Origin",
             
             sidebarLayout(
               sidebarPanel(
                 # a slider to change the year dataset displayed
                 # years from 1962 to 2012 that jumps by 5
                 sliderInput(inputId = "year.refg.or",
                             label = "Update the map to a specified year, or select Play to watch the progression:",
                             min = 1990,
                             max = 2016,
                             value = 1990,
                             sep = "",
                             animate = TRUE),
                 p("Paragraph goes here")
               ),
               
               mainPanel(
                 plotlyOutput("refugee.origin.map")
               )
             )
    )
  )
)


# Define UI for application
shinyUI(my.ui)