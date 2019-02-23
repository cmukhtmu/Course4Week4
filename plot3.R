library(data.table)
library(ggplot2)
library(gridExtra)
library(ggpubr)

plot3 <- function()
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
    
    if(file.exists("./summarySCC_PM25.rds"))
    {
        # reading the rds file in a data frame
        print("Reading data from RDS file, please wait...")
        NEI = readRDS("summarySCC_PM25.rds")
        print("RDS file read successfully!")
        
        # writing data frame into data table       
        print("Converting data frame into data table for operations...")
        DT = as.data.table(NEI)
        print("Converted successfully!")
        
        # getting the sum of emissions by year where fips equals to 24510 (Baltimore, Maryland)
        print("Calculating emissions sum by year where fips equals to 24510...")
        pointList = DT[fips=="24510" & type=="POINT",list(total = sum(Emissions)), by=year]
        nonpointList = DT[fips=="24510" & type=="NONPOINT",list(total = sum(Emissions)), by=year]
        onroadList = DT[fips=="24510" & type=="ON-ROAD",list(total = sum(Emissions)), by=year]
        nonroadList = DT[fips=="24510" & type=="NON-ROAD",list(total = sum(Emissions)), by=year]
        print("Calculations completed.")
        
        # plotting with year on X-axis and total emissions on Y-axis
        print("Drawing plot...")
    
        p1 = ggplot(pointList, aes(year, total)) +
            geom_point() +
            ggtitle("Point") + 
            geom_smooth()
        
        p2 = ggplot(nonpointList, aes(year, total)) +
            geom_point() +
            ggtitle("Non Point") + 
            geom_smooth()
        
        p3 = ggplot(onroadList, aes(year, total)) +
            geom_point() +
            ggtitle("On Road") + 
            geom_smooth()
        
        p4 = ggplot(nonroadList, aes(year, total)) +
            geom_point() +
            ggtitle("Non Road") + 
            geom_smooth()
        
        ggarrange(p1, p2, p3, p4)
        
        ggsave("plot3.png", width = 5, height = 5)
        
        print("Plot 3 created successfully: plot3.png")
        print("***  E N D   O F   P R O G R A M  ***")
    }
}