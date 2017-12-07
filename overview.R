text_file <- "Purpose

The purpose of our project is to find an answer to the following questions: 
Where are people moving to these days? 
Who is moving and how has it changed over time?

Audience 

Our project would be helpful for governments and policy makers in that by looking at the trends of who is moving and how migration is changing over time with the help of our visualizations, they would be able to anticipate what migration would be like in their respective countries. This way, governments and policy makers are able to make certain legislative changes to say, accommodate an anticipated influx of immigrants or refugees over the next couple of years. 

Data 

For this project, we worked with data from the World Bank. The World Bank is an international financial institution that provides loans to countries of the world for capital programs. It was created in 1944 at the Bretton Woods Conference. The World Bank’s stated official goal is the reduction of poverty. The World Bank makes a ton of information available through its web API, which we’ve found a great version of on GitHub to use for our project: https://github.com/vincentarelbundock/WDI

Out of all the data available on the World Bank API, we chose to focus on four datasets: Net Migration, International Migrant Stock and Refugee Population by Country of Origin and of Asylum. The Net Migration dataset gives us data on the net number of people moving in and out of each country from 1962 to 2010 and with this data, see if more people are moving in or out of a country. The International Migrant Stock gives us data from 1960 to 2015 on the number of people living in a country where they were not born. The Refugee Population by Country of Origin and of Asylum gives us insight into how many refugees are in a country or forced out of a country from 1990 to 2016. 

https://data.worldbank.org/indicator/SM.POP.REFG
https://data.worldbank.org/indicator/SM.POP.REFG.OR
https://data.worldbank.org/indicator/SM.POP.NETM
https://data.worldbank.org/indicator/SM.POP.TOTL

Visualizations 

We have a total of four different tabs for each of the datasets. We made a world map for both the Net Migration data and Migrant Stock data where users can use the slider to select a year. The colors indicate the number of people that are moving in or out of the country in the Net Migration tab and the number of migrants living in a country that is not the country in which they were born for the Migrant Stock tab. From the map, we could see the migration trends in countries in each year and this answers the driving question behind our project of where people are moving to. 

We also have a graph in the same two tabs if the user wishes to see the data by country, where they simply have to select their desired country in a dropdown menu. This gives further insight into the trends of migration over the years and how it has changed over the years. 

The next two tabs are for the Refugee Population by country of origin and asylum respectively. Refugees are a subset of migrants and these two datasets answer the question of who is moving and the migration trend in refugees specifically over the years. Both of these tabs would have a world map with varying circle sizes to represent the number of refugees in that country. By looking at the map, we would easily be able to identify countries which have a large movement of refugees. 

Contact
Emma Liao
Stone Kaech
Jessica Zhu 
Alex Guo 
"