ggplot(adDfCleaned, aes(x = adPriceEURM2)) + 
        geom_histogram(color = "white", fill = "skyblue", binwidth = 5) + 
        facet_grid(adCity ~ adTerrainType)

#
areaReduced <- filter(adDfCleaned, adTerrainArea < 10000)
ggplot(areaReduced, aes(x = adTerrainArea)) + 
        geom_histogram(color = "white", fill = "skyblue", binwidth = 500) + 
        facet_grid(adCity ~ .)
        