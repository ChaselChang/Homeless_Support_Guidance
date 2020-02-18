
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

c <- load("data_finale.RData")

p <- plot_ly() %>%
  add_pie(data = crime_sex, labels = ~sex, values = ~amount,
          name = "The Crime Victim Sex Distribution Chart",
          marker = list(colors=c("#ff427b","#42e3ff")),
          domain = list(row = 0, column = 0)) %>%
  add_pie(data = crime_race, labels = ~race, values = ~ amount,
          name = "The Crime Victim Race Distribution Chart",
          
          domain = list(row = 0, column = 1)) %>%
  add_pie(data = crime_num, labels = ~type, values = ~ amount,
          title = "The Crime Severity Distribution Chart",
          marker = list(colors=c("#ff0000","#ff7017","#ffff00")),
          domain = list(row = 0, column = 2)) %>%
  layout(title = "Pie Chart Summary of Crime Data", showlegend = F,
         grid=list(rows=1, columns=3),
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

plot_muliti_crime <-ggplot(crime_hour_boro, aes(hour, crime_weighted, color = boro)) + geom_line() +
  ggtitle("Danger Index Per Hour in each Borough") +
  labs (x = "Time", y = "Danger Index") +
  theme_grey(16) +
  theme(legend.title = element_blank())+
  scale_x_continuous(breaks = round(seq(0, 23, by = 1),1)) 
