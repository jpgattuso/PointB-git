file <- "toto"
wanted <- "PHYSICO-CHIMIE"
filein <- "eau-sup-AlpesMaritimes-cotiers-PACA-2010-2019-tabule-correctes.csv"
fileout <- paste(paste("eau-sup-AlpesMaritimes", wanted, sep = "-"), "RData", sep = ".")
x <- scan(file = filein, what = "", sep = "\n", blank.lines.skip = FALSE, fileEncoding = "ISO-8859-1")
#x
i <- grep("\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*", x)
i.st.deb <- c(1, i + 1)
i.st.fin <- c(i - 1, length(x))
nst <- length(i.st.deb)
quantities <- NULL
sts <- NULL
begin <- TRUE
for(n in 1:nst) {
	write(file = "tmp.y", x[(i.st.deb[n]):(i.st.fin[n])], ncolumns = 1)
	y <- scan(file = "tmp.y", what = "", sep = "\n", blank.lines.skip = FALSE)
	n.seps <- which(y == "")
print("-------------------------------")
print(n)
	i.st <- 1
	st <- y[i.st]
	sts <- append(sts, st)
print(st)
	i.cp <- 2
	cp <- gsub("[[:punct:]]", "", y[i.cp])
print(cp)
	for(k in 1:(length(n.seps) - 1)) {
		write(file = "tmp.z", y[n.seps[k]:(n.seps[k + 1] - 1)], ncolumns = 1)
		z <- read.table(file = "tmp.z", header = FALSE, sep = ";", colClasses = "character")
		z <- z[-length(z)]
		if(z[1, 1] == wanted) {
print(z)
			for(l in 2:length(z)) {
				dte <- z[1, l]
				valid <- z[2, l]
				if(begin) {
					eau <- data.frame(station = st, cp = cp, date = dte, valid = valid, parameter = z[-c(1,2), 1], value = z[-c(1,2), l], stringsAsFactors = FALSE)
					begin <- FALSE
				} else {
					eau <- rbind(eau, data.frame(station = st, cp = cp, date = dte, valid = valid, parameter = z[-c(1,2), 1], value = z[-c(1,2), l], stringsAsFactors = FALSE))
				}
			}
			quantities <- append(quantities, z$V1)
		}
	}
	unlink("tmp.y"); unlink("tmp.z")
}
save(file = fileout, eau)
unique(quantities)
unique(sts)
