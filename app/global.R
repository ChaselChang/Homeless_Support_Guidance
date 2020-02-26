
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

radar <- read.csv("./rundata/radar.csv")
bronx <- plot_ly(
  type = 'scatterpolar',
  r = as.numeric(radar %>% dplyr::filter(Borough == "Bronx") %>% select(-"Borough")),
  theta = c('Homes','Job Center','Education', 'Condom', 'Primary care', 'Food stamp'),
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
  theta = c('Homes','Job Center','Education', 'Condom', 'Primary care', 'Food stamp'),
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
  theta = c('Homes','Job Center','Education', 'Condom', 'Primary care', 'Food stamp'),
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
  theta = c('Homes','Job Center','Education', 'Condom', 'Primary care', 'Food stamp'),
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
  theta = c('Homes','Job Center','Education', 'Condom', 'Primary care', 'Food stamp'),
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
  theta = c('Homes','Job Center','Education', 'Condom', 'Primary care', 'Food stamp'),
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

##Plot 1 - This stacked area plot shows that most homeless New Yorkers who aren't staying in shelters are increasingly living in the subways. 
library(tidyverse)
library(ggplot2)
library(viridis)
boro <- read.csv("./rundata/Directory_Of_Homeless_Population_By_Year.csv")
boro_plot <- boro[-c(6, 8, 14, 16, 22, 24, 30, 32),] %>% 
  ggplot(aes(x=Year, y=Homeless.Estimates, fill=Area, text=Area)) +
  geom_area( ) +
  scale_fill_viridis(discrete = TRUE) +
  ggtitle("Location of Unsheltered New York Homeless") +
  labs(y="Estimated Number of Unsheltered Homeless", x = "Year")
boro_plot <- ggplotly(boro_plot, tooltip="text")
boro_plot

##Plot 2 - This time series plot shows the breakdown of sheltered New Yorkers - those in families with children far outnumber those in families 
##without children, and the number of single New Yorkers in shelters is steadily rising
census <- read.csv("./rundata/DHS_Census.csv")
arranged2 <- arrange(census, Date.of.Census)
arranged2$Date.of.Census <- as.Date(arranged2$Date.of.Census, "%m/%d/%Y")
pr <- plot_ly(arranged2, x = ~Date.of.Census) %>%
  add_lines(y = ~Families.with.Children.in.Shelter, name = "Families with Children in Shelter") %>%
  add_lines(y = ~Adult.Families.in.Shelter, name = "Adult Families in Shelter") %>%
  add_lines(y = ~Total.Single.Adults.in.Shelter, name = "Adult Individuals in Shelter") %>%
  plotly::layout(
    title = "Families Sheltered in New York",
    xaxis = list(
      rangeselector = list(
        buttons = list(
          list(
            count = 3,
            label = "3 mo",
            step = "month",
            stepmode = "backward"),
          list(
            count = 6,
            label = "6 mo",
            step = "month",
            stepmode = "backward"),
          list(
            count = 1,
            label = "1 yr",
            step = "year",
            stepmode = "backward"),
          list(
            count = 1,
            label = "YTD",
            step = "year",
            stepmode = "todate"),
          list(step = "all"))),
      
      rangeslider = list(type = "date")),
    
    yaxis = list(title = "Number of Sheltered New Yorkers"))

pr

##Plot 3 - This plot shows that while the number of all sheltered single New Yorkers is rising, there are many more 
##men in shelters than women
malfem <- read.csv("./rundata/DHS_Daily_Report.csv")
str(malfem)
arranged3 <- arrange(malfem, Date.of.Census)
arranged3$Date.of.Census <- as.Date(arranged3$Date.of.Census, "%m/%d/%Y")
po <- plot_ly(arranged3, x = ~Date.of.Census) %>%
  add_lines(y = ~Single.Adult.Men.in.Shelter, name = "Single Adult Men") %>%
  add_lines(y = ~Single.Adult.Women.in.Shelter, name = "Single Adult Women") %>%
  plotly::layout(
    title = "Single Homeless New Yorkers",
    xaxis = list(
      rangeselector = list(
        buttons = list(
          list(
            count = 3,
            label = "3 mo",
            step = "month",
            stepmode = "backward"),
          list(
            count = 6,
            label = "6 mo",
            step = "month",
            stepmode = "backward"),
          list(
            count = 1,
            label = "1 yr",
            step = "year",
            stepmode = "backward"),
          list(
            count = 1,
            label = "YTD",
            step = "year",
            stepmode = "todate"),
          list(step = "all"))),
      
      rangeslider = list(type = "date")),
    
    yaxis = list(title = "Number of Homeless New Yorkers"))

po
