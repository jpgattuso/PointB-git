Sys.setenv(TZ = "UTC")
library(dplyr)
filein <- "eau-sup-AlpesMaritimes-PHYSICO-CHIMIE.RData"
filepdf <- "eau-sup-AlpesMaritimes-PHYSICO-CHIMIE.pdf"
load(filein)
eau <- tbl_df(eau)
eau$station <- as.factor(eau$station)
eau$code <- as.factor(eau$cp)
eau$date <- as.POSIXct(strptime(eau$date, format = "%d/%m/%y"))
eau$value[grep("<", eau$value)] <- "0"
eau$value <- as.numeric(eau$value)
dat <- select(eau, -cp)
dat
tmp <- filter(dat, parameter == "TAC (°F)") %>%
    group_by(station) %>%
    summarise(mean_TAC = mean(value, na.rm=TRUE))

for(n in names(eau)) {
	if(n != "value") {
		cat("--------------->", n, "\n")
		cat(levels(factor(eau[[n]])), sep = ";")
		cat("\n")
	}
}
eau$date <- as.POSIXct(strptime(eau$date, format = "%d/%m/%y"))
range(dates)
stations <- levels(factor(eau[["station"]]))
params <- levels(factor(eau[["parameter"]]))
str(stations)
values[grep("<", values)] <- "0"



pdf(file = filepdf, width = 8, height = 11)
for(param in params) {
	cat("----------------> plot", param, "\n")
	par(mfrow = c(4, 3), cex.lab = 0.7, cex.main = 0.7)
	for(station in stations) {
		i <- eau$station == station & eau$parameter == param
		if(!all(!i)) {
			cat(station, "", sep = ";")
			dtes <- dates[i]
			values <- eau$value[i]
# Traitement des valeurs "<xxx"; ici mise à zéro si le signe "<" est rencontré
			values[grep("<", values)] <- "0"
			values <- as.numeric(values)
			plot(dtes, values, xlab = "", ylab = param, main = station)
		}
	}
	cat("\n")
	dev.flush()
}
graphics.off()
