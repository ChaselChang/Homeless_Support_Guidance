library(shiny)

#Dashboard

library(shinydashboard)

dashboardPage(
  skin = "black",
  dashboardHeader(title = "Resource Guidance for homeless population",
                  titleWidth = 450),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Map", tabName = "Map", icon = icon("map")),
      menuItem("Report", tabName = "Report", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      # Map tab content
      tabItem(tabName = "Map",
              h2("Map goes here")
      ),
      
      # Report tab content
      tabItem(tabName = "Report",
              h2("Interactive Report goes here"),
              fluidRow(
                box(plotOutput("plot1", height = 250)),
                
                box(
                  title = "Controls",
                  sliderInput("slider", "Number of observations:", 1, 100, 50)
                )
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
