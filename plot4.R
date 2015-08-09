# plot4.R
#
# PLOT 4: 4-up charts of all the data
#
# vvvvvvv This code is shared across all the plotN.R files; it wants to be extracted into a module, but 
#         the TAs have made it clear that each of these plot files should be standalone, hence the code
#         is duplicated in each file.

url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
filepath<-"household_power_consumption.txt"
zipfile <- ".tmp.zip"

# If we don't have the data, go fetch it.
# This is a little tricky because it's zipped, so get the zip file first.
if (! filepath %in% list.files()) {
  download.file(url, destfile=zipfile, method="curl")
  # Unzip our temporary file
  unzip(zipfile)
  # Delete the temporary file
  unlink(zipfile)
}

# At this point, we have the data file. Load it into a data.table
dt <- data.table(read.csv(filepath, sep=";", na.strings="?", stringsAsFactors=FALSE))

# Convert the date column to a date
dt$Date <- as.Date(dt$Date, format="%d/%m/%Y")

# And filter down to just our desired date range
dt<-dt[dt$Date %in% as.Date(c("2007-02-01","2007-02-02"))]

# At this point, dt contains the power data for 2 days in February 2007.

# Construct a new Date+Time column

dt$DateTime <- as.POSIXct(strptime(paste(dt$Date,dt$Time),"%Y-%m-%d %H:%M:%S"))

# ^^^^^^^ End of shared portion

# PLOT 4: 4-up charts of all the data

png(filename="plot4.png", width=480, height=480)

# Set it to plot in a 2x2 grid, in this order: UL, UR, LL, LR
par(mfrow=c(2,2))
par(mar=c(4,4,1.5,1.5))
# UL Corner - Global active power by time of day (same as plot2)
plot(x=dt$DateTime, 
     y=dt$Global_active_power, 
     type="l", 
     ylab="Global Active Power (kilowatts)",
     xlab="",
     main="")

# UR Corner - Voltage by time of day
plot(x=dt$DateTime, 
     y=dt$Voltage, 
     type="l", 
     ylab="Voltage",
     xlab="datetime",
     main="")

# LL Corner - Submetering by time of day (same as plot 3)
plot(x=dt$DateTime, 
     y=dt$Sub_metering_1,
     type="n", 
     ylab="Global Active Power (kilowatts)",
     xlab="",
     main="")

legend("topright",
       c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lty=c(1,1,1),
       col=c("black","red","blue"),
       bty="n")

points(x=dt$DateTime, y=dt$Sub_metering_1, type="l")
points(x=dt$DateTime, y=dt$Sub_metering_2, type="l",col="red")
points(x=dt$DateTime, y=dt$Sub_metering_3, type="l",col="blue")

# LR Corner - Global reactive power by time of day
plot(x=dt$DateTime,
     y=dt$Global_reactive_power,
     type="l",
     ylab="Global_reactive_power",
     xlab="datetime")

dev.off()
