## Across the United States, how have emissions from coal combustion-related 
## sources changed from 1999–2008?

setwd("~/git/ExDataPlotting3")

library(dplyr)
library(ggplot2)

# read in the data
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

NEI <- tbl_df(NEI)
SCC <- tbl_df(SCC)

# 1. get all the SCC values that are coal combustion-related
SCCfilter <- SCC %>%
    filter(grepl("\\b[Cc]omb\\b.*?\\b[Cc]oal\\b", SCC$Short.Name)) %>%
    select(SCC)
# make n x 1 data.frame into 1 x n vector
SCCfilter <- as.vector(t(SCCfilter))

# 2. get the sum of emissions for each year in a new data.frame and filter
#    on the SCC values
NEIyears <- NEI %>%
    filter(SCC %in% SCCfilter) %>%
    group_by(year) %>%
    select(year, Emissions) %>%
    summarise(totalEmissions = sum(Emissions))

# 3. plot the emissions in ggplot2
png("plot4.png", 580, 380)
qplot(year, totalEmissions/1000, data = NEIyears) + 
    scale_x_continuous(breaks=c(1999, 2002, 2005, 2008)) +
    ggtitle("Total emission from coal combustion-related sources in the United States") +
    xlab("Year") +
    ylab(expression('Emission of PM'[2.5]*' (in Ktons)'))
dev.off()