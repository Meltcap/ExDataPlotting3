## Of the four types of sources indicated by the type (point, nonpoint, onroad,
## nonroad) variable, which of these four sources have seen decreases in emissions
## from 1999-2008 for Baltimore City? Which have seen increases in emissions from 
## 1999-2008? Use the ggplot2 plotting system to make a plot answer this question.

setwd("~/git/ExDataPlotting3")

library(dplyr)
library(ggplot2)

# read in the data
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

NEI <- tbl_df(NEI)
SCC <- tbl_df(SCC)

str(NEI)
str(SCC)

# 1. get the sum of emissions for each year in a new data.frame
NEIyears <- NEI %>%
    filter(fips == "24510") %>%
    group_by(year, type) %>%
    select(year, Emissions) %>%
    summarise(totalEmissions = sum(Emissions))

# 2. plot the emissions in ggplot2 with seperate plots for each type
qplot(year, totalEmissions, data = NEIyears, facets = . ~ type) + 
    geom_smooth(method='lm') +
    ggtitle("Total emission by type of source in Baltimore City, Maryland") +
    xlab("Year") +
    ylab(expression('Emission of PM'[2.5]*' (in tons)'))

