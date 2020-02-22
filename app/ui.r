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
    (windowTitle = "NYC Homeless",
      title = div(img(src="NYC.jpg",height = 30,
                      width = 50), "Homeless"), 
      id="gra", theme = shinytheme("journal"),
             
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
                                                      "Food Stamp Center", "After School Program"),
                                          selected = c("Drop-In Center","Job Center", 
                                                       "Food Stamp Center", "After School Program")),
                      
                          selectizeInput("boro1", "Choose the Borough",
                                     choices = c("Choose Boro(s)" = "",
                                                 "BRONX", "BROOKLYN",
                                                 "MANHATTAN", "QUEENS",
                                                 "STATEN ISLAND"),
                                     multiple = F),
                          p(strong("Support Rate:")),
                          
                          plotlyOutput("boroplot", height = 280)
                      
                      
                      )
                )
             )
    )
  )
)
