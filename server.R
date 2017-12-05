library(shiny)
library(dplyr)
library(tidyr)

library("ggplot2")
#library("maps")
library("plotly")
library("RColorBrewer")

source("WDI_data_wrangling.R")
net.migration <- getData("SM.POP.NETM")
net.migration <- na.omit(net.migration)
colnames(net.migration)[3] <- "net_migration"

international.migrant.stock <- getData('SM.POP.TOTL')
international.migrant.stock <- na.omit(international.migrant.stock)
colnames(international.migrant.stock)[3] <- "international_migrant_stock"


shinyServer(function(input, output) {
  output$graph <- 