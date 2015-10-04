##### State data ####

require("rgdal") # requires sp, will use proj.4 if installed
require("maptools")

zipfileSt <- 'cb_2014_us_state_20m'
download.file(paste0('http://www2.census.gov/geo/tiger/GENZ2014/shp/', zipfileSt, '.zip'), destfile = paste0('scratch/',zipfileSt, '.zip'))
unzip(paste0('scratch/', zipfileSt, '.zip'))

stateShp <- readOGR(dsn = '.', layer = 'cb_2014_us_state_20m')
uscbSt <- stateShp@data
nrow(uscbSt)
head(uscbSt)
uscbSt$region <- tolower(uscbSt$NAME)

library(choroplethrMaps)
data(state.regions)
head(state.regions)


df_area_state <- merge(state.regions, 
                       uscbSt, by = "region")
nrow(df_area_state) == nrow(state.regions)

#now to select desired columns
names(df_area_state)
df_area_state <- df_area_state[, c(1, 12:13)]
df_area_state$totalarea <- with(df_area_state, ALAND + AWATER)

###df_area_state$ALAND <- df_area_state$ALAND / (1000 ^ 2)

save(df_area_state, file = 'data/df_area_state.rdata')

