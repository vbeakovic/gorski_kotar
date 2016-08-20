library(leaflet)
cities <- read.csv(textConnection("
City,Lat,Long,Pop
                                  Poreč,45.2258,13.593
                                  "))

leaflet(cities) %>% addTiles() %>%
        addCircles(lng = ~Long, lat = ~Lat, weight = 1,
                   radius = 100000, popup = ~City
        )