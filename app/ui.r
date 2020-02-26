library(shiny)
library(leaflet)
library(data.table)
library(plotly)
library(shinythemes)
library(shinyWidgets)

#Dashboard

library(shinydashboard)

dashboardPage(
  skin = "blue",
  dashboardHeader(title = "Resource Guidance for homeless population",
                  titleWidth = 450),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Map", tabName = "Map", icon = icon("map")),
      menuItem("HeatMap", tabName = "HeatMap", icon = icon("map")),
      menuItem("Report", tabName = "Report", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      
      # Map tab content
      tabItem(tabName = "Map",
              h2("Public Support Resource Map and Suport Rate Assessment"),

              fluidRow(
                leafletOutput("map", width = "100%", height = 850),
                
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
      ),
      
      tabItem(tabName = "HeatMap",
              h2("Public Support Resource Map and Suport Rate Assessment"),
              
              fluidRow(
                leafletOutput("map2", width = "100%", height = 850),
                
                absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                              draggable = TRUE, top = 120, left = 300, right = 340, bottom = "auto",
                              width = 400, height = "auto",
                              br(),
                              radioButtons("selectb", label = strong("Year"),
                                           choices = list("2019_homeless" = "2019_homeless", "2018_homeless" = "2018_homeless", "2017_homeless" = "2017_homeless"), 
                                           selected = "2019_homeless"),
                              
                              p(strong("Click on a community district to see the population of homeless.")),
                              
                              
                              
                )
              )
      ),
      # Repo tab content
      tabItem(tabName = "Report",
              h2("Report")
      )
    )
  )
)


# MAP

# JW



# KW









# REPORT

# JB



# HL



# TZ
