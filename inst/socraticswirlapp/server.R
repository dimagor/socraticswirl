library(shiny)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output, session) {
  
  # Reactive Input
  usersLogged <- reactive({
    input$refresh #Refresh when button is clicked
    interval <- max(as.numeric(input$interval), 5)
    if(input$interval != FALSE) invalidateLater(interval * 1000, session)
    Parse_retrieve("udb_dima") %>% group_by()
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
  
  typeColors = c("black","red","orange","yellow","light-blue","navy","teal","aqua","lime","olive","green")
  
  output$progressMenu <- renderMenu({
    progress_breakdown <- questionsAnswered() %>%
      group_by(exercise) %>%
      distinct(student,exercise,correct) %>%
      summarise(n=sum(correct)) %>% 
      mutate(pct=round(n/sessions,2)*100)
    progress_msgs <- apply(progress_breakdown, 1, function(row) {
      taskItem(value = row[["pct"]], color = typeColors[round(as.numeric(row[["pct"]])/10)+1], paste("Exercise:",row[["exercise"]]))
    })
    
    dropdownMenu(type = "tasks", .list = progress_msgs)
  })
  
  output$sessions <- renderUI({
      udb <- usersLogged()
      users <- length(unique(udb$student))
      h3("Sessions:",users
      )
    })
  
 
  
})