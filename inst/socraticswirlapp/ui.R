library(shiny)

shinyUI(bootstrapPage(
  selectInput(inputId = "exercise",
              label = "Exercise Number:",
              choices = 11:12,
              selected = 12),
  
  plotOutput(outputId = "bar_plot", height = "300px")
))
