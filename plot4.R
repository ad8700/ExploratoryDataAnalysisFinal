# Across the United States, how have emissions from coal combustion-related 
# sources changed from 1999–2008?

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

#filter to only coal related sources
SCC <- readRDS("./data/Source_Classification_Code.rds")
sapply(SCC, class)
coal_types <- SCC %>% filter(grepl('coal|Coal', Short.Name))
coal_df <- inner_join(raw_df, coal_types, by="SCC")

#create a summary data set by year showing pm25 for only the coal types
coal_pm25 <- coal_df %>%
  group_by(year) %>%
  summarize(total_pm25 = as.numeric(sum(Emissions)))

#Create a graph which shows how emissions from coal combustion-related sources
# changed from 1999–2008
p <- ggplot(data = coal_pm25, aes(x=year, y=total_pm25)) + 
  geom_bar(stat="identity", fill="black")
png("plot4.png")
print(p)
dev.off()
