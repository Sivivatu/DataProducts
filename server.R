# server.R

library(quantmod); library(forecast)
source("helpers.R")

shinyServer(function(input, output) {
    
    dataInput <- reactive({
        getSymbols(input$symb, src = "yahoo", 
                   from = input$dates[1],
                   to = input$dates[2],
                   auto.assign = FALSE)
    })
    forecastdata <- reactive({
        if (!input$forecast) return (dataInput())
        forecast.HoltWinters(HoltWinters(dataInput(), gamma=FALSE),h=19)
    })
    
    finaldata <- reactive({
        if (!input$adjust) return (dataInput())
        adjust(dataInput())
    })

  output$plot <- renderPlot({                     
    chartSeries(finaldata(), theme = chartTheme("white"), 
      type = "line", log.scale = input$log, TA = NULL)
  })
})