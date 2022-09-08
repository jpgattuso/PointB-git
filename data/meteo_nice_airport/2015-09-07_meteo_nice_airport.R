library(dplyr)
library(ggplot2)
library(lubridate)

z <- read.table("data/meteo_nice_airport/meteo_2007_2014.csv", header=T, sep=",", dec=".", as.is=T)
head(z)
str(z)
z$date <- ymd(z$date)

# Plot
ggplot() + geom_point(data=z , aes(x=date, y=tm ), size=1)           
          