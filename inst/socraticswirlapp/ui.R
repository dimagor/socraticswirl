library(shiny)
library(shinydashboard)

header <- dashboardHeader(title = "SocraticSwirl",
                          dropdownMenuOutput("progressMenu"))

sidebar <- dashboardSidebar(
  box(width = NULL,
      uiOutput("usersessions")),
  
  sidebarMenu(
    menuItem("Exercise Dashboard", tabName = "exercise", icon = icon("dashboard")),
    menuItem("Lesson Overview", tabName = "overview", icon = icon("list")),
    menuItem("Submitted Questions", tabName = "studentquestions", icon = icon("question-circle"))
  ),
  p(), #Fix for better separation
  
  box(
    width = NULL, title = "Controls", collapsible = TRUE,
    selectInput("interval", "Refresh interval",
                choices = c(
                  "5 seconds" = 5,
                  "15 seconds" = 15,
                  "30 seconds" = 30,
                  "1 minute" = 50,
                  "5 minutes" = 600,
                  "Off" = FALSE),
                selected = "30"),
    uiOutput("timeSinceLastUpdate"),
    actionButton("refresh", "Refresh now")
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "exercise",
            fluidRow(
              
              # Left Column
              column(width = 7,
                     # Exercise Selector
                     box(width = NULL, uiOutput("selectExercise")),
                     
                     # Question Info
                     box(collapsible = TRUE, width = NULL, title = "Question:",
                         verbatimTextOutput("exerciseQuestion"),
                         verbatimTextOutput("exerciseAnswer")),
                     
                     # Plots
                     box(collapsible = TRUE, width = NULL, title = "Student Attempts",
                         selectInput("exerciseGraphSelect", label = NULL, 
                                     choices = c("Attempt Frequency" = "attemptbar")),
                         plotOutput("exerciseGraph"))
                     ),
              
              # Right Column
              column(width = 5,
                     # Progres Bars
                     box(width = NULL, uiOutput("attemptedBar", style = "list-style-type: none;"),
                         uiOutput("completedBar", style = "list-style-type: none;")),
                     
                     # TODO: Capture Filter/Sort and use as input for tableoutput to preserve post refresh
                     # Answer Table
                     box(width = NULL,
                         dataTableOutput("incorrectAnswers"))
              )
            ) 
    ),
    
    tabItem(tabName = "overview",
            h2("Dashboard tab content")
    ),
    tabItem(tabName = "studentquestion",
            h2("Dashboard tab content")
    )
    )
  #QA Tab: List questions and add button to mark resolved
)

dashboardPage(header,  sidebar,  body)
