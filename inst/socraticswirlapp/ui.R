library(shiny)
library(shinydashboard)

header <- dashboardHeader(title = "SocraticSwirl",
                          dropdownMenuOutput("progressMenu"))

sidebar <- dashboardSidebar(
  box(width = NULL,
      uiOutput("usersessions")),
  
  sidebarMenu(
    menuItem("Exercise Dashboard", tabName = "exercise"),
    menuItem("Lesson Overview", tabName = "overview", icon = icon("dashboard"))
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
                     box(uiOutput("selectExercise")),
                     valueBoxOutput("attemptedBox"),
                     valueBoxOutput("completedBox")
                     # % attempted, % complete
              )
            #Plot switch, Table of answers
            ),
    tabItem(tabName = "overview",
            h2("Dashboard tab content")
    )
    )
  #QA Tab: List questions and add button to mark resolved
)

dashboardPage(header,  sidebar,  body)
