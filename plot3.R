

# check to see if data directory exists, if not, create it.
if (!file.exists("data")) {
  dir.create("data")
}

# download the household power consumption data
if (!file.exists("data/household_power_consumption.zip")) {
  EPC.url <- "http://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip"
  download.file(EPC.url, destfile = "./data/household_power_consumption.zip")
  
}

data <- read.table(unz(description = "./data/household_power_consumption.zip",  
                       filename="household_power_consumption.txt"),  
                   header=TRUE, 
                   sep=";", 
                   nrows=2075259, 
                   colClasses = c("factor", "factor", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"), 
                   na.strings="?")

data$Date <- as.Date(data$Date, format="%d/%m/%Y")


# select only data that is relevent
data1 <- data[which(data$Date == '2007-02-01'),]
data2 <- data[which(data$Date == '2007-02-02'),]
data <- rbind(data1, data2)

data <- within(data, { timestamp <- as.POSIXct(paste(Date, Time)) })

# clean up
rm(data1)
rm(data2)

png(file="./data/plot3.png", width = 480, height=480, units="px")
with(data, { 
  plot(x=data$timestamp, y=data$Sub_metering_1, type ="l", ylab="Energy sub metering", xlab="")
  lines(x=data$timestamp, y=data$Sub_metering_2, col="red" )
  lines(x=data$timestamp, y=data$Sub_metering_3,  col="blue")
  legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")) 
})
dev.off()


