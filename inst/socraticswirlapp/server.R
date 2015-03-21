library(shiny)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output, session) {
  
  # Static Definitions ----------
  getPctColor <- function(pct){
    typeColors = c("black","red","orange","yellow","light-blue","navy","teal","aqua","lime","olive","green")
    typeColors[round(as.numeric(pct) / 10) + 1]
  }
  lectureInfo <- Parse_retrieve("lecdb_dima")
  
  # Reactive Functions ---------------
  usersLogged <- reactive({
    input$refresh #Refresh when button is clicked
    interval <- max(as.numeric(input$interval), 5)
    if(input$interval != FALSE) invalidateLater(interval * 1000, session)
    Parse_retrieve("udb_dima") %>% .$student %>% unique %>% length
  })  
  
  questionsAnswered <- reactive({
    input$refresh
    interval <- max(as.numeric(input$interval), 5)
    if(input$interval != FALSE) invalidateLater(interval * 1000, session)
    Parse_retrieve("adb_dima") %>% group_by()
  })  
  
  lastUpdateTime <- reactive({
    usersLogged()
    Sys.time()
  })
  
  selectedExercise <- reactive({
    questionsAnswered() %>% filter(exercise == input$exerciseID)
  })
  
  # Header --------
  
  output$progressMenu <- renderMenu({
    progress_breakdown <- questionsAnswered() %>%
      group_by(exercise) %>%
      distinct(student, exercise, correct) %>%
      summarise(n=sum(correct)) %>% 
      mutate(pct=round(n / usersLogged(), 2)*100)
    progress_breakdown <- left_join(lectureInfo,progress_breakdown, by="exercise") %>%
      mutate(pct=ifelse(is.na(pct),0,pct))
    progress_msgs <- apply(progress_breakdown, 1, function(row) {
      taskItem(value = row[["pct"]], 
               color = getPctColor(row[["pct"]]),
               paste("Exercise:", row[["exercise"]])
      )
    })
    
    dropdownMenu(type = "tasks", .list = progress_msgs)
  })
  
  # Sidebar --------------
  output$usersessions <- renderUI({
    h3("Sessions:", as.character(usersLogged()))
  })
  
  output$timeSinceLastUpdate <- renderUI({
    # Trigger this every 5 seconds
    invalidateLater(5000, session)
    p(
      class = "text-muted",
      "Data refreshed ",
      round(difftime(Sys.time(), lastUpdateTime(), units="secs")),
      " seconds ago."
    )
  })
  
  
  # BODY ------------
  output$selectExercise <- renderUI({
    exercises = as.list(lectureInfo$exercise)
    selectInput("exerciseID", "Select Exercise:", exercises, selected = "1")
  })
  
  output$attemptedBox <- renderValueBox({
    attempted = selectedExercise() %>% distinct(student) %>% nrow
    attempted_pct = round(attempted/usersLogged() * 100)
    valueBox(
      paste0(as.character(attempted_pct), "%"), "Attempted", icon = icon("bars"),
      color = getPctColor(attempted_pct)
    )
  })
  output$completedBox <- renderValueBox({
    completed = selectedExercise() %>% filter(correct) %>% distinct(student) %>% nrow
    completed_pct = round(completed/usersLogged() * 100)
    valueBox(
      paste0(as.character(completed_pct), "%"), "Progress", icon = icon("thumbs-up", lib = "glyphicon"),
      color = getPctColor(completed_pct)
    )
  })
  
 
  
})