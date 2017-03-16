mydf<-read.csv("data/Dane_mapy.csv", 
               header = FALSE, sep = ";")

require(shiny)
require(leaflet)

shinyUI(pageWithSidebar(
        headerPanel("Cracow is the town you definitely should see :)"),
        sidebarPanel(
          h6("Use the slider below to indicate the range of your sightseeing tour"),
          sliderInput("km", "How far from the Main Square would you like to go?", 
                value=2, min = 0, max=70, step = 0.5),
          h6("Check the boxes below to choose the objects you would like to visit"),
          checkboxGroupInput("type", "What would you like to see?",
                             choices=c("Churches"="Churches", 
                               "Fortifications"="Fortifications",
                               "Juish Culture"="Juish Culture",
                               "Museums"="Museums",
                               "Old Buildings"="Old Buildings",
                               "Parks and Nature"="Parks and Nature",
                               "Streets and Squares"="Streets and Squares",
                               "Other"="Other"), selected = c("Churches","Fortifications","Juish Culture",
                                                              "Museums","Old Buildings", "Other",
                                                              "Parks and Nature", "Streets and Squares")),
          h6("Click update button below to confirm your slection"),
          actionButton("Button", "Update")
          ),
           mainPanel(
                h4("There are lots of interesting sightseeing spots in Cracow. 
                This application will help you to find the most famous ones. 
                But remember – there are much more to see than that!"),
                tableOutput("a"),
                h5(textOutput("total"),
                textOutput("churches"),textOutput("fortifications"),
                textOutput("museums"),
                textOutput("juish"),
                textOutput("old"),
                textOutput("parks"),
                textOutput("streets"),
                textOutput("other")),
                h5("Use interactive map below to see their location."),
                leafletOutput("map")
)))