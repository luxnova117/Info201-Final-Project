library(ggplot2)
library(plotly)
library(dplyr)

source("WDI_data_wrangling.R")



net.migration <- getData("SM.POP.NETM", c("CA", "US", "MX", "AU", "FR", "CO"))
net.migration <- filter(net.migration, !(is.na(SM.POP.NETM)))
colnames(net.migration)[3] <- "net_migration"

gdp.per.cap.growth <- getData("NY.GDP.PCAP.KD.ZG", c("CA", "US", "MX", "AU", "FR", "CO"))
gdp.per.cap.growth <- filter(gdp.per.cap.growth, !(is.na(NY.GDP.PCAP.KD.ZG)))
colnames(gdp.per.cap.growth)[3] <- "gdp_per_cap_growth"

combined.dat <- left_join(net.migration, gdp.per.cap.growth, by = c("iso2c", "country"))
combined.dat$net_migration <- combined.dat$net_migration / 1000000
colnames(combined.dat)[3] <- "net_migration_millions"
combined.dat <- filter(combined.dat, year.y == year.x)
combined.dat <- select(combined.dat, iso2c, country, net_migration_millions, gdp_per_cap_growth, year.y)
colnames(combined.dat)[5] <- "year"




plot <- ggplot(combined.dat, aes(x = gdp_per_cap_growth, y = net_migration_millions, frame = year, color = country)) +
  geom_point()

plot <- ggplotly(plot) %>% layout(xaxis = list(title = "GDP Per Capita Growth"), yaxis = list(title = "Net Migration (millions)"))

plot2 <- ggplot(combined.dat, aes(x = year, y = net_migration_millions, frame = year, color = country)) +
  geom_point()

plot2 <- ggplotly(plot2) %>% layout(xaxis = list(title = "Year"), yaxis = list(title = "Net Migration (millions)"))
