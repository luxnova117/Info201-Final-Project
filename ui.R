library(shiny)
library(plotly)



source("WDI_data_wrangling.R")


my.ui <- fluidPage(
  tabsetPanel(
    tabPanel("overview",
             mainPanel(
               h2("Purpose"),
               p("The purpose of our project is to find an answer to the following questions: "),
               h6("Where are people moving to these days? "),
               h6("Who is moving and how has it changed over time?"),
               h2("Audience"),
               p("Our project would be helpful for governments and policy makers in that by looking at the trends of who is moving and how migration is changing over time with the help of our visualizations, they would be able to anticipate what migration would be like in their respective countries. This way, governments and policy makers are able to make certain legislative changes to say, accommodate an anticipated influx of immigrants or refugees over the next couple of years. "),
               h2("Data"),
               p("For this project, we worked with data from the World Bank. The World Bank is an international financial institution that provides loans to countries of the world for capital programs. It was created in 1944 at the Bretton Woods Conference. The World Bank’s stated official goal is the reduction of poverty. The World Bank makes a ton of information available through its web API, which we’ve found a great version of on GitHub to use for our project:"),
               h6(a(link1, href='https://github.com/vincentarelbundock/WDI')),
               p("Out of all the data available on the World Bank API, we chose to focus on four datasets: Net Migration, International Migrant Stock and Refugee Population by Country of Origin and of Asylum. The Net Migration dataset gives us data on the net number of people moving in and out of each country from 1962 to 2010 and with this data, see if more people are moving in or out of a country. The International Migrant Stock gives us data from 1960 to 2015 on the number of people living in a country where they were not born. The Refugee Population by Country of Origin and of Asylum gives us insight into how many refugees are in a country or forced out of a country from 1990 to 2016. Below is a list of links of all the datasets we looked at: "),
               h6(a(link2, href='https://data.worldbank.org/indicator/SM.POP.REFG')),
               h6(a(link3, href='https://data.worldbank.org/indicator/SM.POP.REFG.OR')),
               h6(a(link4, href='https://data.worldbank.org/indicator/SM.POP.NETM')),
               h6(a(link5, href='https://data.worldbank.org/indicator/SM.POP.TOTL')),
               h2("Visualizations"),
               p("We have a total of four different tabs for each of the datasets. We made a world map for both the Net Migration data and Migrant Stock data where users can use the slider to select a year. The colors indicate the number of people that are moving in or out of the country in the Net Migration tab and the number of migrants living in a country that is not the country in which they were born for the Migrant Stock tab. From the map, we could see the migration trends in countries in each year and this answers the driving question behind our project of where people are moving to. "),
               p("We also have a graph in the same two tabs if the user wishes to see the data by country, where they simply have to select their desired country in a dropdown menu. This gives further insight into the trends of migration over the years and how it has changed over the years. "),
               p("The next two tabs are for the Refugee Population by country of origin and asylum respectively. Refugees are a subset of migrants and these two datasets answer the question of who is moving and the migration trend in refugees specifically over the years. Both of these tabs would have a world map with varying circle sizes to represent the number of refugees in that country. By looking at the map, we would easily be able to identify countries which have a large movement of refugees. "),
               h2("Contact"),
               h6("Emma Liao"),
               h6("Stone Kaech"),
               h6("Jessica Zhu"),
               h6("Alex Guo"),
               br()
             )
    ),
    tabPanel("net migration",

             titlePanel("Where are people moving to these days? Who is moving and how has it changed over time?"),
             
             sidebarLayout(
               sidebarPanel(
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
                 selectInput("con", 'check all the countries you wish to compare', choices = country.codes$name)

               ),
               
               mainPanel(plotlyOutput("plot"),
                         plotlyOutput("plot2")
               )
             )
    ),
    tabPanel("international migrant stock",
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
                 selectInput("con2", 'check all the countries you wish to compare', choices = country.codes$name)
               ),

               mainPanel(
                  plotlyOutput("plot4"),
                  plotlyOutput("plot3")
               )
             )
    ),
    tabPanel("Refugee population by country or terriory of asylum",
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
                             animate = TRUE)
               ),
               
               mainPanel(
                 plotlyOutput("plot5")
               )
             )
    ),
    tabPanel("Refugee population by country or terriory of origin",
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
                             animate = TRUE)
               ),
               
               mainPanel(
                 plotlyOutput("plot6")
               )
             )
    )
  )
)


# Define UI for application
shinyUI(my.ui)