library(dplyr)
localfile <- "./data/extdata-data-household_power_consumption.zip"

if(!file.exists(localfile)){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", dest=localfile, mode="wb")
}

unzipdir <- "./data/extdataproj"

if (list.files(unzipdir) != unzip(localfile, list=TRUE)$Name){
  unzip(localfile, exdir=unzipdir)
  print("unzipped")
}

filename <- unzip(localfile, list=TRUE)$Name

getrows = -1
if (!exists("dnp")){
  dnp <- read.table(paste(unzipdir, filename, sep="/"), na.strings="?", sep=";", header=TRUE, nrows=getrows, stringsAsFactors=FALSE) ##fails so maybe need to fix this in the txt file
  dnp$DateDate <- as.Date(paste(dnp$Date), "%d/%m/%Y") # returns invalid date without formatting
  dnp$stptimeT <- as.POSIXct(strptime(paste(dnp$Date, dnp$Time, sep=" "), "%d/%m/%Y %H:%M:%S"))
  dnp$testdt <- paste(dnp$Date, dnp$Time, sep=" ")
  dnp <- tbl_df(dnp)
  dnp <- dnp %>% filter(DateDate == as.Date("2007-02-01") | DateDate == as.Date("2007-02-02"))
}
Sys.setlocale("LC_TIME", "English")

png("plot3.png",width=480,height=480,units="px")
with(dnp, plot(stptimeT, Global_active_power,  type = "n", main="", sub="", xlab="", ylab="Energy sub metering"))
with(dnp, points(stptimeT, Sub_metering_1, type="l", col = "black"))
with(dnp, points(stptimeT, Sub_metering_2, type="l", col = "red"))
with(dnp, points(stptimeT, Sub_metering_3, type="l", col = "blue"))
legend("topright", lty=1, col= c("black",  "red", "blue"), legend= c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()

Sys.setlocale("LC_TIME", "Dutch")

