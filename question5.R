## How have emissions from motor vehicle sources changed from 1999–2008 in 
## Baltimore City?

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
#    on the SCC values and Baltimore City
NEIyears <- NEI %>%
    filter(fips == "24510" & SCC %in% SCCfilter) %>%
    group_by(year) %>%
    select(year, Emissions) %>%
    summarise(totalEmissions = sum(Emissions))

# 3. plot the emissions in ggplot2
png("plot5.png", 600, 380)
qplot(year, totalEmissions, data = NEIyears) + 
    scale_x_continuous(breaks=c(1999, 2002, 2005, 2008)) +
    ggtitle("Total emission from motor vehicles in Baltimore City, Maryland") +
    xlab("Year") +
    ylab(expression('Emission of PM'[2.5]*' (in tons)'))
dev.off()