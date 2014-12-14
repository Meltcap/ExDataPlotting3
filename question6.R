## Compare emissions from motor vehicle sources in Baltimore City with emissions
## from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
## Which city has seen greater changes over time in motor vehicle emissions?
## Unclear: absolute changes or relative changes?

setwd("~/git/ExDataPlotting3")

library(dplyr)
library(ggplot2)

# read in the data
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

NEI <- tbl_df(NEI)
SCC <- tbl_df(SCC)

# 1. get all the SCC values that are from motor vehicles
SCCfilter <- SCC %>%
    filter(grepl("Highway Veh", SCC$Short.Name)) %>%
    select(SCC)
# make n x 1 data.frame into 1 x n vector
SCCfilter <- as.vector(t(SCCfilter))

# 2. get the sum of emissions for each year in a new data.frame, filter
#    on the SCC values and Baltimore City and Los Angeles County
county_names <- list(
    "24510" = "Baltimore City, Maryland", 
    "06037" = "Los Angeles County, California")

NEIyears <- NEI %>%
    filter(fips %in% c("24510", "06037") & SCC %in% SCCfilter) %>%
    mutate(county = unlist(county_names[fips])) %>%
    group_by(county, year) %>%
    select(county, year, Emissions) %>%
    summarise(totalEmissions = sum(Emissions)) %>%
    mutate(difference = totalEmissions - lag(totalEmissions, default = totalEmissions[1]))

# 3. plot the emissions in ggplot2
png("plot6.png", 600, 380)
qplot(year, totalEmissions, data = NEIyears, facets = . ~ county) +
    scale_x_continuous(breaks=c(1999, 2002, 2005, 2008)) +
    ggtitle("Total emission from motor vehicles") +
    xlab("Year") +
    ylab(expression('Emission of PM'[2.5]*' (in tons)'))
dev.off()