#Of the four types of sources indicated by the \color{red}{\verb|type|}type 
#(point, nonpoint, onroad, nonroad) variable, which of these four sources have 
#seen decreases in emissions from 1999–2008 for Baltimore City? 
#Which have seen increases in emissions from 1999–2008? 
#Use the ggplot2 plotting system to make a plot answer this question.

#Import Libraries
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

#Create a summary of the data by year
by_type <- raw_df %>% 
  filter(fips == "24510") %>%
  group_by(year, type) %>%
  summarize(total_pm25 = as.numeric(sum(Emissions)))

#Create a graph showing which of the four sources have seen decreases 
# and increases in emissions from 1999–2008 for Baltimore City
p <- ggplot(data=by_type, aes(x=year, y=total_pm25, fill=type)) + 
  geom_bar(stat="identity", position=position_dodge())
png("plot3.png")
print(p)
dev.off()