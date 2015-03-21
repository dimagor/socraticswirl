library(shiny)

shinyUI(bootstrapPage(
  selectInput(inputId = "exercise",
              label = "Exercise Number:",
              choices = 10:11,
              selected = 11),
  h3("Sessions Started:"),
  textOutput(outputId = "sessions_started"),
  dataTableOutput(outputId = "incorrect_answers")
  # plotOutput(outputId = "bar_plot", height = "300px")
))
