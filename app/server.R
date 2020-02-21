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

load("../app/homeless.Rdata")

bronx <- plot_ly(
  type = 'scatterpolar',
  r = as.numeric(radar %>% dplyr::filter(Borough == "Bronx") %>% select(-"Borough")),
  theta = c('Home_base','Job_center','After_school', 'Condom', 'Primary_care', 'Food_stamp'),
  fill = 'toself'
) %>%
  layout(
    polar = list(
      radialaxis = list(
        visible = T,
        range = c(0,5)
      )
    ),
    showlegend = F
  )
bronx

blank <- plot_ly(
  type = 'scatterpolar',
  r = c(0, 0, 0, 0, 0, 0),
  theta = c('Home_base','Job_center','After_school', 'Condom', 'Primary_care', 'Food_stamp'),
  fill = 'toself'
) %>%
  layout(
    polar = list(
      radialaxis = list(
        visible = T,
        range = c(0,5)
      )
    ),
    showlegend = F
  )
blank
register_google(key = "AIzaSyAXxi_jjBKmoortYOFU1WeenatppEgJgdc")
marker_opt <- markerOptions(opacity = 0.7, riseOnHover = TRUE)
shinyServer(function(input, output,session){
  output$map <- renderLeaflet({
    m <- leaflet() %>%
      addTiles() %>%
      addProviderTiles("CartoDB.Positron", 
                       options = providerTileOptions(noWrap = TRUE)) %>%
      setView(-73.9252853,40.7910694,zoom = 12) %>%
      addResetMapButton()
    
    
    leafletProxy("map", data = condom_distribution) %>%
      addMarkers(~Longitude, ~Latitude,
                 group = "free_condom" ,
                 options = marker_opt, popup = ~ paste0("<b>",Name,"</b>" ,
                                                        "<br/>", "Borough: ", Address,
                                                        "<br/>", "Contact: ", Contact,
                                                        "<br/>", "Address: ", Address, 
                                                        " ",Zip.Code),  
                 label = ~ Name,
                 icon = list(iconUrl = 'https://cdn0.iconfinder.com/data/icons/objects-icons/110/Condom-512.png'
                             ,iconSize = c(25,25)))
    
    leafletProxy("map", data = Homebase_Centers) %>%
      addMarkers(~Longitude, ~Latitude,
                 group = "drop_in" ,
                 options = marker_opt,  popup = ~ paste0("<b>",Name,"</b>" ,
                                                         "<br/>", "Borough: ", Address,
                                                         "<br/>", "Contact: ", Contact,
                                                         "<br/>", "Address: ", Address, 
                                                         " ",Zip.Code) , 
                 label = ~ Name,
                 icon = list(iconUrl = 'https://cdn1.iconfinder.com/data/icons/unigrid-finance-vol-3/60/014_house_home_insurance_keep_safe_hands_secure_protection-512.png'
                             ,iconSize = c(25,25)))
    
    leafletProxy("map", data = Job_Centers) %>%
      addMarkers(~Longitude, ~Latitude,
                 group = "job_center" ,
                 options = marker_opt, popup = ~ paste0("<b>",Name,"</b>" ,
                                                        "<br/>", "Borough: ", Address,
                                                        "<br/>", "Contact: ", Contact,
                                                        "<br/>", "Address: ", Address, 
                                                        " ",Zip.Code), 
                 label = ~ Name,
                 icon = list(iconUrl = 'https://cdn1.iconfinder.com/data/icons/job-3/512/9-512.png'
                             ,iconSize = c(25,25)))
    
    leafletProxy("map", data = Food_Stamp_Centers) %>%
      addMarkers(~Longitude, ~Latitude,
                 group = "food_stamp" ,
                 options = marker_opt, popup = ~ paste0("<b>",Name,"</b>" ,
                                                        "<br/>", "Borough: ", Address,
                                                        "<br/>", "Contact: ", Contact,
                                                        "<br/>", "Address: ", Address, 
                                                        " ",Zip.Code), 
                 label = ~ Name,
                 icon = list(iconUrl = 'https://cdn1.iconfinder.com/data/icons/foody-icons/32/FoodyIcons_color_02-06-512.png'
                             ,iconSize = c(25,25)))
    
    leafletProxy("map", data = after_school_programs) %>%
      addMarkers(~Longitude, ~Latitude,
                 group = "after_school" ,
                 options = marker_opt, popup = ~ paste0("<b>",Name,"</b>" ,
                                                        "<br/>", "Borough: ", Address,
                                                        "<br/>", "Contact: ", Contact,
                                                        "<br/>", "Address: ", Address, 
                                                        " ",Zip.Code), 
                 label = ~ Name,
                 icon = list(iconUrl = 'https://cdn1.iconfinder.com/data/icons/medical-kit-2-flat-style/128/Medical_Kit_2_-_Flat_Style_-_18_-_1-39-512.png'
                             ,iconSize = c(25,25)))
    
    leafletProxy("map", data = Health_Insurance) %>%
      addMarkers(~Longitude, ~Latitude,
                 group = "Health_Insurance" ,
                 options = marker_opt, popup = ~ paste0("<b>",Name,"</b>" ,
                                                        "<br/>", "Borough: ", Address,
                                                        "<br/>", "Contact: ", Contact,
                                                        "<br/>", "Address: ", Address, 
                                                        " ",Zip.Code), 
                 label = ~ Name,
                 icon = list(iconUrl = 'https://cdn2.iconfinder.com/data/icons/design-flat-business/80/Creatif_Worker-512.png'
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
    if("Food Stamp Center" %in% input$enable_markers) leafletProxy("map") %>% showGroup("food_stamp")
    else{leafletProxy("map") %>% hideGroup("food_stamp")}
    if("After School Program" %in% input$enable_markers) leafletProxy("map") %>% showGroup("after_school")
    else{leafletProxy("map") %>% hideGroup("after_school")}
    if("Health_Insurance" %in% input$enable_markers) leafletProxy("map") %>% showGroup("Health_Insurance")
    else{leafletProxy("map") %>% hideGroup("Health_Insurance")}
  }, ignoreNULL = FALSE)
  
  
observe({
  event <- input$boro1
  if (is.null(event))
    return()
  output$boroplot <- renderPlotly({
    #returns null if no borough selected
    
    bronx
  })
})
  
})





