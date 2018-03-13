library(lubridate)

temp <- tempfile() # sets up a temporary file for the zipped dataset
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
# above URL given in course materials
download.file(url, temp) # assigns the zipped dataset to temp
dataset <- read.table(unz(temp, "household_power_consumption.txt"), sep = ";", skip = 66637, nrow = 2880)
# reads the unzipped file into memory

# reads only the 2880 rows corresponding to the dates 1 Jan as given in
# course materials. loading and subsetting the entire dataset was very slow
unlink(temp) # gets rid of the temp file

colnames(dataset) <- c("Date", "Time", "Global_active_power",
                       "Global_reactive_power", "Voltage", "Global_intensity",
                       "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")

dataset$Date <- dmy_hms(paste(dataset$Date, dataset$Time))
# combines date and time into one column for time series plotting


png(filename = "plot4.png") # other default values agree with project requirements

par(mfcol = c(2,2)) # fills column-wise in 2x2 grid

plot(dataset$Date, dataset$Global_active_power, type = "n", xlab = "", ylab = "")
lines(dataset$Date, dataset$Global_active_power)
title(ylab = "Global Active Power (kilowatts)")

plot(dataset$Date, dataset$Global_active_power, type = "n",
     xlab = "", ylab = "", ylim = c(0,max(dataset$Sub_metering_1)))
lines(dataset$Date, dataset$Sub_metering_1)
lines(dataset$Date, dataset$Sub_metering_2, col = "red")
lines(dataset$Date, dataset$Sub_metering_3, col = "blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2",
                              "Sub_metering_3"), col = c("black",
                                                         "red", "blue"), lty = c(1,1,1))

title(ylab = "Energy sub metering")

plot(dataset$Date, dataset$Voltage, type = "n", xlab = "Time")
lines(dataset$Date, dataset$Voltage, col = "black")

plot(dataset$Date, dataset$Global_reactive_power, type = "n")
lines(dataset$Date, dataset$Global_reactive_power)

dev.off() # closes graphics device