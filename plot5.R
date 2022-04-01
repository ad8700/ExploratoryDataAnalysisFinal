# How have emissions from motor vehicle sources changed from 1999–2008 in 
# Baltimore City?

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

#Filter to only motor vehicle sources in Baltimore City (fips == "24510")
SCC <- readRDS("./data/Source_Classification_Code.rds")
mv_types <- SCC %>% filter(grepl('Vehicle', SCC.Level.Two))
mv_df <- inner_join(raw_df, mv_types, by="SCC")
bmore_mv <- filter(mv_df, fips == "24510")

# Summarize the Baltimore Motor Vehicle data by year
bmore_mv_summ <- bmore_mv %>%
  group_by(year) %>%
  summarize(total_pm25 = as.numeric(sum(Emissions)))

# Create a graph which shows emissions from motor vehicle sources changed from 
# 1999–2008 in Baltimore City
p <- ggplot(data=bmore_mv_summ, aes(x=year, y=total_pm25)) +
  geom_bar(stat="identity", fill="black")
png("plot5.png")
print(p)
dev.off()

