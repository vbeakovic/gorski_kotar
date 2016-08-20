#### Libraries ####
library(RJSONIO)
library(purrr)

#### Read in locations ####
locationList <- read.csv("./data/locations.csv")


#### Retreive location coordinates ####
nrow <- nrow(locationList)
counter <- 1
locationList$lon[counter] <- 0
locationList$lat[counter] <- 0
while (counter <= nrow){
        CityName <- gsub(' ','%20',locationList$location[counter]) #remove space for URLs
        CountryCode <- locationList$countryCode[counter]
        url <- paste(
                "http://nominatim.openstreetmap.org/search?city="
                , CityName
                , "&countrycodes="
                , CountryCode
                , "&limit=9&format=json"
                , sep="")
        x <- fromJSON(url)
        if(is.vector(x)){
                locationList$lon[counter] <- x[[1]]$lon
                locationList$lat[counter] <- x[[1]]$lat    
        }
        counter <- counter + 1
}

# adjust Sokoli's longitude  45.5489733
locationList$lon[locationList$location == "Sokoli"] <- 14.6251844
locationList$lat[locationList$location == "Sokoli"] <- 45.5489733 

# coordinates to numeric
locationList$lon <- as.numeric(locationList$lon)
locationList$lat <- as.numeric(locationList$lat)
