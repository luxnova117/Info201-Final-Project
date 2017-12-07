# styling properties for map
g <- list(
  showframe = FALSE,
  showcoastlines = TRUE,
  scope = "world"
)

# pulls data frame with the correct country codes 
df <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv', stringsAsFactors = FALSE)


# Accepts an input year and an indicator and returns a data set to make the map
makeMapData <- function(year, indicator) {
  migration.all.data <- getData(indicator, start.year = year, end.year = year) %>%
    na.omit() 
  
  codes <- read.csv('all.csv', stringsAsFactors = FALSE)
  
  data.w.codes <- inner_join(migration.all.data, codes, by = c("iso2c" = "alpha.2"))
  return(data.w.codes)
}

# Accepts the data from makeMapData function with the indicator, the title, and color scheme for the map.
# Returns the world map.
makeMap <- function(data, indicator, the.title, colorscheme) {
  plot_geo(data) %>%
    add_trace(
      z = ~eval(parse(text=indicator)),
      color = ~eval(parse(text=indicator)),
      colors = colorscheme,
      locations = ~country,
      locationmode = "country names",
      text = ~paste(country, ": ", format(eval(parse(text=indicator)), big.mark=",", trim=TRUE)),
      type = "choropleth"
    ) %>%
    colorbar(title = "Number of People <br />(Million)") %>%
    layout(
      title = the.title,
      geo = g
    )
}
makeGraphData = function(coun, indicator){
  selected.code <- filter(country.codes, name == coun) %>% select(code)
  selected.data <- getData(indicator, countries = selected.code) %>% na.omit()
  return(selected.data)
}
