# Compare emissions from motor vehicle sources in Baltimore City with emissions 
# from motor vehicle sources in Los Angeles County, California 
# (\color{red}{\verb|fips == "06037"|}fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?

#Import libraries
library(readr)
library(tidyverse)
library(ggplot2)

#If data directory does not exist, create it

if(!dir.exists("./data")) {
  dir.create("./data")
} else {
  print("Data directory already exists")
}

#download the data to the data directory
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
dest <- "./data/emissions_data.zip"
download.file(fileUrl, dest)

#unzip the file
unzip(dest, exdir="./data")

#Read in the data from file
raw_df <- readRDS("./data/summarySCC_PM25.rds")

#Filter to only motor vehicle sources in Baltimore City (fips == "24510") and 
# Los Angeles (fips =="06037")
SCC <- readRDS("./data/Source_Classification_Code.rds")
mv_types <- SCC %>% filter(grepl('Vehicle', SCC.Level.Two))
mv_df <- inner_join(raw_df, mv_types, by="SCC")
bmore_la_raw <- filter(mv_df, fips=="24510" | fips == "06037")

#Summarize the data for the two cities by year, keep each city unique
bmore_la_summ <- bmore_la_raw %>%
  group_by(year, fips) %>%
  summarize(total_pm25 = as.numeric(sum(Emissions)))

# Create a graph comparing the pm25 for each city by year
p <- ggplot(data = bmore_la_summ, aes(x = year, y = total_pm25, fill=fips)) + 
  geom_bar(stat="identity", position=position_dodge())
png("plot6.png")
print(p)
dev.off()