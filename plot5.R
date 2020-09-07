# Loading "ggplot2" and "dplyr" package
#install.packages("ggplot2")
#install.packages("dplyr")
library(ggplot2)
library(dplyr)

# Downloading and extracting files
if(!file.exists("./data")) {
  dir.create("./data")
  fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileUrl, destfile = "./data/dataFile.zip") # For windows operating system method="curl" has been eliminated
  unzip("./data/dataFile.zip", exdir = "./data")
}

# Loading data into data frames
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

# Subsetting data frame by motor emission, where city is 
# Baltimore City, Maryland (fips == "24510") and
# calculating total emission over years by aggregate function 
baltimore_by_motor <- subset(NEI, fips == "24510" & type == 'ON-ROAD') %>% 
  aggregate(Emissions~year, ., FUN = sum)

# Plotting the chart
ggplot(baltimore_by_motor, aes(x = factor(year), y = Emissions)) + 
  geom_bar(stat = "identity", aes(fill = Emissions)) +
  # geom_line(aes(group = 1), col="red") +
  # geom_point(col="red", size = 4) + 
  geom_text(aes(label = round(Emissions)), size = 4.5, hjust = 0.5, vjust = 2) +
  xlab("Years") +
  ylab(expression(paste("PM"[2.5], " Motor Emission"))) + 
  ggtitle(expression(paste("PM"[2.5], " Motor Emissions over Years in Baltimore City, MD"))) + 
  theme(plot.title = element_text(hjust = 0.5))

# Saving png file
dev.copy(png, "plot5.png", 560, 480)
dev.off()

