
#  Load the libraries required for the exploratory data analysis
library(dplyr)
library(tidyr)
library(readr)
library(lubridate)


# Data processing

# Download the dataset
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
f <- file.path(getwd(), "exdata_data_household_power_consumption.zip")


if (!file.exists("exdata_data_household_power_consumption.zip")) {
  download.file(url = url, destfile = "exdata_data_household_power_consumption.zip");
}

# unzip the data
if (!file.exists("household_power_consumption.txt")) {
  unzip("./exdata_data_household_power_consumption.zip");
}

# read the household power consumption data; NAs are marked in the input file by the symbol "?"
power_consumption <- read.table("./household_power_consumption.txt", 
                                sep = ";", 
                                header = TRUE,
                                na.strings = "?")

# Look at the summary of the data frame
head(power_consumption)
str(power_consumption)

#  Create a new column Date_derived by using the columns Date and Time and Converting these two columns to the PoSIXCT format
power_consumption$Date_derived <- as.Date(strptime(paste(power_consumption$Date, power_consumption$Time), format="%d/%m/%Y %H:%M:%S"))
power_consumption$Datetime_derived <- strptime(paste(power_consumption$Date, power_consumption$Time), format="%d/%m/%Y %H:%M:%S")


feb_one <- as.Date("2007-02-01", format="%Y-%m-%d")
feb_two <- as.Date("2007-02-02", format="%Y-%m-%d")

# Create a subset of the dataset to only include observations corresponding to dates "2007-02-01" or "2007-02-02" 
power_consumption_feb <- subset(power_consumption, power_consumption$Date_derived == feb_one | power_consumption$Date_derived == feb_two)


# Plot 2 - time series plot of global active power
png(filename =  "plot2.png", width = 480, height = 480, units = "px")
with(power_consumption_feb, plot(x = Datetime_derived, y = Global_active_power, type="l", xaxt = "n", xlab="", ylab = "Global Active Power (kilowatts)"))
# To change format of x-axis values to weekdays
axis.POSIXct(1, power_consumption_feb$Datetime_derived, format = "%a")

# To change format of x-axis values to dates
# axis.POSIXct(1, power_consumption_feb$Datetime_derived, format = "%d %b")

dev.off()

