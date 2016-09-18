library(shiny)
library(shinyjs)
library(leaflet)
library(DT)
shinyUI(tagList(
        tags$head(
                HTML("<link rel='stylesheet' type='text/css' href='css/ion.rangeSlider.skinModern.css'>"),
                HTML("<link rel='stylesheet' type='text/css' href='css/bootstrap-switch.min.css'>"),
                HTML("<link rel='stylesheet' type='text/css' href='css/correct.css'>"),
                HTML("<link rel='stylesheet' type='text/css' href='css/introjs.min.css'>"),
                ### Ovaj poziv ispod vjerojatno ne treba jer shiny to linka sam
                #HTML("<script type='text/javascript' src='/js/ion.rangeSlider.min.js'></script>"),
                HTML("<script type='text/javascript' src='js/sliderInit.js'></script>"),
                HTML("<script type='text/javascript' src='js/bootstrap-switch.min.js'></script>"),
                HTML("<script type='text/javascript' src='js/init.js'></script>")

                
        ),
        tags$script('
                document.getElementById("totRate").onclick = function() {
                var number = 1;
                Shiny.onInputChange("totRateClicked", number);
                };
                '),
        
        useShinyjs(),
        navbarPage("Gorski Kotar - Zemljišta",
                   tabPanel("Uvod", 
                            fluidRow(
                                    column(width = 4, 
                                           HTML("<h4 data-step='1', data-intro='This is a step 1!'>Motivacija</h4>"),
                                           #tags$h4("Motivacija"),
                                           tags$p("Pokušavam složiti porfolio investicija. Zapravo sam ciljao na obveznice, 
                                                  ali hrvatske ne bi kupovao, a kupovati strane obveznice iz Hrvatske je previše skupo, 
                                                  a pitanje je i da li bih zadovoljio minimalne tražene iznose"),
                                           HTML("<a class='btn btn-large btn-success' href='javascript:introJs().setOption(&#34;showProgress&#34;, true).start();'>Show me how</a>")
                                           ),
                                    column(width = 4, 
                                           HTML("<h4 data-step='2', data-intro='This is a step 2!'>Zašto Gorski kotar</h4>"),
                                           #tags$h4("Zašto Gorski kotar"),
                                           tags$p("Već sam tri godine za redom bio tamo na godišnjem i primjećuje se porast broja gostiju. 
                                                  Čini mi se da se mogu svrstati u dvije kategorije. Stranci koji su si složili itinerer kroz 
                                                  Hrvatsku pa im je i Gorski kotar jedna od lokacija. Druga kategorija u koju ja spadam je bijeg 
                                                  od gužve i niže temperature po ljeti. Moguće je da i postoji i više kategorija, npr zimski turizam.
                                                  Obzirom na sve veću gužvu na Jadranu i traženja novih ponuda meni se čini da će Gorski kotar rasti, 
                                                  pa time i cijene zemljišta")
                                           ),
                                    column(width = 4, 
                                           HTML("<h4 data-hint='This is a tooltip!' data-hintPosition='top-middle' data-position='bottom-right-aligned'>Rizici</h4>"),
                                           #tags$h4("Rizici"), 
                                           tags$ul(tags$li("Teško prodati"), 
                                                   tags$li("Fulana lokacija"), 
                                                   tags$li("Promjena urbanističkog plana") 
                                                   ),
                                           HTML("<a id='startButton' class='btn btn-large btn-success' href='javascript:introJs().addHints();'>Hints!</a>")
                                           )
                            )
                            ),     
                   tabPanel("Karta oglasa",
                            fluidRow(class = "firstRow",
                                    column(width = 9, 
                                           leafletOutput("map", height = "750px")
                                           #dataTableOutput("table1")
                            ),
                            column(width = 3, tags$div(class = "well",
                                                       #checkboxInput("check", label = "", value = F),
                                                       tags$div(title="Koristi krugove za prikaz na mapi",
                                                       checkboxInput("circleMarkers", label="", value=FALSE)),
                                                       tags$div(title="Filter cijene u EUR po m2",
                                                       sliderInput("priceEURM2", "" , min(0), max(50),
                                                                   value = c(10,50), step = 1)),
                                                       #tags$div(
                                                #               HTML('<input class="js-range-slider" id="priceEURM2" data-type="double" data-min="0" data-max="50" data-from="10" data-from-min="10" data-to="50"
                                                #                    data-step="1" data-grid="true" data-grid-num="10" data-grid-snap="false" data-prettify-separator="," data-keyboard 
                                                #                    ="true" data-keyboard-step="1" data-drag-interval="true" data-data-type="number" data-postfix=" EUR/m2" data-decorate-both="false" />')
                                                #       ),
                                                        tags$div(title="Filter površine u m2",
                                                       sliderInput("area", "Area in m2", min(0), max(10000),
                                                                   value = c(350,10000), step = 500)),

                                                       #selectInput("markerColor", "Odabir značenja boje", 
                                                        #           choices = c("Broj oglasa", "Min. cijena", "Max. cijena", "Srednja cijena"),
                                                         #          selected = "Broj oglasa"),
                                                       # tags$input(class="js-range-slider", id="slider2", data-type="double",
                                                       #            data-min="0", data-max="100", data-from="0", data-to="100",
                                                       #            data-step="1", data-grid="true", data-grid-num="10",
                                                       #            data-grid-snap="false", data-prettify-separator=",", data-keyboard="true",
                                                       #            data-keyboard-step="1", data-drag-interval="true", data-data-type="number"),
                                                       #tags$div(
                                                #               HTML('<input class="js-range-slider" id="slider2" data-type="double" data-min="0" data-max="100" data-from="20" data-from-min="25" data-to="80"                                                            data-step="1" data-grid="true" data-grid-num="10" data-grid-snap="false" data-prettify-separator="," data-keyboard                                                         ="true" data-keyboard-step="1" data-drag-interval="true" data-data-type="number" />')
                                                 #      ),
                                                       #actionButton("applySelection", "Postavi", class="btn btn-success"),
                                                       tags$hr(),
                                                       tags$div(class="sidebar-divider", 
                                                                plotOutput("test", height="auto"))
                                                       
                                                       
                            ),
                            tags$div(
                                    #textOutput("marker"),
                                    #dataTableOutput("villageSummary")
                                    
                            )

                            )
                            )
                   ),
                   tabPanel("Povrati",
                            fluidRow(column(width = 6, 
                                            plotOutput("pricePlot", height = 600)
                                            ), 
                                     column(width = 3, 
                                            tags$div(class = "well",
                                                     uiOutput("totRate"),
                                                     tags$div(title="Kamata na hrvatske obveznice",
                                                              sliderInput("hrBond", "Kamata na hrvatske obveznice" , min(0), max(10),
                                                                          value = 5, step = 0.1)),
                                                     tags$div(title="Premija za nelikvidnost",
                                                              sliderInput("liq", "Premija za nelikvidnost" , min(0), max(10),
                                                                          value = 2, step = 0.1)),
                                                     tags$div(title="Kamata na financiranje",
                                                              sliderInput("fin", "Kamata na financiranje" , min(0), max(10),
                                                                          value = 5, step = 0.1)),
                                                     tags$div(title="Zahtjevani dodatak",
                                                              sliderInput("addition", "Zahtjevani dodatak" , min(0), max(10),
                                                                          value = 5, step = 0.1))
                                                     
                                                     )
                                            ),
                                     column(width = 3,
                                            tags$div(class = "well",
                                                     uiOutput("priceLabel"),
                                                     tags$div(title="Kupovna cijena u EUR/m2",
                                                              sliderInput("priceSlider", "Kupovna cijena u EUR/m2" , min(0), max(100),
                                                                          value = 10, step = 1)),
                                                     tags$hr(),
                                                     uiOutput("realReturnLabel"),
                                                     tags$div(title="Stvarni povrat",
                                                              sliderInput("realReturnSlider", "Stvarni povrat" , min(0), max(20),
                                                                          value = 5, step = 1))
                                                     )



                                            )
                                     ),
                            fluidRow(
                                    column(width = 4, 
                                           #tags$h4("Logika odabira kupovne cijene"),
                                           HTML("<h4 data-step='3', data-intro='This is a step 3!'>Logika odabira kupovne cijene</h4>"),
                                           tags$p("Uz traženi povrat koji se namješta na klizačima vijdeti koja bi bila maksimalna kupovna cijena
                                                  da nakon deset godina cijena bude i dalje ispod najviše trenuto tražene cijene. Plavi pravkutnik 
                                                  označava limite najviše i najniže trenutno tražene cijene")
                                    ),
                                    column(width = 4,  
                                           tags$h4("Stvarni povrat"),
                                           tags$p("Stvarni povrat služi za dobiti osjećaj šta bi značila fulada. Tj. ako odaberemo kupovnu cijenu 
                                                  i stvarni povrat, krivulja pokazuje gdje ćemo završiti sa cijenom za 10 godina")
                                    ),
                                    column(width = 4,
                                           tags$h4("Grubi orijentir traženog povrata"),
                                           tags$p("Jedan od mogućih načina je definirati nerezičnu stopu, to bi bila američki treasury bond čija je stopa trenutno 
                                                  1.67%. Na to se dodaje Country risk and premium, što za Hrvatsku trenutno iznosi 9.72% Iz toga proizlazi da ne bi 
                                                  trebalo pristati na povrat manji od 1.67 + 9.72 = 11.39%")
                                           )
                            )
                            
                   ),
                   tabPanel("Oglasi", 
                            fluidRow(
                                    column(width = 12,
                                    dataTableOutput("ads")
                                    )
                            )
                   )
),
HTML("<script type='text/javascript' src='js/intro.min.js'></script>"),
HTML("<script type='text/javascript'>document.getElementById('startButton').onclick = function() {
        introJs().setOption('doneLabel', 'Next page').start().oncomplete(function() {
          window.location.href = '#tab-4798-3?multipage=true';
        });
      };</script>")   
))