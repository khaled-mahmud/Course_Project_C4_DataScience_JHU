# Loading "RColorBrewer" package
#install.packages("RColorBrewer")
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

# Calculating total emission over year for whole country by aggregate function
total_emission <- aggregate(Emissions~year, data = NEI, FUN=sum)

# Setting color palate
pal <- brewer.pal(4, "Set2") 

# Plotting the bar chart
barplot(total_emmission$Emissions, 
        names = total_emmission$year,
        col = pal,
        xlab = "Years", ylab = expression(paste("PM"[2.5], " Emission")), 
        main = expression(paste("Total ", "PM"[2.5], " Emission over Years in US")))

# Saving png file
dev.copy(png, "plot1.png")
dev.off()



