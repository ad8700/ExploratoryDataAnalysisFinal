#Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
#(\color{red}{\verb|fips == "24510"|}fips == "24510") from 1999 to 2008? 
#Use the base plotting system to make a plot answering this question.

#Import Libraries
library(readr)
library(tidyverse)

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

#Create a summary of the data by year
filtered <- raw_df %>% 
  filter(fips == "24510") %>%
  group_by(year) %>%
  summarize(total_pm25 = as.numeric(sum(Emissions)))

#Create a graph showing if total emissions from PM2.5 decreased in Baltimore 
#City from 1999 to 2008
png("plot2.png")
barplot(total_pm25 ~ year, data = filtered)
dev.off()