## Have total emissions from PM2.5 decreased in the 
## United States from 1999 to 2008? Using the base 
## plotting system, make a plot showing the total 
## PM2.5 emission from all sources for each of the 
## years 1999, 2002, 2005, and 2008.
## Emissions are in tons.

setwd("~/git/ExDataPlotting3")

library(dplyr)
# read in the data
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

NEI <- tbl_df(NEI)
SCC <- tbl_df(SCC)

str(NEI)
str(SCC)

# 1. get the sum of emissions for each year in a new data.frame
NEIyears <- NEI %>%
    group_by(year) %>%
    select(year, Emissions) %>%
    summarise(totalEmissions = sum(Emissions))

# 2. plot the emissions as dots
with(NEIyears, plot(year, totalEmissions))
