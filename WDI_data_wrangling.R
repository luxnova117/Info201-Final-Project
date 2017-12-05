library(WDI)
library(dplyr)
library(httr)
library(jsonlite)
library(tidyr)


#dat = WDI(indicator='VC.PKP.TOTL.UN', country = "all", start=2010, end=2011)
#View(dat)

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
continents.response.content <- content(continents.response,"text")
continents <- fromJSON(continents.response.content)
continents <- data.frame(continents)
continents <- gather(continents, key = "code", value = "continent")


country.codes <- getNewCountryCodes()

country.codes <- left_join(country.codes, continents, by = "code")

indicators <- list("GDP" = "NY.GDP.MKTP.CD",
                   "GDP_per_capita" = "NY.GDP.PCAP.CD",
                   "GDP_annual_growth" = "NY.GDP.MKTP.KD.ZG",
                   "GDP_annual_growth_per_capita" = "NY.GDP.PCAP.CD",
                   "military_expenditures_pGDP" = "MS.MIL.XPND.GD.ZS", #Military expenditures %GDP
                   "military_expenditures" = "MS.MIL.XPND.CN",
                   "military_expenditures_pgovtexpend" = "MS.MIL.XPND.ZS",
                   "population_total" = "SP.POP.TOTL",
                   "population_female" = "SP.POP.TOTL.FE.IN",
                   "population_male" = "SP.POP.TOTL.MA.IN",
                   "life_expectancy_female" = "SP.DYN.LE00.FE.IN",
                   "life_expectancy_male" = "SP.DYN.LE00.MA.IN",
                   "life_expectancy_total" = "SP.DYN.LE00.IN",
                   "gender_parity_index" = "UIS.LR.AG15T99.GPI",
                   "refugee_population_asylum" = "SM.POP.REFG",
                   "refugee_pupulation_origin" = "SM.POP.REFG.OR",
                   "outbound_mobile_students" = "UIS.OE.56.40510")

