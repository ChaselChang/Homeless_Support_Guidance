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

#remotes::install_github("mfherman/nycgeo")
library(nycgeo)
library(sf)
library(shinythemes)
library(lubridate)
library(scales)
library(tigris)

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
  #############tab Heatmap ###############

  nhyc_cd_data <- cd_sf
  
  Population <- Population%>% 
    mutate(borough_cd_id = as.character(borough_cd_id), borough_id = as.character(borough_id))
  
  map_data <- geo_join(nhyc_cd_data, Population, "borough_cd_id",  "borough_cd_id", how = "inner")
  
  output$map2 <- renderLeaflet({
    
    if(input$selectb == "1970s"){
      bins <- c(0, 40000,80000, 120000, 140000, 180000,220000)
      pal <- colorBin("Reds", domain = map_data$X1970.Population, bins = bins)
      popup1 = paste0('<strong>Count: </strong><br>', map_data$X1970.Population,
                      '<br><strong>Name: </strong><br>', map_data$cd_name)
      
      map_data %>%
        st_transform(., "+init=epsg:4326") %>%
        leaflet() %>%
        addTiles() %>%
        addPolygons(popup = popup1,
                    layerId=~borough_cd_id,
                    #label = ~ttl_count,
                    fillColor = ~pal(X1970.Population),
                    color = 'grey', 
                    fillOpacity = .6,
                    weight = 1,
                    dashArray = "3") %>% 
        addProviderTiles("CartoDB.Positron") %>% 
        addLegend(pal = pal, values = ~bins, opacity = 0.6, title = "Number of Population",
                  position = "bottomright")
    } else if(input$selectb == "1980s"){
      bins2 <- c(0, 40000,80000, 120000, 140000, 180000,220000)
      pal2 <- colorBin("Reds", domain = map_data$X1980.Population, bins = bins2)
      popup2 = paste0('<strong>Count: </strong><br>', map_data$X1980.Population,
                      '<br><strong>Name: </strong><br>', map_data$cd_name)
      map_data %>%
        st_transform(., "+init=epsg:4326") %>%
        leaflet() %>%
        addTiles() %>%
        addPolygons(popup = popup2,
                    layerId=~borough_cd_id,
                    #label = ~ttl_count,
                    fillColor = ~pal2(X1980.Population),
                    color = 'grey', 
                    fillOpacity = .6,
                    weight = 1,
                    dashArray = "3") %>% 
        addProviderTiles("CartoDB.Positron") %>% 
        addLegend(pal = pal2, values = ~bins2, opacity = 0.6, title = "Number of Population",
                  position = "bottomright")
    } else if(input$selectb == "1990s"){
      bins2 <- c(0, 40000,80000, 120000, 140000, 180000,220000)
      pal2 <- colorBin("Reds", domain = map_data$X1990.Population, bins = bins2)
      popup2 = paste0('<strong>Count: </strong><br>', map_data$X1990.Population,
                      '<br><strong>Name: </strong><br>', map_data$cd_name)
      map_data %>%
        st_transform(., "+init=epsg:4326") %>%
        leaflet() %>%
        addTiles() %>%
        addPolygons(popup = popup2,
                    layerId=~borough_cd_id,
                    #label = ~ttl_count,
                    fillColor = ~pal2(X1990.Population),
                    color = 'grey', 
                    fillOpacity = .6,
                    weight = 1,
                    dashArray = "3") %>% 
        addProviderTiles("CartoDB.Positron") %>% 
        addLegend(pal = pal2, values = ~bins2, opacity = 0.6, title = "Number of Population",
                  position = "bottomright")
    } else if(input$selectb == "2000s"){
      bins2 <- c(0, 40000,80000, 120000, 140000, 180000,220000)
      pal2 <- colorBin("Reds", domain = map_data$X2000.Population, bins = bins2)
      popup2 = paste0('<strong>Count: </strong><br>', map_data$X2000.Population,
                      '<br><strong>Name: </strong><br>', map_data$cd_name)
      map_data %>%
        st_transform(., "+init=epsg:4326") %>%
        leaflet() %>%
        addTiles() %>%
        addPolygons(popup = popup2,
                    layerId=~borough_cd_id,
                    #label = ~ttl_count,
                    fillColor = ~pal2(X2000.Population),
                    color = 'grey', 
                    fillOpacity = .6,
                    weight = 1,
                    dashArray = "3") %>% 
        addProviderTiles("CartoDB.Positron") %>% 
        addLegend(pal = pal2, values = ~bins2, opacity = 0.6, title = "Number of Population",
                  position = "bottomright")
    } else if(input$selectb == "2010s"){
      bins2 <- c(0, 40000,80000, 120000, 140000, 180000,220000)
      pal2 <- colorBin("Reds", domain = map_data$X2010.Population, bins = bins2)
      popup2 = paste0('<strong>Count: </strong><br>', map_data$X2010.Population,
                      '<br><strong>Name: </strong><br>', map_data$cd_name)
      map_data %>%
        st_transform(., "+init=epsg:4326") %>%
        leaflet() %>%
        addTiles() %>%
        addPolygons(popup = popup2,
                    layerId=~borough_cd_id,
                    #label = ~ttl_count,
                    fillColor = ~pal2(X2010.Population),
                    color = 'grey', 
                    fillOpacity = .6,
                    weight = 1,
                    dashArray = "3") %>% 
        addProviderTiles("CartoDB.Positron") %>% 
        addLegend(pal = pal2, values = ~bins2, opacity = 0.6, title = "Number of Population",
                  position = "bottomright")
    }
  })
  
  observe({
    #whenever map item is clicked, becomes event
    event <- input$map2_shape_click
    if (is.null(event))
      return()
    
    output$month_trend <- renderPlot({
      #returns null if no borough selected
      if (is.na(event$id)) {
        return(NULL)
      }
      
      gra_df %>% mutate(shown_date = format.Date(as.Date(created_date, format = "%m/%d/%Y"), "%b %y"),
                        sort_date = format(as.Date(created_date, format = "%m/%d/%Y"), "%Y%m")) %>%
        mutate(cd_id = as.character(as.numeric(str_extract(city_council_district, "[[:digit:]]+")))) %>%
        filter(borough_cd_id == event$id) %>%
        group_by(shown_date, sort_date) %>%
        dplyr::summarize(ttl = n()) %>%
        ungroup() %>%
        arrange(sort_date) %>%
        mutate(shown_date = factor(shown_date, levels = shown_date)) %>%
        ggplot(aes(x=shown_date, y = ttl)) +
        geom_bar(stat="identity", na.rm = TRUE, color="lightblue", fill = "lightblue") +
        theme_bw() +
        theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
        labs(x = "Month", y = "Number of complaints", title = "Number of complaints monthly trend")
    })
  })
  ##################
  
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
                 icon = list(iconUrl = 'https://cdn2.iconfinder.com/data/icons/design-flat-business/80/Creatif_Worker-512.png'
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
                 icon = list(iconUrl = 'https://cdn1.iconfinder.com/data/icons/medical-kit-2-flat-style/128/Medical_Kit_2_-_Flat_Style_-_18_-_1-39-512.png'
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
    if("Health Insurance" %in% input$enable_markers) leafletProxy("map") %>% showGroup("Health_Insurance")
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





