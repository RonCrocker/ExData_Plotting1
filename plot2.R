# plot2.R
#
# Plot a line chart of Global Active Power vs time of day
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

# PLOT 2: Global Active Power vs Time of day

png(filename="plot2.png", width=480, height=480)

plot(x=dt$DateTime, 
     y=dt$Global_active_power, 
     type="l", 
     ylab="Global Active Power (kilowatts)",
     xlab="",
     main="")

# Save file
dev.off()
