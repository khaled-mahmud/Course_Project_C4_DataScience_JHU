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

# Subsetting data frame according to the condition 
# where city is Baltimore City, Maryland (fips == "24510") and
# calculating total emission over year per type by aggregate function
baltimore_by_type <- subset(NEI, fips == "24510") %>% aggregate(Emissions~year + type, ., FUN=sum)

# Plotting the chart
ggplot(baltimore_by_type, aes(x = factor(year), y = Emissions)) + 
  facet_grid(. ~ type) + 
  geom_bar(stat = "identity", fill = baltimore_by_type$year) +
  geom_text(aes(label = round(Emissions)), size = 2.8, hjust = 0.5, vjust = -0.5) +
  xlab("Years") +
  ylab(expression(paste("PM"[2.5], " Emission"))) + 
  ggtitle(expression(paste("PM"[2.5], " Emissions per Type over the Years in Baltimore City, MD"))) + 
  theme(plot.title = element_text(hjust = 0.5))
  

# Saving png file
dev.copy(png, "plot3.png", 560, 480)
dev.off()
