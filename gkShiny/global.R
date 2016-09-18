library(RJSONIO)
library(purrr)
library(XML)
library(dplyr)
library(ggplot2)
library(leaflet)
library(purrr)
library(gdata)
load("./data/adMerged.Rdata")
icon.fa <- makeAwesomeIcon(icon = 'home', markerColor = 'green', library='fa',
                           iconColor = 'white')

zoomLevel <- FALSE

adMergedMap <- group_by(adMerged, adVillage) %>% 
        filter(adPriceEURM2 > 9) %>% 
        summarise(adQty = n(), 
                  lat = max(lat), 
                  lon = max(lon),
                  minPrice = min(adPriceEURM2),
                  maxPrice = max(adPriceEURM2), 
                  meanPrice = mean(adPriceEURM2))
adMergedMap$label <- paste0(adMergedMap$adVillage, ": ", adMergedMap$adQty)
pal <- colorNumeric(c("blue", "red"), domain = adMergedMap$adQty)
adMergedFiltered <- filter(adMerged, adPriceEURM2 >= 10 & adPriceEURM2 < 50 & adTerrainType == "građevinsko")

sliderUpdates <- function(session) {
        updateSliderInput(session, "hrBond",
                          value = 5)
         updateSliderInput(session, "liq",
                           value = 2)
         updateSliderInput(session, "fin",
                           value = 5)
         updateSliderInput(session, "addition",
                           value = 5)
}
