
packages.used=c("shiny", "leaflet","plotly","data.table","shinyWidgets","googleVis","geosphere","leaflet.extras","shinythemes","ggmap","dplyr")
packages.needed=setdiff(packages.used, 
                        intersect(installed.packages()[,1], 
                                  packages.used))

if(length(packages.needed)>0){
  install.packages(packages.needed, dependencies = TRUE)
}
library(shiny)
library(leaflet)
library(plotly)
library(data.table)
library(shinyWidgets)
library(googleVis)
library(geosphere)
library(leaflet.extras)
library(shinythemes)
library(ggmap)
library(dplyr)


#Statistics Analysis Global Enviroment 

#Loading the required data:

radar <- read.csv("../data/homeless/radar.csv")
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

brooklyn <- plot_ly(
  type = 'scatterpolar',
  r = as.numeric(radar %>% dplyr::filter(Borough == "Brooklyn") %>% select(-"Borough")),
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
brooklyn

manha <- plot_ly(
  type = 'scatterpolar',
  r = as.numeric(radar %>% dplyr::filter(Borough == "Manhattan") %>% select(-"Borough")),
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
manha

queens <- plot_ly(
  type = 'scatterpolar',
  r = as.numeric(radar %>% dplyr::filter(Borough == "Queens") %>% select(-"Borough")),
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
queens

stateis <- plot_ly(
  type = 'scatterpolar',
  r = as.numeric(radar %>% dplyr::filter(Borough == "StatenIsland") %>% select(-"Borough")),
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
stateis

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
