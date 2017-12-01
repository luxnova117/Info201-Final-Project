library(ggplot2)
library(plotly)

source("WDI_data_wrangling.R")

dat1 <- getData("SE.PRM.ENRL", country.codes$code[1:20])
dat1 <- filter(dat1, !(is.na(SE.PRM.ENRL)))
#colnames(gross.enroll.num)[3] <- "enrollment"

dat2 <- getData("SP.DYN.TFRT.IN", country.codes$code[1:20])
dat2 <- filter(dat2, !(is.na(SP.DYN.TFRT.IN)))
#colnames(unemployment.per)[3] <- "unemployment_percent"
dat3 <- getData("NY.GDP.PCAP.CD", c("US", "CA", "FR", "EG", "VN"))
dat3 <- filter(dat3, !(is.na(NY.GDP.PCAP.CD)))

combined.dat <- left_join(dat1, dat2, by = c("year", "iso2c", "country"))
combined.dat <- left_join(combined.dat, dat3, by = c("year", "iso2c", "country"))

usa.dat <- filter(combined.dat, country == "United States")
# df <- data.frame(
#   x = c(1,2,3,4), 
#   y = c(1,2,3,4), 
#   f = c(1,2,3,4)
# )
# 
# df2 <- data.frame(
#   x = c(1,3,5,7,9),
#   y = c(2,4,6,8,10),
#   f = c(1,2,3,4,5)
# )
# p <- ggplot(df, aes(df2$x, df2$y)) +
#   geom_point(aes(frame = f))

# p <- ggplotly(p)
plot <- ggplot(combined.dat, aes(x = SP.POP.TOTL, y = SP.DYN.TFRT.IN, frame = year, color = country)) +
  geom_point(aes(size = NY.GDP.PCAP.CD )) + geom_smooth(mapping = aes(x = usa.dat$SP.POP.TOTL, y = usa.dat$SP.DYN.TFRT.IN))

plot <- ggplotly(plot)

plot2 <- ggplot(dat1, aes(x = year, y = SE.PRM.ENRL, frame = year, color = country)) + geom_smooth()

plot2 <- ggplotly(plot2)
