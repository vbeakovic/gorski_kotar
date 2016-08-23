#### Define keywords ###
keywords <- c("zemljište", "teren", "parcela")
#### Prepare locations ####
locations <- tolower(gsub(" ", "+", locationList$location, fixed = TRUE))
# to many results with velika+voda
locations <- locations[-9]

#### Retreive ad links ####
# Loop trough locations #
adsList <- list()
for (i in seq_along(locations)) {
        # Loop trough keywords #
        for (j in seq_along(keywords)) {
                index = 1 # pagination detection
                # form search query
                while (index != 0) {
                if (index == 1) {
                        queryUrl <- paste0("http://www.njuskalo.hr/?ctl=search_ads&keywords=", 
                                           keywords[j], "+", locations[i])  
                } else {
                        queryUrl <- paste0("http://www.njuskalo.hr/index.php?ctl=search_ads&keywords=", 
                                           keywords[j], "+", locations[i], "&page=", index)
                }      
                       
                        searchList <- htmlParse(queryUrl)
                        pathAds <- "/html/body/div/div/div/main/form/div/div/div/div/ul/li/article/h3/a"
                        adsListTmp <- xpathSApply(doc = searchList, path = pathAds, fun = xmlAttrs)
                        if (length(adsListTmp) > 0) {
                             adsList[[length(adsList) + 1]] <- adsListTmp   
                        }
                        print(length(adsListTmp))
                        pathPaging <- "//div[@class='entity-list-pagination entity-list-pagination--top']//nav/ul/li[@class='Pagination-item']/a"
                        pagesLinksTmp <- xpathSApply(doc = searchList, path = pathPaging, fun = xmlAttrs)
                        if (length(pagesLinksTmp) > 0) {
                               index = index + 1 
                        } 
                        if (length(adsListTmp) == 0 | length(pagesLinksTmp) == 0) {
                                index = 0
                                break
                        }
                        print(index)
                        print(queryUrl)
                        print(locations[i])
                }     
        }
}

# create a data frame
adsDf <- data.frame()
for (i in seq_along(adsList)) {
        adsDf <- rbind(adsDf, t(adsList[[i]]))
}
adsDf$href <- as.character(adsDf$href)
adsDf$name <- as.numeric(adsDf$name)
adsDf$class <- NULL

#### Retreive ads ####
adDf <- data.frame()
for (i in 1:NROW(adsDf)) {
        url <- paste0("http://www.njuskalo.hr", adsDf[i, 2])
        ad <- htmlParse(url)
        # broj oglasa
        pathNo <- "//b[@class='base-entity-id']"
        adNo <- xpathSApply(doc = ad, path = pathNo, fun = xmlValue)
        # datum
        pathDatum <- "//ul[@class='meta-items']//time[@pubdate='pubdate']"
        adDate <- xpathSApply(doc = ad, path = pathDatum, fun = xmlValue)[1]
        # cijena HRK
        pathPriceHRK <- "//div[@class='base-entity-meta']//strong[@class='price price--hrk']"
        adPriceHRK <- xpathSApply(doc = ad, path = pathPriceHRK, fun = xmlValue)
        # cijena EUR
        pathPriceEUR <- "//div[@class='base-entity-meta']//strong[@class='price price--eur']"
        adPriceEUR <- xpathSApply(doc = ad, path = pathPriceEUR, fun = xmlValue)
        
        # županija
        pathCounty <- "//tbody/tr/th | //tbody/tr/td"
        adData <- xpathSApply(doc = ad, path = pathCounty, fun = xmlValue)
        adCounty <- adData[2]
        adCity <- adData[4]
        adVillage <- adData[6]
        adTerrainType <- adData[8]
        adTerrainUsage <- adData[10]
        adTerrainArea <- adData[12]
        adTerrainCode <- adData[14]
        adRowDf <- data.frame(adNo = adNo,
                              adDate = adDate,
                              adPriceHRK = adPriceHRK,
                              adPriceEUR = adPriceEUR,
                              adCounty = adCounty,
                              adCity = adCity,
                              adVillage = adVillage,
                              adTerrainType = adTerrainType,
                              adTerrainUsage = adTerrainUsage,
                              adTerrainArea = adTerrainArea,
                              adTerrainCode = adTerrainCode
                              )
        print(i)
        adDf <- rbind(adDf, adRowDf)
        
}
save(adDf, file = "./data/adDf.Rdata")

#### Clean the data ####
adDfCleaned <- filter(adDf, adCounty == "Primorsko-goranska") %>% 
        filter(adCity %in% c("Bakar", 
                             "Brod Moravice", 
                             "Čabar", 
                             "Delnice", 
                             "Fužine",
                             "Jelenje",
                             "Lokve",
                             "Mrkopalj",
                             "Ravna Gora",
                             "Skrad",
                             "Vrbovsko"))
# HRK
adDfCleaned$adPriceHRK <- gsub("kn", "", adDfCleaned$adPriceHRK)
adDfCleaned$adPriceHRK <- gsub("\n", "", adDfCleaned$adPriceHRK)
adDfCleaned$adPriceHRK <- gsub("^\\s+|\\s+$", "", adDfCleaned$adPriceHRK)
adDfCleaned$adPriceHRK <- gsub(".", "", adDfCleaned$adPriceHRK, fixed = TRUE)
adDfCleaned$adPriceHRK <- as.numeric(adDfCleaned$adPriceHRK)
# remove HRK NA's
adDfCleaned <- filter(adDfCleaned, !is.na(adPriceHRK))

# EUR
adDfCleaned$adPriceEUR <- gsub("€", "", adDfCleaned$adPriceEUR)
adDfCleaned$adPriceEUR <- gsub("\n", "", adDfCleaned$adPriceEUR)
adDfCleaned$adPriceEUR <- gsub("^\\s+|\\s+$", "", adDfCleaned$adPriceEUR)
adDfCleaned$adPriceEUR <- gsub(".", "", adDfCleaned$adPriceEUR, fixed = TRUE)
adDfCleaned$adPriceEUR <- as.numeric(adDfCleaned$adPriceEUR)

# Area
adDfCleaned$adTerrainArea <- gsub(",", ".", adDfCleaned$adTerrainArea)
adDfCleaned$adTerrainArea <- as.numeric(as.character(adDfCleaned$adTerrainArea))

# Price per m2
adDfCleaned$adPriceEURM2 <- round(adDfCleaned$adPriceEUR / adDfCleaned$adTerrainArea, 1)
adDfCleaned <- filter(adDfCleaned, adPriceEURM2 < 100) %>% 
        filter(adTerrainType != "Vikendica")

# Clean terrain type
adDfCleaned$adTerrainType <- droplevels(adDfCleaned$adTerrainType)


# Clean county
adDfCleaned$adCounty <- droplevels(adDfCleaned$adCounty)

# Clean City
adDfCleaned$adCity <- droplevels(adDfCleaned$adCity)

# Clean Village
adDfCleaned$adVillage <- droplevels(adDfCleaned$adVillage)

# save
save(adDfCleaned, file = "./data/adDfCleaned.Rdata")
