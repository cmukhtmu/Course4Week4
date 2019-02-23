library(data.table)
library(ggplot2)
library(gridExtra)
library(ggpubr)

plot6 <- function()
{
    # downloading the zip file
    if(!file.exists("./exdata_data_NEI_data.zip"))
    {
        print("Downloading zip file, please wait...")
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "./exdata_data_NEI_data.zip")
        print("Zip file downloaded successfully!")
    }
    
    # extracting the zip file    
    if(!file.exists("./summarySCC_PM25.rds"))
    {
        print("Extracting zip file, please wait...")
        unzip("./exdata_data_NEI_data.zip")
        print("Zip file extracted successfully!")
    }
    
    if(file.exists("./summarySCC_PM25.rds") & file.exists("./Source_Classification_Code.rds"))
    {
        # reading the rds file in a data frame
        print("Reading data from RDS files, please wait...")
        NEI = readRDS("summarySCC_PM25.rds")
        Classification_Code = readRDS("Source_Classification_Code.rds")
        print("RDS files read successfully!")
        
        # writing data frame into data table       
        print("Converting data frames into data tables for operations...")
        DT = as.data.table(NEI)
        Codes = as.data.table(Classification_Code)
        print("Converted successfully!")
        
        # getting the sum of emissions by year from motor vehicle sources changed in Baltimore City and LA
        print("Calculating emissions sum by year from coal combustion-related sources ...")
        vehicleCodes = Codes[tolower(Short.Name) %like% "vehicle", "SCC"]
        baltimoreVehicleList = DT[fips=="24510" & SCC %in% vehicleCodes$SCC, list(total = sum(Emissions)), by=year]
        laVehicleList = DT[fips=="06037" & SCC %in% vehicleCodes$SCC, list(total = sum(Emissions)), by=year]
        print("Calculations completed.")
        
        # plotting with year on X-axis and total emissions on Y-axis
        print("Drawing plot...")
        
        p1 = ggplot(baltimoreVehicleList, aes(year, total)) +
            geom_point() +
            ggtitle("Motor Vehicles in Baltimore") + 
            geom_smooth()
        
        p2 = ggplot(laVehicleList, aes(year, total)) +
            geom_point() +
            ggtitle("Motor Vehicles in LA") + 
            geom_smooth()
        
        ggarrange(p1, p2)
        
        ggsave("plot6.png", width = 5, height = 5)
        
        print("Plot 6 created successfully: plot6.png")
        print("***  E N D   O F   P R O G R A M  ***")
    }
}