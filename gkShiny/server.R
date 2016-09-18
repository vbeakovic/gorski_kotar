library(shiny)
library(shinyjs)
library(leaflet)
library(DT)
library(dplyr)
library(ggplot2)
library(ggrepel)

shinyServer(function(input, output, session) {
        #observe({
        #        if (!input$circleMarkers) {
        #                shinyjs::disable("markerColor")
        #                shinyjs::disable("priceEURM2")
        #                shinyjs::disable("slider2")
        #        } else {
        #                shinyjs::enable("markerColor")
        #                shinyjs::enable("priceEURM2")
        #                shinyjs::enable("slider2")
        #        }
        #})
        colorMeter <- reactive({
                if (input$markerColor == "Broj oglasa") {
                        return(adMergedMap$adQty)
                } else if (input$markerColor == "Min. cijena") {
                        return(adMergedMap$minPrice)
                } else if (input$markerColor == "Max. cijena") {
                        return(adMergedMap$maxPrice)
                } else {
                        return(adMergedMap$meanPrice)
                }
        })
        tableData <- reactive({
                if (!is.null(input$map_marker_click)) {
                        tmp <- filter(adMergedMap, adVillage == input$map_marker_click[[1]]) %>%
                                select(adVillage, minPrice, maxPrice, meanPrice)        
                } else {
                        tmp <- filter(adMergedMap, adVillage == "Sunger") %>%
                                select(adVillage, minPrice, maxPrice, meanPrice)        
                }
                
                tmp <- data.frame(x = names(tmp)[2:4], y = matrix(tmp[1,2:4], nrow = 3))

        })
        # Reactive expression for the data subsetted to what the user selected
        filteredData <- reactive({
                tmp <- filter(adMergedFiltered, adPriceEURM2 >= input$priceEURM2[1] & 
                                      adPriceEURM2 <= input$priceEURM2[2] & 
                                      adTerrainArea >= input$area[1] & 
                                      adTerrainArea <= input$area[2])  %>% 
                        group_by(adVillage) %>%
                        summarise(adQty = n(),
                                  lat = max(lat),
                                  lon = max(lon),
                                  minPrice = min(adPriceEURM2),
                                  maxPrice = max(adPriceEURM2),
                                  meanPrice = mean(adPriceEURM2)) 
                tmp$label <- paste0(tmp$adVillage, ": ", tmp$adQty)
                tmp
        })
        output$map <- renderLeaflet({
                leaflet() %>% 
                        addTiles() %>%  # Add default OpenStreetMap map tiles
                        addAwesomeMarkers(
                                layerId = adMergedMap$adVillage,
                                lng=adMergedMap$lon, lat=adMergedMap$lat,
                                label=adMergedMap$label,
                                labelOptions = labelOptions(noHide = FALSE),
                                icon = icon.fa) %>% 
                        addMarkers(lat = 45.48444444444444, lng = 14.701944444444443) %>% 
                        setView(lng = 14.8018845, lat = 45.3995079, zoom = 11)
        })
        observe({
                data <- filteredData()
                showLabels <- input$map_zoom > 11
                if (input$circleMarkers) {
                        leafletProxy("map", data = data) %>%
                                #clearTiles() %>%
                                addTiles() %>%
                                clearMarkers() %>%
                                # addCircleMarkers(layerId = filteredData()$adVillage,
                                #                  color = ~pal(colorMeter()),
                                #                  stroke = TRUE,
                                #                  fillOpacity = 1,
                                #                  lng=filteredData()$lon, lat=filteredData()$lat,
                                #                  label=filteredData()$label,
                                #                  labelOptions = labelOptions(noHide = showLabels,
                                #                                              opacity = 1)
                                #                    )
                                addCircles(layerId = filteredData()$adVillage,
                                        lng = filteredData()$lon, lat = filteredData()$lat, weight = 2,
                                           radius = ~ (adQty + 5 ) * 80,  
                                        label=filteredData()$label,
                                                          labelOptions = labelOptions(noHide = showLabels,
                                                                                      opacity = 1)
                                ) 
                } else {
                leafletProxy("map", data = data) %>%
                                #clearTiles() %>%
                                clearShapes() %>%
                                addProviderTiles("OpenStreetMap") %>%
                        clearMarkers() %>%
                        addAwesomeMarkers(
                                layerId = filteredData()$adVillage,
                                lng=filteredData()$lon, lat=filteredData()$lat,
                                label=filteredData()$label,
                                labelOptions = labelOptions(noHide = showLabels,
                                                            opacity = 1),
                                icon = icon.fa)}})
        #output$table1 <- renderDataTable({
        #        filteredData()
        #})
        output$marker <- renderPrint({
                input$circleMarkers
        })
         output$villageSummary <- DT::renderDataTable(
                 tableData(),  rownames = FALSE, options = list(paging = FALSE,
                                                                               info = FALSE,
                                                                               searching = FALSE,
                                                                               ordering = FALSE,
                                                                               columnDefs=list(list(targets=1, class="dt-right"))
                 )
         )
         output$tbl = DT::renderDataTable(
                 iris, options = list(lengthChange = FALSE)
         )
         output$test <- renderPlot(height = 150, units="px", {
                 gg <- ggplot(adMergedFiltered, aes(x = adPriceEURM2))
                 gg <- gg + geom_histogram(binwidth = 5, color = "white", fill = "#5cb85c")
                 gg <- gg + theme_bw()
                 gg <- gg + theme(
                         panel.border = element_rect(fill = NA, colour = NA)
                 )
                 gg <- gg + ggtitle("Histogram cijene po kvadratu")
                 gg <- gg + ylab("") + xlab("")
                 gg
         })
         #### Ukupni postotak ###
         shinyjs::onclick("totRate", 
                          sliderUpdates(session)
         )
         #### Cijena po kvadratu ####
         shinyjs::onclick("priceLabel", 
                          updateSliderInput(session, "priceSlider",
                                            value = 10)
         )
         #### Stvarni povrat ####
         shinyjs::onclick("realReturnLabel", 
                          updateSliderInput(session, "realReturnSlider",
                                            value = 5)
         )         
         totalRate <- reactive({
                 input$hrBond + input$liq + input$fin + input$addition
         })
         output$totRate <- renderUI({
                 aux <- paste0(totalRate(), "", "%")
                 if (totalRate() > 15) {
                         labelColor <- "label label-warning"        
                 } else if (totalRate() < 8) {
                         labelColor <- "label label-danger"
                 } else {
                         labelColor <- "label label-primary"
                 }
                 
                 tags$div(
                 tags$p(tags$h2(tags$span(aux, title = "Tražena stopa(klik za početne vrijednosti)", class=labelColor), class = "text-center")),
                 tags$br(),
                 tags$br()        
                 )
         })
         #### Labela cijene ####
         output$priceLabel <- renderUI({
                 aux <- paste0(input$priceSlider, "", " €/m2")
                 labelColor <- "label label-primary"        
                 tags$div(
                         tags$p(tags$h2(tags$span(aux, title = "Kupovna cijena u EUR/m2(klik za početne vrijednosti)", class=labelColor), class = "text-center")),
                         tags$br(),
                         tags$br()        
                 )
         })
         #### Labela stvarnog povrata ####
         output$realReturnLabel <- renderUI({
                 aux <- paste0(input$realReturnSlider, "", "%")
                 labelColor <- "label label-primary"        
                 tags$div(
                         tags$p(tags$h2(tags$span(aux, title = "Stvarni povrat %(klik za početne vrijednosti)", class=labelColor), class = "text-center")),
                         tags$br(),
                         tags$br()        
                 )
         })
         returnsDf <- reactive({
                 df <- data.frame(godina = as.integer(1:10))
                 df$cijena <- input$priceSlider * (1 + totalRate() / 100)^df$godina
                 df <- rbind(c(godina = as.integer(0), cijena = input$priceSlider), df)
                 df <- arrange(df, godina)
                 df$vrsta <- "Željeni povrat"
                 df
         })
         
         realReturnsDf <- reactive({
                 df <- data.frame(godina = as.integer(1:10))
                 df$cijena <- input$priceSlider * (1 + input$realReturnSlider / 100)^df$godina
                 df <- rbind(c(godina = as.integer(0), cijena = input$priceSlider), df)
                 df <- arrange(df, godina)
                 df$vrsta <- "Stvarni povrat"
                 df
         })
         
         returnsAgreggatedDf <- reactive({
                 df <- rbind(returnsDf(), realReturnsDf())
                 df$vrsta <- as.factor(df$vrsta)
                 df$vrsta <- relevel(df$vrsta, ref = "Stvarni povrat")
                 df
         })
         #### Plot cijene kroz 10 godina ####
         output$pricePlot <- renderPlot({
                 gg <- ggplot() 
                 gg <- gg + geom_rect(aes(xmin = 0, 
                                          xmax = 10, 
                                          ymin = min(adMergedFiltered$adPriceEURM2), 
                                          ymax = max(adMergedFiltered$adPriceEURM2)), 
                                      alpha = 0.2, fill = "blue")
                 gg <- gg + geom_line(data = returnsAgreggatedDf(), aes(x = godina, y = cijena, color = vrsta), size = 1)
                 gg <- gg + geom_point(data = returnsAgreggatedDf(), aes(x = godina, y = cijena, color = vrsta), size = 3)
                 #gg <- gg + geom_line(data = realReturnsDf(), aes(x = godina, y = cijena), color = "red")
                 #gg <- gg + geom_point(data = realReturnsDf(), aes(x = godina, y = cijena), color = "red", size = 3)
                 gg <- gg + geom_label_repel(data = returnsDf(), aes(x = godina, y = cijena, label = round(cijena, 2)))
                 #gg <- gg + geom_point(color = "darkgreen", size = 3)
                 #gg <- gg + ylim(0, 100)
                 gg <- gg + theme_bw()
                 #gg <- gg + geom_hline(yintercept = min(adMergedFiltered$adPriceEURM2), color = "grey")
                 #gg <- gg + geom_hline(yintercept = max(adMergedFiltered$adPriceEURM2), color = "grey")
                 gg <- gg + annotate("label", x = 10, y = realReturnsDf()$cijena[11], label = round(realReturnsDf()$cijena[11]),2)
                 
                 gg <- gg + theme(
                         panel.border = element_rect(fill = NA, colour = NA),
                         legend.position = "bottom",
                         legend.title = element_blank(),
                         legend.key = element_rect(fill = NA, colour = NA)
                 )
                 gg <- gg + ggtitle("Graf cijena uz traženi povrat i odabranu kupovnu cijenu")
                 gg <- gg + scale_x_continuous(breaks = 0:10)
                 #gg <- gg + scale_y_continuous(breaks = seq(0,max(returnsAgreggatedDf()$cijena),(floor((returnsAgreggatedDf()$cijena / 10)))))
                 #gg <- gg + ylim(0, max())

                 print(gg)
         })
         #### Oglasi ####
         adsTable <- reactive({
                 df <- adMergedFiltered[ , c(1,2,4,6,7,10,12)]
                 df
         })
         output$ads <- DT::renderDataTable(
                 adsTable(),  rownames = FALSE, 
                 style = "bootstrap",
                 filter = "top",
                 options = list(paging = FALSE,
                                                                info = FALSE,
                                                                searching = TRUE,
                                                                ordering = TRUE,
                                                                columnDefs=list(list(targets=c(1,2,3,4), class="dt-right"))
                 )
         )
        
})

