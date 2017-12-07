
g <- list(
  showframe = FALSE,
  showcoastlines = TRUE,
  scope = "world"
)


df <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv', stringsAsFactors = FALSE)

migration.data <- getData("SM.POP.NETM", countries = "US") %>% na.omit()
colnames(migration.data)[3] <- "net_migration"
migration.data$net_migration <- migration.data$net_migration / 1000000
colnames(migration.data)[3] <- "net_migration_millions"


makeMapData <- function(year, indicator) {
  migration.all.data <- getData(indicator, start.year = year, end.year = year) %>%
    na.omit() 
  
  codes <- read.csv('all.csv', stringsAsFactors = FALSE)
  
  data.w.codes <- inner_join(migration.all.data, codes, by = c("iso2c" = "alpha.2"))
  return(data.w.codes)
}

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