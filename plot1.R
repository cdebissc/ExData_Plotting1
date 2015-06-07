## plot1.png
## Below is just reference URL if needed for later; data file is now in my working directory.
## fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
## download.file(fileUrl, destfile = "./household_power_consumption.txt", method = "curl")

## Apply TA Astrego's suggestion on forum to use skip/nrows to grab only data for 2/1/2007 
## and 2/2/2007, and add in column names afterward.
## First I calculated the number of rows to be skipped as:
## 1(header)+396(12/16/2006 instances)+66240(12/17/2006-1/31/2007 instances)=66637 rows 
## I calculated we must then read (60min/hr)*(24hr/day)*(2days)=2880 rows for 2/1/2007-2/2/2007.
## I then added header row names with col.names in read.table below.
hpcData <- read.table("./household_power_consumption.txt", header=FALSE,
           sep=";", fill=FALSE, strip.white=TRUE,stringsAsFactors=FALSE, 
           na.strings="?", skip=66637, nrows=2880, 
           col.names=c("Date","Time","Global_active_power","Global_reactive_power",
                      "Voltage","Global_intensity","Sub_metering_1","Sub_metering_2",
                      "Sub_metering_3"))

## Grab only rows that do not have missing values
data <- hpcData[complete.cases(hpcData), ]

## Make histogram plot1.png
png(file = "plot1.png") ## Open PNG device; create 'plot1.png' in my working directory
## Create plot and send to a file (no plot appears on screen)
par(mar=c(4,4,2,1)) ## Set plot margins
hist(data$Global_active_power,xlab="Global Active Power (kilowatts)",
    col="red", main = "Global Active Power")
dev.off() ## Close the PNG file device