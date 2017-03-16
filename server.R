#Requiring libraries
library(sp)
library(shiny)
library(leaflet)
library(data.table)
library(dplyr)

#Reading in the data
mydf<-read.csv("data/Dane_mapy.csv", 
           header = FALSE, sep = ";")


#Giving names to the data frame
names(mydf)<-c("name", "lat", "lng", "type")

#Calculating the distance from Main Square in kms
lng_lat<-cbind(mydf$lng, mydf$lat)
center<-cbind(mydf[which(mydf$name=="Main Square"), "lng"],  
              mydf[which(mydf$name=="Main Square"), "lat"])
mydf$km<-spDistsN1(lng_lat, center, longlat = TRUE)

#Choosing colors for the map
mydf$col<-NA
choosingcolors<-c("blue", "violet","cyan", "darkorange", "green", "red", 
                "yellow", "black")
for (i in 1:length(levels(mydf$type))) {
       mydf[which(mydf$type==levels(mydf$type)[i]), "col"]<-choosingcolors[i]
}

mydf$type<-as.character(mydf$type)
mydf$col<-as.character(mydf$col)

shinyServer(
        function(input, output, session) {

        mydf1<-reactive({
                input$Button
                isolate({
                        mydf<-mydf                          
                        mydf%>% filter(type %in% input$type,
                                     km<=input$km)
                        })
                })
          
         

        choosenspots<-reactive({unique(mydf1()$type)})
        #isolate({choosenspots})
    
        
        output$check<-renderText({choosenspots()})
        
        
       a<-renderTable({as.data.frame(tapply(mydf1()$type, mydf1()$type, length))})
        
           
        output$total<-renderText({paste("There are all together", nrow(mydf1()), "objects of your interest within", 
                                  (input$km), "km from the Main Square, including:")
                             })
      
 output$churches<-renderText({
         if ("Churches" %in% input$type) 
                 paste("-", length(mydf1()$type[which(mydf1()$type=="Churches")]), "churches")
 })
      
 output$fortifications<-renderText({
         if ("Fortifications" %in% input$type) 
                 paste("-", length(mydf1()$type[which(mydf1()$type=="Fortifications")]), "fortifications")
 })
 
 output$juish<-renderText({
         if ("Juish Culture" %in% input$type) 
                 paste("-", length(mydf1()$type[which(mydf1()$type=="Juish Culture")]), "Juish Culture objects")
 })
 
 
 output$museums<-renderText({
         if ("Museums" %in% input$type) 
                 paste("-", length(mydf1()$type[which(mydf1()$type=="Museums")]), "museums")
 }) 
 
 
 output$old<-renderText({
         if ("Old Buildings" %in% input$type) 
                 paste("-", length(mydf1()$type[which(mydf1()$type=="Old Buildings")]), "old buildings")
 })  
 
 output$parks<-renderText({
         if ("Parks and Nature" %in% input$type) 
                 paste("-", length(mydf1()$type[which(mydf1()$type=="Parks and Nature")]), "parks or intersting nature spots")
 })
 
 output$streets<-renderText({
         if ("Streets and Squares" %in% input$type) 
                 paste("-", length(mydf1()$type[which(mydf1()$type=="Streets and Squares")]), "streets and squares")
 })
 
 output$other<-renderText({
         if ("Other" %in% input$type) 
                 paste("-", length(mydf1()$type[which(mydf1()$type=="Other")]), "other objects")
 })
 
 
        
 
#Drawing a map
               
        
        
              output$map<-renderLeaflet({
                mydf1() %>% leaflet() %>%
                addTiles() %>%
                addMarkers(lat=mydf1()$lat, lng=mydf1()$lng, popup=mydf1()$name, 
                clusterOptions=markerClusterOptions()) %>%
                addCircleMarkers(color=mydf1()$col) %>%
                addLegend(labels=unique(mydf1()$type),
                        colors=unique(mydf1()$col),
                      title="Legend", position="topleft")
                })
})