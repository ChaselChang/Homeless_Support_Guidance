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

source('global.R')
register_google(key = "AIzaSyAXxi_jjBKmoortYOFU1WeenatppEgJgdc")
marker_opt <- markerOptions(opacity = 0.7, riseOnHover = TRUE)


#plots
library(ggthemes)
library(tidyr)
#Dashboard Demo
library(dplyr)
final<-read.csv('Final.csv')
final$Date<-as.Date(final$Date,"%Y-%m-%d")
todayfacility<-read.csv('borofilicity12-31.csv')
facilitystyle<-read.csv('ficlitybyboropir.csv')

MergedDF<-read.csv('boroughdemo.csv')
#Dashboard Demo
shinyServer(function(input, output,session){
  output$map <- renderLeaflet({
    m <- leaflet() %>%
      addTiles() %>%
      #addProviderTiles("CartoDB.Positron", 
      #options = providerTileOptions(noWrap = TRUE)) %>%
      setView(-73.9252853,40.7910694,zoom = 12) %>%
      addResetMapButton()
    
    
    leafletProxy("map", data = condom_distribution) %>%
      addMarkers(~Longitude, ~Latitude,
                 group = "free_condom" ,
                 options = marker_opt, popup = ~ paste0("<b>",Name,"</b>" ,
                                                        "<br/>", "Borough: ", Borough,
                                                        "<br/>", "Contact: ", Contact,
                                                        "<br/>", "Address: ", Address, 
                                                        " ",Zip.Code),  
                 label = ~ Name,
                 icon = list(iconUrl = 'https://cdn0.iconfinder.com/data/icons/pharmacy/24/condom-wrapper-512.png'
                             ,iconSize = c(25,25)))
    
    leafletProxy("map", data = Homebase_Centers) %>%
      addMarkers(~Longitude, ~Latitude,
                 group = "drop_in" ,
                 options = marker_opt,  popup = ~ paste0("<b>",Name,"</b>" ,
                                                         "<br/>", "Borough: ", Borough,
                                                         "<br/>", "Contact: ", Contact,
                                                         "<br/>", "Address: ", Address, 
                                                         " ",Zip.Code) , 
                 label = ~ Name,
                 icon = list(iconUrl = 'https://cdn4.iconfinder.com/data/icons/pictype-free-vector-icons/16/home-512.png'
                             ,iconSize = c(25,25)))
    
    leafletProxy("map", data = Job_Centers) %>%
      addMarkers(~Longitude, ~Latitude,
                 group = "job_center" ,
                 options = marker_opt, popup = ~ paste0("<b>",Name,"</b>" ,
                                                        "<br/>", "Borough: ", Borough,
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
                                                        "<br/>", "Borough: ", Borough,
                                                        "<br/>", "Contact: ", Contact,
                                                        "<br/>", "Address: ", Address, 
                                                        " ",Zip.Code), 
                 label = ~ Name,
                 icon = list(iconUrl = 'https://cdn3.iconfinder.com/data/icons/passport-stamp-3/92/221-512.png'
                             ,iconSize = c(25,25)))
    
    leafletProxy("map", data = after_school_programs) %>%
      addMarkers(~Longitude, ~Latitude,
                 group = "after_school" ,
                 options = marker_opt, popup = ~ paste0("<b>",Name,"</b>" ,
                                                        "<br/>", "Borough: ", Borough,
                                                        "<br/>", "Contact: ", Contact,
                                                        "<br/>", "Address: ", Address, 
                                                        " ",Zip.Code), 
                 label = ~ Name,
                 icon = list(iconUrl = 'https://cdn3.iconfinder.com/data/icons/education/512/students-512.png'
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
  }, ignoreNULL = FALSE)
  
  
  observe({
    event <- input$boro1
    if (event == "")
    {
      output$boroplot <- renderPlotly({
        blank
      })
    }
    else
    {
      output$boroplot <- renderPlotly({
        if (input$boro1 == 'BRONX') 
        {
          bronx
        }
        else if (input$boro1 == 'BROOKLYN') 
        {
          brooklyn    
        }
        else if (input$boro1 == 'MANHATTAN') 
        {
          manha  
        }
        else if (input$boro1 == 'QUEENS') 
        {
          queens
        }
        else
        {
          stateis
        }
        
      })
    }
  })
  
  #############tab Heatmap ###############
  
  nhyc_cd_data <- cd_sf
  
  homeless_population <- homeless_population%>% 
    mutate(borough_cd_id = as.character(borough_cd_id), borough_id = as.character(borough_id))
  
  map_data <- geo_join(nhyc_cd_data, homeless_population, "borough_cd_id",  "borough_cd_id", how = "inner")
  
  output$map2 <- renderLeaflet({
    
    if(input$selectb == "2019_homeless"){
      bins <- c(0, 200,400, 600, 800, 1000,1500,2000,2500,2700)
      pal <- colorBin("Blues", domain = map_data$X2019_homeless_population, bins = bins)
      popup1 = paste0('<strong>Count: </strong><br>', map_data$X2019_homeless_population,
                      '<br><strong>Borough: </strong><br>', map_data$borough)
      
      map_data %>%
        st_transform(., "+init=epsg:4326") %>%
        leaflet() %>%
        addTiles() %>%
        addPolygons(popup = popup1,
                    layerId=~borough_cd_id,
                    #label = ~ttl_count,
                    fillColor = ~pal(X2019_homeless_population),
                    color = 'grey', 
                    fillOpacity = .6,
                    weight = 1,
                    dashArray = "3") %>% 
        addProviderTiles("CartoDB.Positron") %>% 
        addLegend(pal = pal, values = ~bins, opacity = 0.6, title = "Number of Homeless Population",
                  position = "bottomright")
    } else if(input$selectb == "2018_homeless"){
      bins2 <- c(0, 200,400, 600, 800, 1000,1500,2000,2500,2700)
      pal2 <- colorBin("Blues", domain = map_data$X2018_homeless_population, bins = bins2)
      popup2 = paste0('<strong>Count: </strong><br>', map_data$X2018_homeless_population,
                      '<br><strong>Borough: </strong><br>', map_data$borough)
      map_data %>%
        st_transform(., "+init=epsg:4326") %>%
        leaflet() %>%
        addTiles() %>%
        addPolygons(popup = popup2,
                    layerId=~borough_cd_id,
                    #label = ~ttl_count,
                    fillColor = ~pal2(X2018_homeless_population),
                    color = 'grey', 
                    fillOpacity = .6,
                    weight = 1,
                    dashArray = "3") %>% 
        addProviderTiles("CartoDB.Positron") %>% 
        addLegend(pal = pal2, values = ~bins2, opacity = 0.6, title = "Number of Homeless Population",
                  position = "bottomright")
    } else if(input$selectb == "2017_homeless"){
      bins2 <- c(0, 200,400, 600, 800, 1000,1500,2000,2500,2700)
      pal2 <- colorBin("Blues", domain = map_data$X2017_homeless_population, bins = bins2)
      popup2 = paste0('<strong>Count: </strong><br>', map_data$X2017_homeless_population,
                      '<br><strong>Borough: </strong><br>', map_data$cd_name)
      map_data %>%
        st_transform(., "+init=epsg:4326") %>%
        leaflet() %>%
        addTiles() %>%
        addPolygons(popup = popup2,
                    layerId=~borough_cd_id,
                    #label = ~ttl_count,
                    fillColor = ~pal2(X2017_homeless_population),
                    color = 'grey', 
                    fillOpacity = .6,
                    weight = 1,
                    dashArray = "3") %>% 
        addProviderTiles("CartoDB.Positron") %>% 
        addLegend(pal = pal2, values = ~bins2, opacity = 0.6, title = "Number of Homeless Population",
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
      
      
    })
  })
  ##################
  


  dateRangeInput<-reactive({final%>%filter(Date==input$daterange)})
  output$plot2 <- renderPlotly({
    plot_ly(data=dateRangeInput(),x=~Borough,y=~Individuals, type = "bar",text=~Individuals,textposition = 'auto')
  })
  BoroInput<-reactive({final%>%filter(Borough==input$boro)})
  output$plot3<-renderPlotly({
    plot_ly(data=BoroInput(), x = ~Date, y = ~Individuals, type = 'scatter', mode = 'lines',text=~Borough,textposition = 'auto') %>%
      layout(title = 'New York Homeless Population timeseries graph by Borough',
             xaxis = list(title = ""),
             yaxis = list(side = 'left', title = 'Number of people in thousand', showgrid = FALSE, zeroline = FALSE))
  })
  output$plot4<-renderPlotly({MergedDF %>% 
      plot_ly() %>%
      add_trace(x = ~Borough, y = ~Population1, type = 'bar', 
                text = ~Population, textposition = 'auto',
                marker = list(color = 'rgb(158,202,225)',
                              line = list(color = 'rgb(8,48,107)', width = 1.5))) %>%
      add_trace(x = ~Borough, y = ~Individuals1, type = 'bar', 
                text = ~Individuals, textposition = 'auto',
                marker = list(color = 'rgb(43,200,225)',
                              line = list(color = 'rgb(8,48,107)', width = 1.5)))%>%
      add_trace(x = ~Borough, y = ~total1, type = 'bar', 
                text = ~total, textposition = 'auto',
                marker = list(color = 'rgb(49,130,189)',
                              line = list(color = 'rgb(8,48,107)', width = 1.5))) %>%
      layout(title = "Proportion of Total Population, Homeless Population, Facility by Borough",
             barmode = 'group',
             xaxis = list(title = ""),
             yaxis = list(title = ""))
  })
  BoroInputp<-reactive({facilitystyle%>%filter(Borough==input$boro)})
  output$plot5<-renderPlotly({
    plot_ly(data=BoroInputp(), labels =~Facility, values = ~Number, type = 'pie') %>%
      layout(title = 'NYC Borough facility Pie Graph',
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })
  output$plotj1<-renderPlotly(pr)
  output$plotj2<-renderPlotly(boro_plot)
  output$plotj3<-renderPlotly(po)
})