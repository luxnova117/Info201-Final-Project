source('WDI_data_wrangling.R')
library("ggplot2")
library('WDI')
library('dplyr')
GPI <- getData('SE.ENR.PRSC.FM.ZS') 
GDP_per_capita <- getData('NY.GDP.PCAP.CD')

combined_data <- left_join(GPI, GDP_per_capita)
colnames(combined_data) <- c('code', 'country', 'GPI', 'year', 'GDP.per.capita')

trial <- ggplot(combined_data) + geom_point(mapping = aes(x=GPI, y=GDP.per.capita))
trial

