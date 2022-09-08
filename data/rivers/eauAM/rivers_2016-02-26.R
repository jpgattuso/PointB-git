Sys.setenv(TZ = "UTC")
library(dplyr)
library(ggplot2)
filein <- "eau-sup-AlpesMaritimes-PHYSICO-CHIMIE.RData"
load(filein)
eau <- tbl_df(eau)
eau$station <- as.factor(eau$station)
eau$code <- as.factor(eau$cp)
eau$date <- as.POSIXct(strptime(eau$date, format = "%d/%m/%y"))
eau$value[grep("<", eau$value)] <- "0"
eau$value <- as.numeric(eau$value)
dat <- select(eau, -cp)
tmp <- filter(dat, parameter == "TAC (°F)") %>%
    group_by(station) %>%
    summarise(mean_TAC = mean(value, na.rm=TRUE))
p <- ggplot(data = tmp, aes(x=station, y=mean_TAC/10)) +
  geom_bar(stat="identity") +
  coord_flip() +
  labs(y="Mean_TAC/10 (mmol/l)", x="Stations")

pdf(file = "mean_TAC.pdf", width = 8, height = 11)
  print(p)
dev.off()
