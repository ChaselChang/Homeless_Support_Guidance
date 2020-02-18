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
    (strong("Are Children Living in Danger?",style="color: white;"), 
      theme=shinytheme("cerulean"),
      tabPanel('Map',
               div(class="outer",
                   leafletOutput("map",width="100%",height=700),
               )
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