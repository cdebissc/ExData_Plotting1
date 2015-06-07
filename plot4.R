## plot4.png
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

## Change Date column format
data$Date <- as.Date(data$Date, format="%d/%m/%Y")

## Add column indicating abbreviated weekday
data$Weekday <- weekdays(data$Date, abbreviate=TRUE)

## Merge date and time 
datestring <- paste(as.character(data$Date),data$Time)
data$DateTime <- strptime(datestring, "%Y-%m-%d %H:%M:%S")

## Make plot4.png
png(file = "plot4.png") ## Open PNG device; create 'plot4.png' in my working directory
## Create plot and send to a file (no plot appears on screen)
par(mfcol=c(2,2)) ## Multiple plots
## Top left plot
plot(data$DateTime,data$Global_active_power, main=NULL,
     xlab='', ylab="Global Active Power", type="l")
## Bottom left plot
plot(data$DateTime,data$Sub_metering_1, main=NULL,
     xlab='', ylab="Energy sub metering", type="n")
lines(data$DateTime,data$Sub_metering_1, type="l",col="black")
lines(data$DateTime,data$Sub_metering_2, type="l",col="red")
lines(data$DateTime,data$Sub_metering_3, type="l",col="blue")
legend("topright",lty=1,lwd=2,bty="n",col=c("black","red","blue"),
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
## Top right plot
plot(data$DateTime,data$Voltage, main=NULL,
     xlab="datetime", ylab="Voltage", type="l")
## Bottom right plot
plot(data$DateTime,data$Global_reactive_power, main=NULL,
    xlab="datetime", ylab="Global_reactive_power", type="l")
dev.off() ## Close the PNG file device