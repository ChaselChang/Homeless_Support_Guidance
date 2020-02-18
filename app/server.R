#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#library(shiny)
#install.packages('rsconnect')

#rsconnect::setAccountInfo(name='columbia-stats-slwkq',
                         # token='804922F53FD914A6C8FB1F3F564EFFD1',
                        #  secret='I1Ar5KuxJBynF0ETNpB/k+cmvDAiie9fMLOCrpMY')

#library(rsconnect)
#rsconnect::deployApp('../Spring2020-Project2-group-5/app/')

library(shiny)
library(leaflet)
library(data.table)
library(plotly)
library(shinyWidgets)
library(googleVis)
library(geosphere)
library(leaflet.extras)
library(ggmap)

source("global.R")

#Get the Google API
register_google(key = "AIzaSyAXxi_jjBKmoortYOFU1WeenatppEgJgdc")
shinyServer(function(input, output,session)
{
  output$map <- renderLeaflet({
    m <- leaflet() %>%
      addProviderTiles("CartoDB.Positron", 
                       options = providerTileOptions(noWrap = TRUE)) %>%
      setView(-73.9252853,40.7910694,zoom = 13) %>%
      addResetMapButton()
    
    #plot kids activities
    leafletProxy("map", data = kid_activity) %>%
      addMarkers(~Longitude, ~Latitude,
                 group = "kid_activity" ,
                 options = marker_opt, popup = ~ paste0("<b>",SITE.NAME,"</b>",
                                                        "<br/>", "Danger Index: ", Danger_Index,
                                                        "<br/>", "Phone: ", Contact.Number,
                                                        "<br/>", "Address: ", Location.1, 
                                                        " ",Postcode) ,
                 label = ~ SITE.NAME ,
                 icon = list(iconUrl = 'https://cdn2.vectorstock.com/i/1000x1000/47/76/kids-icon-happy-boy-and-girl-children-silhouettes-vector-9674776.jpg'
                             ,iconSize = c(25,25)))
    leafletProxy("map", data = middle_activity) %>%
      addMarkers(~Longitude, ~Latitude ,
                 group = "middle_activity"
                 , options = marker_opt, popup = ~ paste0("<b>",SITE.NAME,"</b>",
                                                          "<br/>", "Danger Index: ", Danger_Index,
                                                          "<br/>", "Phone: ", Contact.Number,
                                                          "<br/>", "Address: ", Location.1, 
                                                          " ",Postcode) ,  
                 label = ~ SITE.NAME ,
                 icon = list(iconUrl = 'https://cdn3.iconfinder.com/data/icons/school-pack-3-1/512/5-512.png'
                             ,iconSize = c(25,25)))
    leafletProxy("map", data = high_activity) %>%
      addMarkers(~Longitude, ~Latitude,
                 group = "high_activity"
                 , options = marker_opt, popup = ~ paste0("<b>",SITE.NAME,"</b>",
                                                          "<br/>", "Danger Index: ", Danger_Index,
                                                          "<br/>", "Phone: ", Contact.Number,
                                                          "<br/>", "Address: ", Location.1, 
                                                          " ",Postcode) ,  
                 label = ~ SITE.NAME,
                 icon = list(iconUrl = 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Closed_Book_Icon.svg/512px-Closed_Book_Icon.svg.png'
                             ,iconSize = c(25,25)))
    m
  }
  )
})
# MAP

# JW



# KW









# REPORT

# JB



# HL



# TZ
