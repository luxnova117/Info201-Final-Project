library(ggplot2)
library(plotly)
library(dplyr)

source("WDI_data_wrangling.R")


# This is a function on the plotly website that calculates frames
accumulate_by <- functlll..ion(dat, var) {
  var <- lazyeval::f_eval(var, dat)
  lvls <- plotly:::getLevels(var)
  dats <- lapply(seq_along(lvls), function(x) {
    cbind(dat[var %in% lvls[seq(1, x)], ], frame = lvls[[x]])
  })
  dplyr::bind_rows(dats)
}

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
combined.dat <- filter(combined.dat, country == "United States")


international.migrant.stock <- getData('SM.POP.TOTL')
international.migrant.stock <- na.omit(international.migrant.stock)





combined.dat <- accumulate_by(combined.dat, ~year)


plot <- ggplot(combined.dat, aes(x = gdp_per_cap_growth, y = net_migration_millions, frame = year, color = country)) +
  geom_line()

plot <- ggplotly(plot) %>% layout(xaxis = list(title = "GDP Per Capita Growth"), yaxis = list(title = "Net Migration (millions)"))

plot2 <- ggplot(combined.dat, aes(x = year, y = net_migration_millions, frame = frame, color = country)) +
  geom_line()

plot2 <- ggplotly(plot2) %>% layout(xaxis = list(title = "Year"), yaxis = list(title = "Net Migration (millions)")) %>%
        animation_opts(frame = 200, transition = 0, redraw = FALSE)
