library(shiny)

#Dashboard Demo
shinyServer(function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
})

# MAP

# JW



# KW









# REPORT

# JB



# HL



# TZ
