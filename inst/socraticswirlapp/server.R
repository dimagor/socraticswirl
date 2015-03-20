library(shiny)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output, session) {
  autoInvalidate <- reactiveTimer(5000, session)
  
  attempts <- reactive({
    # todo: filter for lesson, instructor, and today
    autoInvalidate()
    Parse_retrieve("Answer")
  })
  
  output$bar_plot <- renderPlot({
    a <- attempts()
    if (length(a) == 0) {
      return(NULL)
    }
    d <- a %>% count(question, correct)
    print(ggplot(d, aes(x = question, y = n, fill = correct)) +
      geom_bar(stat = "identity", position = "dodge") +
      xlab("Exercise") +
      ylab("Attempts"))
  })
})
