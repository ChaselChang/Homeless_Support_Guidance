library(shiny)
library(leaflet)
library(data.table)
library(plotly)
library(shinythemes)
library(shinyWidgets)
library(bsplus)

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
      menuItem("Report", tabName = "Report", icon = icon("th")),
      menuItem('About', tabName = 'About', icon = icon("address-book"))
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
              h2("Report and Analysis on Homeless Population Living Conditions"),
              fluidRow(
                box(plotlyOutput("plot2")),
                box(plotlyOutput("plot3"))),
              fluidRow(
                #box(
                #  sliderInput("daterange", "Time",
                #              min=as.Date("2017-4-01","%Y-%m-%d"), max=as.Date("2019-12-01","%Y-%m-%d"),value =as.Date("2018-3-01","%Y-%m-%d"),
                #              timeFormat="%Y-%m",step=30 ),textOutput("SliderText")),
                box(
                  dateInput("daterange", "Time",value =as.Date("2018-3-01","%Y-%m-%d"))
                ),
                box(
                  selectInput("boro", "Choose the Borough",
                              choices = c("Choose Boro(s)" = "",
                                          "Bronx", "Brooklyn",
                                          "Manhattan", "Queens",
                                          "Staten Island"),
                              selected ="Bronx"))),
              fluidRow(
                box(plotlyOutput("plot4"),
                    h4("The graph shows the proportion of total population, homeleass population and number of facilities for each borough vs whole NY City"),
                    h4("Trace0 = Total population proportion in each Borough"),h4("Trace 1 = Total homeless popoulation proportion in each Borough"),
                    h4("Trace 2 = Total number of facility proportion in each Borough")),
                box(plotlyOutput("plot5"),  h3("Homeless people can find the distribution of different kinds of facilities for each borough"),
                    h4("Local government can also look this pie graph for future construction"))),
              fluidRow(
                box(plotlyOutput("plotj1"),
                h4("This time series plot shows the breakdown of sheltered New Yorkers - those in families with children far outnumber those in families 
without children, and the number of single New Yorkers in shelters is steadily rising.")),
                box(plotlyOutput("plotj3"),
                h4("This plot shows that while the number of all sheltered single New Yorkers is rising, there are many more 
men in shelters than women."))),
              fluidRow(
                box(plotlyOutput("plotj2"),
                h4("This stacked area plot shows that most homeless New Yorkers who aren't staying in shelters are increasingly living in the subways.")))
      ),
      tabItem(tabName = 'About',
              h2('Project Description:'),
              p(strong("Homeless Island is an APP designed for homeless population in New York City. With the 
                       respect to human dignity and human rights in heart, we hope homeless population 
                       could find this APP useful while they need help.")),
              p(strong("The application and data analysis are based on serveral datasets that across 
                       different fields of interests but all related to the concerning situation of 
                       NYC homeless. The datasets includes: public facilities that are open to homeless
                       population, homeless population distribution over time, health services for homeless,
                       etc. We believe the datasets are valid and authentic.")),
              p(strong("The first page is a resource guide map for the homeless population in NYC, it can help
                       them find a public facility easier. The second page shows a heat map of homeless 
                       distribution among the entire NYC. The third page illustrates the concerning situation of
                       the homeless population in NYC with detailed reports.")),
              h2('About Us:'),
              h3(strong('Jiadong Wu:')),
              p(strong("Columbia University/ Master of Arts in Statistics")), 
              fluidRow(column(12, icon('Github','fab fa-github'), ( a("Github",  target="_blank", href =  "https://github.com/VictorJW")))),
              fluidRow(column(12, icon('Linkedin', 'fab fa-linkedin'), ( a("Linkedin",  target="_blank", href =  "https://www.linkedin.com/in/jiadong-wu-61133517a/")))),
              
              h3(strong('Tianshu Zhang:')),
              p(strong("Columbia University/ Master of Arts in Statistics")), 
              fluidRow(column(12, icon('Github','fab fa-github'), ( a("Github",  target="_blank", href =  "https://github.com/ChaselChang")))),
              fluidRow(column(12, icon('Linkedin', 'fab fa-linkedin'), ( a("Linkedin",  target="_blank", href =  "https://www.linkedin.com/in/tianshu-zhang-chasel/")))),
              
              h3(strong('Kaiqi Wang:')),
              p(strong("Columbia University/ Master of Arts in Statistics")), 
              fluidRow(column(12, icon('Github','fab fa-github'), ( a("Github",  target="_blank", href =  "https://github.com/slwkq")))),
              fluidRow(column(12, icon('Linkedin', 'fab fa-linkedin'), ( a("Linkedin",  target="_blank", href =  "www.linkedin.com/in/kaiqi-cage-wang")))),
              
              h3(strong('Hongshan(Aria) Lin:')),
              p(strong("Columbia University/ Master of Arts in Statistics")), 
              fluidRow(column(12, icon('Github','fab fa-github'), ( a("Github",  target="_blank", href =  "https://arialin.com/")))),
              fluidRow(column(12, icon('Linkedin', 'fab fa-linkedin'), ( a("Linkedin",  target="_blank", href =  "https://www.linkedin.com/in/hongshan-lin/")))),
              
              h3(strong('Jacquelyn Blum')),
              p(strong("Columbia University/ Master of Arts in Statistics")), 
              fluidRow(column(12, icon('Github','fab fa-github'), ( a("Github",  target="_blank", href =  "https://github.com/jacquelynblum")))),
              fluidRow(column(12, icon('Linkedin', 'fab fa-linkedin'), ( a("Linkedin",  target="_blank", href =  "https://www.linkedin.com/in/jblum/")))),
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
