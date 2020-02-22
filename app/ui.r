#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(data.table)
library(plotly)
library(shinythemes)
library(shinyWidgets)

library(tidyverse)
library(DataExplorer)
library(funModeling)
library(Hmisc)

shinyUI
(
  div
  (id = 'canvas',
      
  navbarPage
    (windowTitle = "NYC Homeless",
      title = div(img(src="NYC.jpg",height = 30,
                      width = 50), "Homeless"), 
      id="gra", theme = shinytheme("journal"),
             
      ########Heatmap Panel##############
      
      tabPanel("Heat Map", icon = icon("map-signs"),
               tags$style(".outer {position: fixed; top: 41px; left: 0; right: 0; bottom: 0; overflow: hidden; padding: 0}"),
               div(class = "outer",
                   
                   tags$head(
                     # Include our custom CSS
                     includeCSS("styles.css"),
                     includeScript("gomap.js")
                   ),
                   
                   leafletOutput("map2", width = "100%", height = "100%"),
                   
                   absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                 draggable = TRUE, top = 120, left = 0, right = 40, bottom = "auto",
                                 width = 400, height = "auto",
                                 br(),
                                 radioButtons("selectb", label = strong("Age"),
                                              choices = list("1970s" = "1970s", "1980s" = "1980s", "1990s" = "1990s", "2000s" = "2000s", "2010s" = "2010s"), 
                                              selected = "2010s"),
                                 
                                 p(strong("Click on a community district to see the time trend of number of graffiti complaints.")),
                                 
                                 
                                 
                   )
               )
               
      ),
      #############
             tabPanel("Homeless Resource Guide", icon = icon("map-pin"),
                      tags$style(".outer {position: fixed; top: 41px; left: 0; right: 0; bottom: 0; overflow: hidden; padding: 0}"),
                      div(class="outer",
                          tags$head(
                            # Include our custom CSS
                            includeCSS("styles.css"),
                            includeScript("gomap.js")
                          ),
                          leafletOutput("map", width = "100%", height = "100%"),
                          
                          absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                        draggable = TRUE, top = 70, left = "auto", right = 20, bottom = "auto",
                                        width = 330, height = "auto",      
                                        
                          checkboxGroupInput("enable_markers", "Homeless Resources:",
                                          choices = c("Free Condom","Drop-In Center","Job Center", 
                                                      "Food Stamp Center", "After School Program","Health Insurance"),
                                          selected = c("Drop-In Center","Job Center", 
                                                       "Food Stamp Center", "After School Program","Health Insurance")),
                      
                          selectizeInput("boro1", "Choose the Borough",
                                     choices = c("Choose Boro(s)" = "",
                                                 "BRONX", "BROOKLYN",
                                                 "MANHATTAN", "QUEENS",
                                                 "STATEN ISLAND"),
                                     selected = c("BRONX"),
                                     multiple = T),
                          
                          plotlyOutput("boroplot", height = 280)
                      
                      
                      )
                )
             )
    )
  )
)
