library(dplyr)

radar <- read.csv("./radar/radar.csv")

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