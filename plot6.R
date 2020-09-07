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
# Baltimore City, Maryland (fips == "24510") or Los Angeles County, California (fips == "06037")
# and calculating total emission over years by aggregate function 
df_motor <- subset(NEI, type == 'ON-ROAD' & (fips == "24510" | fips == "06037")) %>% 
  aggregate(Emissions~year + fips, ., FUN = sum)

# Renaming city from fips code
df_motor$fips[df_motor$fips == "06037"] <- "Los Angeles"
df_motor$fips[df_motor$fips == "24510"] <- "Baltimore City"


# Plotting the chart
ggplot(df_motor, aes(x = factor(year), y = Emissions)) + 
  facet_grid(. ~ fips) + 
  geom_bar(stat = "identity", fill = df_motor$year) +
  geom_text(aes(label = round(Emissions)), size = 4.5, hjust = 0.5, vjust = -0.5) +
  xlab("Years") +
  ylab(expression(paste("PM"[2.5], " Motor Emission"))) + 
  ggtitle(expression(paste("PM"[2.5], " Motor Emissions over Years in Baltimore City vs Los Angeles"))) + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  ylim(0, max(df_motor$Emissions) + 100)

# Saving png file
dev.copy(png, "plot6.png", 560, 480)
dev.off()


