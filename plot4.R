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

# Subsetting data frame by coal combustion from the combination 
# of two data frames and calculating total emission
# over years by aggregate function 
df_coal <- SCC[grepl("coal", SCC$Short.Name, ignore.case=TRUE), ] %>% 
  merge(x = NEI, y = ., by = 'SCC') %>% 
  aggregate(Emissions~year, ., FUN = sum)

# Plotting the chart
ggplot(df_coal, aes(x = factor(year), y = Emissions / 1000)) + 
  geom_bar(aes(group = 1, fill = Emissions), stat = "identity", width = 0.75) +  
  # geom_line(aes(group = 1), col="red") + 
  # geom_point(col="red", size = 4) + 
  geom_text(aes(label = round(Emissions)), size = 4.5, hjust = 0.5, vjust = 2) + 
  xlab("Years") +
  ylab(expression(paste("PM"[2.5], " Coal Emission ", "(10"^-3, " Scale)"))) + 
  ggtitle(expression(paste("Total ", "PM"[2.5], " Coal Combustion Emissions over Years in US"))) + 
  theme(plot.title = element_text(hjust = 0.5))

# Saving png file
dev.copy(png, "plot4.png", 560, 480)
dev.off()

