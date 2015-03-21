library(shiny)
library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "SocraticSwirl",
                  dropdownMenuOutput("progressMenu")),
  dashboardSidebar(
    box(width = NULL,
        uiOutput("sessions")),
    box(width = NULL,
        selectInput("interval", "Refresh interval",
                    choices = c(
                      "5 seconds" = 5,
                      "15 seconds" = 15,
                      "30 seconds" = 30,
                      "1 minute" = 50,
                      "5 minutes" = 600,
                      "Off" = FALSE
                    ),
                    selected = "30"
        ),
        uiOutput("timeSinceLastUpdate"),
        actionButton("refresh", "Refresh now"))
    ),
  dashboardBody()
)



# 
# shinyUI(fluidPage(
#   fluidRow(
#     column(1,
#             selectInput(inputId = "exercise",
#               label = "Exercise Number:",
#               choices = 10:11,
#               selected = 11)
#            ),
#     column(2,verbatimTextOutput(outputId = "sessions_started"))
#     ),
#   hr()
#   # dataTableOutput(outputId = "incorrect_answers")
#   # plotOutput(outputId = "bar_plot", height = "300px")
# ))
