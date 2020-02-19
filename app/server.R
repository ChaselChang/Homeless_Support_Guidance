#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(data.table)
library(plotly)
library(shinyWidgets)
library(googleVis)
library(geosphere)
library(leaflet.extras)
library(ggmap)
library(tidyverse)

# MAP

# JW
free_condom <- read_csv('C:\\Users\\Dr.FlyOnBeD\\Dropbox\\CU_LIFE\\Applied_Data_Science\\Spring2020-Project2-group-5\\data\\homeless\\NYC_Condom_Availability_Program_-_HIV_condom_distribution_locations.csv')
drop_in <- read_csv('C:\\Users\\Dr.FlyOnBeD\\Dropbox\\CU_LIFE\\Applied_Data_Science\\Spring2020-Project2-group-5\\data\\homeless\\Directory_Of_Homeless_Drop-_In_Centers.csv')
job_center <- read_csv('C:\\Users\\Dr.FlyOnBeD\\Dropbox\\CU_LIFE\\Applied_Data_Science\\Spring2020-Project2-group-5\\data\\homeless\\Directory_Of_Job_Centers.csv')

register_google(key = "AIzaSyAXxi_jjBKmoortYOFU1WeenatppEgJgdc")
marker_opt <- markerOptions(opacity = 0.7, riseOnHover = TRUE)
shinyServer(function(input, output,session){
  output$map <- renderLeaflet({
    m <- leaflet() %>%
      addProviderTiles("CartoDB.Positron", 
                       options = providerTileOptions(noWrap = TRUE)) %>%
      setView(-73.9252853,40.7910694,zoom = 13) %>%
      addResetMapButton()
    
    
    leafletProxy("map", data = free_condom) %>%
      addMarkers(~Longitude, ~Latitude,
                 group = "free_condom" ,
                 options = marker_opt,  
                 icon = list(iconUrl = 'https://cdn2.vectorstock.com/i/1000x1000/47/76/kids-icon-happy-boy-and-girl-children-silhouettes-vector-9674776.jpg'
                             ,iconSize = c(25,25)))
    
    leafletProxy("map", data = drop_in) %>%
      addMarkers(~Longitude, ~Latitude,
                 group = "drop_in" ,
                 options = marker_opt,  
                 icon = list(iconUrl = 'https://cdn3.iconfinder.com/data/icons/school-pack-3-1/512/5-512.png'
                             ,iconSize = c(25,25)))
    
    leafletProxy("map", data = job_center) %>%
      addMarkers(~Longitude, ~Latitude,
                 group = "job_center" ,
                 options = marker_opt,  
                 icon = list(iconUrl = 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Closed_Book_Icon.svg/512px-Closed_Book_Icon.svg.png'
                             ,iconSize = c(25,25)))
    m
  
  
})

  observeEvent(input$enable_markers, {
    if("Free Condom" %in% input$enable_markers) leafletProxy("map") %>% showGroup("free_condom")
    else{leafletProxy("map") %>% hideGroup("free_condom")}
    if("Drop-In Center" %in% input$enable_markers) leafletProxy("map") %>% showGroup("drop_in")
    else{leafletProxy("map") %>% hideGroup("drop_in")}
    if("Job Center" %in% input$enable_markers) leafletProxy("map") %>% showGroup("job_center")
    else{leafletProxy("map") %>% hideGroup("job_center")}
  }, ignoreNULL = FALSE)
  
})





