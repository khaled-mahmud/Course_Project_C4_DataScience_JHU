# Loading "dplyr" and "RColorBrewer" package
#install.packages("dplyr")
#install.packages("RColorBrewer")
library(dplyr)
library(RColorBrewer)

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
# calculating total emission over year by aggregate function
baltimore <- subset(NEI, fips == "24510") %>% aggregate(Emissions~year, ., FUN=sum)

# Setting color palate
pal <- brewer.pal(4, "Set2") 

# Plotting the bar chart
barplot(baltimore$Emissions, 
        names = baltimore$year,
        col = pal,
        xlab = "Years", ylab = expression(paste("PM"[2.5], " Emission")), 
        main = expression(paste("PM"[2.5], " Emission over Years for Baltimore City, MD")))

# Saving png file
dev.copy(png, "plot2.png")
dev.off()



