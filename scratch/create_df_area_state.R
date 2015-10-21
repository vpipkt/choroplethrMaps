##### State area data ####
#this script extracts state area data from US Census Bureau TIGER shapefiles and prepares them for inclusion in the `choroplethrMaps` package.

require("rgdal") # requires sp, will use proj.4 if installed
require("maptools")
require('devtools')

#create a new directory for for the shapefile; 
setwd('scratch')
zipfileSt <- 'cb_2014_us_state_20m'
download.file(paste0('http://www2.census.gov/geo/tiger/GENZ2014/shp/', zipfileSt, '.zip'),  
              destfile = paste0(zipfileSt, '.zip'))
unzip(paste0(zipfileSt, '.zip'))

stateShp <- readOGR(dsn = '.', layer = zipfileSt)
uscbSt <- stateShp@data
nrow(uscbSt)
head(uscbSt)
uscbSt$region <- tolower(uscbSt$NAME)

library(choroplethrMaps)
data(state.regions)
head(state.regions)

#Merge with regions to get the identifier used throughout the choroplethr* family of packages
state.area <- merge(state.regions, 
                       uscbSt, by = "region")
nrow(state.area) == nrow(state.regions)

#create total area column, in square km (source data is in square meters)
state.area$totalAreakm2 <- with(state.area, ALAND + AWATER) / (1000 ^ 2)
#square miles [http://physics.nist.gov/Pubs/SP811/appenB8.html#M]
state.area$totalAreami2 <- with(state.area, ALAND + AWATER) / (1.609347e3 ^ 2) 

#Select desired columns
names(state.area)
state.area <- state.area[, c(1, 14:15)]

setwd('..')
save(state.area, file = 'data/state.area.rdata')

