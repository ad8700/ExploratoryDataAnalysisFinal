#objective - Have total emissions from PM2.5 decreased in the United States 
#from 1999 to 2008? Using the base plotting system, make a plot showing the 
#total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, 
#and 2008.

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
summarized <- raw_df %>% 
  group_by(year) %>%
  summarize(total_pm25 = as.numeric(sum(Emissions)))

#Create a graph showing total PM2.5 emission from all sources for each of the years
png("plot1.png")
barplot(total_pm25 ~ year, data=summarized)
dev.off()