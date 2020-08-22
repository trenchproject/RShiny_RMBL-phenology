phen <- read_excel("phenology.xlsx", col_types = "numeric") %>% as.data.frame()
colnames(phen) <- c("Year", "melt", "snowfall", "snowpack", "marmot", "chipmunk", "robin", "jay", "blackbird", "junco", "flicker", "Fswallow", "sapsucker", "Fsparrow", "kinglet",
                    "Y-rwarbler", "Cswallow", "squirrel", "hummingbird", "Wsparrow", "cowbird", "bluebird", "Ywarbler", "bluebell", "lily", "beauty")

weather <- read_excel("weather.xls", col_types = "numeric") %>% as.data.frame()
colnames(weather) <- c("mdy", "year", "month", "day", "mintemp", "maxtemp", "new", "meltin", "meltmm", "total", "pack", "rainin", "rainmm")

water <- c()
for(yr in rev(unique(weather$year))) {
  water <- c(water, mean(rbind(subset(weather, year == yr & month > 8),
                               subset(weather, year == yr + 1 & month < 9))[,"meltmm"], na.rm = T))
}
water[1] <- NA
water <- c(water, NA)
phen <- cbind(phen, water)

#______________________________________________________________________________________

mins <- c()
maxes <- c()
for(yr in rev(unique(weather$year))) {
  mins <- c(mins, mean(weather[which(weather$month == 4 & weather$year == yr), "mintemp"]))
  maxes <- c(maxes, mean(weather[which(weather$month == 4 & weather$year == yr), "maxtemp"]))
  
}

mins <- c(NA, mins)
mins[length(mins)] <- NA
maxes <- c(NA, maxes)
maxes[length(maxes)] <- NA
phen <- cbind(phen, mins, maxes)

write.csv(phen, "phenology.csv", row.names = F)
