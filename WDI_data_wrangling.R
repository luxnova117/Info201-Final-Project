library(WDI)
library(dplyr)
library(httr)
library(jsonlite)
library(tidyr)





# Use the "indicators" list to select which type of data you want to be returned as a table in the.indicator
# For example, to get the life expectancy total of Austrailia for 02-12 
# pass getData(indicators$life_expectancy_total, "AU", 2002, 2012)
getData <- function(the.indicator, countries, start.year, end.year){
  if(missing(countries)){
    countries = "all"
  }
  if(missing(start.year)){
    start.year = 1960
  }
  if(missing(end.year)){
    end.year = 2012
  }
  dat <- WDI(indicator = the.indicator, country = countries, start = start.year, end = end.year)
  return(dat)
}

getCountryCodes <- function(){
  countries.response <- GET("https://api.printful.com/countries")
  countries.response.content <- content(countries.response,"text")
  countries.response.data <- fromJSON(countries.response.content)
  countries <- countries.response.data$result
  
  countries.code <- lapply(countries, '[[', 1)
  countries.code <- unlist(countries.code)
  
  countries.name <- lapply(countries, '[[', 2)
  countries.name <- unlist(countries.name)
  
  countries.data <- list(name = countries.name, code = countries.code)
  View(countries.data)
  countries.data <- data.frame(countries.data, stringsAsFactors = FALSE)
  return(countries.data)
}

getNewCountryCodes <- function(){
  countries.response <- GET("https://api.printful.com/countries")
  countries.response.content <- content(countries.response,"text")
  countries.response.data <- fromJSON(countries.response.content)
  countries <- countries.response.data$result
  
  countries.code <- countries$code
  countries.name <- countries$name
  countries.data <- list(name = countries.name, code = countries.code)
  countries.data <- data.frame(countries.data, stringsAsFactors = FALSE)
  return(countries.data)
}

continents.response <- GET("http://country.io/continent.json")
continents.response.content <- content(continents.response,"text", encoding = "UTF-8")
continents <- fromJSON(continents.response.content)
continents <- data.frame(continents)
continents <- gather(continents, key = "code", value = "continent")


country.codes <- getNewCountryCodes()
country.codes <- left_join(country.codes, continents, by = "code")
net.mig <- getData('SM.POP.NETM', start.year = 2012, end.year = 2012) %>% na.omit()
net.mig <- net.mig[47:length(net.mig$country),]
country.codes <- filter(country.codes, country.codes$name %in% net.mig$country)

link1 <- "https://github.com/vincentarelbundock/WDI"
link2 <- "https://data.worldbank.org/indicator/SM.POP.REFG"
link3 <- "https://data.worldbank.org/indicator/SM.POP.REFG.OR"
link4 <- "https://data.worldbank.org/indicator/SM.POP.NETM"
link5 <- "https://data.worldbank.org/indicator/SM.POP.TOTL"
