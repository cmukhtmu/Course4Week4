library(data.table)

plot1 <- function()
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
        
        # getting the sum of emissions by year
        print("Calculating emissions sum by year...")
        Dlist = DT[,list(total = sum(Emissions)), by=year]
        print("Calculations completed.")
        
        # plotting with year on X-axis and total emissions on Y-axis
        print("Drawing plot...")
        plot(Dlist$year, Dlist$total, pch=20)
        lines(Dlist$year, Dlist$total, type="l")
        
        # copying plot on to a png file
        print("Creating PNG file of plot...")
        dev.copy(png,"plot1.png", width=480, height=480)
        # closing the device
        dev.off()
        
        print("Plot 1 created successfully: plot1.png")
        print("***  E N D   O F   P R O G R A M  ***")
    }
}