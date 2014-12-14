## Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510")
## from 1999 to 2008? Use the base plotting system to make a plot answering this question.

setwd("~/git/ExDataPlotting3")

library(dplyr)

# read in the data
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

NEI <- tbl_df(NEI)
SCC <- tbl_df(SCC)

# 1. get the sum of emissions for each year in a new data.frame, filter on
#    Baltimore City
NEIyears <- NEI %>%
    filter(fips == "24510") %>%
    group_by(year) %>%
    select(year, Emissions) %>%
    summarise(totalEmissions = sum(Emissions))

# 2. plot the emissions as dots
png("plot2.png", 480, 380)
with(NEIyears, {
    plot(year, 
         totalEmissions,
         pch = 19,
         main="Total emission in Baltimore City, Maryland",
         xlab='Year',
         xaxt="n",
         ylab=expression('Emission of PM'[2.5]*' (in tons)'))
    axis(1, at = year, labels = year)
})
dev.off()