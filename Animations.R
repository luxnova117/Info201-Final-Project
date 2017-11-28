library(gganimate)
library(ggplot2)
library(magick)
library(animation)
library(installr)


install.ImageMagick(URL = "https://www.imagemagick.org/script/download.php")

source("WDI_data_wrangling.R")

us.code <- (filter(country.codes, name == "United States") %>% select(code))[[1]]
test.dat <- getData(indicators$GDP, us.code)
test.dat2 <- getData(indicators$population_total, us.code)
#test.dat2 <- select()

test.dat3 <- left_join(test.dat, test.dat2, by = c("country", "year", "iso2c"))

example.plot <- ggplot(data = test.dat3) + geom_point(mapping = aes(x = SP.POP.TOTL, y = NY.GDP.MKTP.CD, frame = year), color = "blue")

example.plot <- ggplot(test.dat3, aes(SP.POP.TOTL, NY.GDP.MKTP.CD, frame=year)) + geom_point()

gganimate(example.plot)