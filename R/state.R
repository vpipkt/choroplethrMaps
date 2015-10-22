#' Map of the 50 US states plus the District of Columbia.
#' 
#' A data.frame which contains a map of all 50 US States plus 
#' the District of Columbia.  The shapefile
#' was modified using QGIS in order to 1) remove
#' Puerto Rico and 2) remove islands off of Alaska that
#' crossed the antimeridian 3) renamed column "STATE" to "region".
#'
#' @docType data
#' @name state.map
#' @usage data(state.map)
#' @references Taken from the US Census 2010
#' Cartographic Boundary shapefiles page (https://www.census.gov/geo/maps-data/data/tiger-cart-boundary.html) in May 2014.
#' The resolutions is 20m (20m = 1:20,000,000). 
#' @examples
#' \dontrun{
#' # render the map with ggplot2
#' library(ggplot2)
#' 
#' data(state.map)
#' ggplot(state.map, aes(long, lat, group=group)) + geom_polygon()
#' }
NULL

#' State region definitions
#' 
#' A data.frame consisting of each region on the map state.map plus their postal code 
#' abbreviations and FIPS codes.
#' 
#' choroplethr requires you to use the naming convention in the "region" column
#' (i.e. all lowercase, full name).
#' 
#' @docType data
#' @name state.regions
#' @usage data(state.regions)
#' @references Taken from http://www.epa.gov/envirofw/html/codes/state.html
#' @examples
#' data(state.regions)
#' head(state.regions)
NULL

#' Areas of the 50 US states plus the District of Columbia
#' 
#' A data.frame consisting of each region on the map state.map with the total area in
#' square kilometers and square miles. This data.frame is useful for creating measures
#' of intensity normalized by area, such as population density.
#' 
#' choroplethr requires you to use the naming convention in the "region" column
#' (i.e. all lowercase, full name).
#' 
#' @docType data
#' @name state.area
#' @usage data(state.area)
#' @references Areas as reported by the US Census Bureau
#' Cartographic Boundary shapefiles page (https://www.census.gov/geo/maps-data/data/tiger-cart-boundary.html) in October 2015.
#' @examples
#' \dontrun{
#' data(state.area)
#' data(state.regions)
#' head(merge(state.area, state.regions))
#' }
NULL

#' Normalize state data by area
#' 
#' Given a data frame with a variables "region" and "value", normalizes the value
#' by the area of the region, if the region is a state, as defined in state.regions.
#' The returned data frame conains the normalized variable in "value", for use
#' with choroplethr functions.
#' 
#' @param df A data.frame with a column named "region" and a column named "value". 
#' Observations in the "region" column must exacly match "state.regions$region".
#' @param unit One of "km2" for square kilometers or "mi2" for square miles. By default
#' square kilometers is used.
#' @return A data frame with the "value" column normalized by area.
#' @examples
#' \dontrun{
#' }
#' @export
normalize_df_area <- function(df, unit = c("km2", "mi2")){
  #this generates a NOTE in checking....  see also http://www.hep.by/gnu/r-patched/r-exts/R-exts_8.html
  data(state.area, envir = environment())
  
  #check df is a data frame.
  
  #check df has a region column
  
  #check df has a value column
  
  #if df has columns named totalArea* remove them
  
  df2 <- merge(df, state.area, by = "region", all.x = TRUE, all.y = FALSE)
  
  unit <- match.arg(unit)
  if(unit == 'mi2')
    df2$value <- df2$value / df2$totalAreami2 
  else
    df2$value <- df2$value / df2$totalAreakm2 
  
  
  return(merge( df[ , names(df) != "value"], 
                df2[ , names(df2) %in% c("value", "region")], 
                by = "region"))
}