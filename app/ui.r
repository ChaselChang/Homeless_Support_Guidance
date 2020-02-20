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

shinyUI
(
  div
  (id = 'canvas',
      
  navbarPage
    (strong("Homeless needs help?",style="color: white;"), 
             theme=shinytheme("cerulean"),
             
             tabPanel('Map',
                      div(class="outer",
                      leafletOutput("map",width="100%",height=700),
                      
                      absolutePanel(id = "control", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                                    top = 170, left = 20, right = "auto", bottom = "auto", width = 250, height = "auto",
                                    
                      checkboxGroupInput("enable_markers", "Homeless Resources:",
                                          choices = c("Free Condom","Drop-In Center","Job Center"),
                                          selected = c("Free Condom","Drop-In Center","Job Center"))
                      )
                )
             )
    )
  )
)
