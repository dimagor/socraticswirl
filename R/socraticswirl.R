# This contains functions for uploading exercise results to
# SocraticSwirl servers.


#' extract socratic_swirl options from environment
#' 
#' @param error whether to raise an error
#' 
#' @return A list containing
#'   \item{course}{course name for current SocraticSwirl session}
#'   \item{lesson}{lesson name for current SocraticSwirl session}
socratic_swirl_options <- function(error = TRUE) {
  course <- getOption("socratic_swirl_course")
  lesson <- getOption("socratic_swirl_lesson")
  instructor <- getOption("socratic_swirl_instructor")
  
  if (is.null(course) || is.null(lesson) || is.null(instructor)) {
    if (!error) {
      return(NULL)
    }
    stop("SocraticSwirl is not set up; did you forget to call ",
         "socratic_swirl?")
  }
  
  return(list(course = course, lesson = lesson, instructor = instructor))
}


#' set up SocraticSwirl in this session
#' 
#' Run this to set up a SocraticSwirl lesson. Particular exercises can then
#' be accessed using the \code{\link{exercise}} function.
#' 
#' @param lesson lesson name
#' @param instructor instructor's name
#' @param course course name, default \code{"none"}
#' @param ... extra arguments, not yet used
#' 
#' @export
socratic_swirl <- function(lesson, instructor, course = "default", ...) {
  # check if it is installed
  course_name <- stringr::str_replace_all(course, " ", "_")

  installed_courses <- list.files(swirl:::courseDir.default())
  installed <- course_name %in% installed_courses
  
  if (!installed) {
    # install
    message("Course ", course, " not installed; downloading and installing")
    # TODO: install from things besides github
    stop("Installation from backend not yet implemented")
    # install_course_github(github_username, course_name, ...)
  }
  
  # set course and lesson name options
  options(socratic_swirl_course = course, socratic_swirl_lesson = lesson,
          socratic_swirl_instructor = instructor)
  
  # set up error function
  options(error = socratic_swirl_error)
}


#' Function called after an error during a SocraticSwirl attempt
socratic_swirl_error <- function() {
  err_message <- geterrmessage()
  
  # save, read, then delete a history
  savehistory(file = ".hist")
  response <- stringr::str_trim(tail(readLines(".hist"), 1))
  unlink(".hist")
  
  opts <- socratic_swirl_options()
  exercise <- getOption("socratic_swirl_exercise")
  
  ret <- Parse_create("Answer",
                      course = opts$course,
                      lesson = opts$lesson,
                      exercise = exercise,
                      instructor = opts$instructor,
                      correct = FALSE,
                      response = response,
                      isError = TRUE,
                      errorMessage = err_message)
}



#' Take an instructor-provided exercise with SocraticSwirl
#' 
#' This is to be called after \code{\link{socratic_swirl}} is used to set up
#' a SocraticSwirl session.
#' 
#' @param exercise Which quiz exercise to take; provided by instructor
#' 
#' @export
exercise <- function(exercise) {
  opts <- socratic_swirl_options()
  
  options(socratic_swirl_exercise = exercise)

  swirl("test",
        test_course = opts$course,
        test_lesson = opts$lesson,
        from = exercise,
        to = exercise + .5)
}

#' Given a Swirl environment, update SocraticSwirl server
#' 
#' @param e Swirl environment, containing info on the current Swirl session
#' @param correct whether the answer was correct
#' 
#' @return boolean describing whether it uploaded the Socratic Swirl results
notify_socratic_swirl <- function(e, correct = TRUE) {
  o <- socratic_swirl_options()
  if (is.null(o)) {
    # no socratic swirl set up
    return(FALSE)
  }
  
  answer <- paste(str_trim(deparse(e$expr)), collapse = " ")
  ret <- Parse_create("Answer",
                      course = e$test_course,
                      lesson = e$test_lesson,
                      exercise = e$test_from,  # index of question
                      instructor = o$instructor,
                      correct = correct,
                      answer = answer)
  
  # TODO: check that there wasn't an error communicating with the server
  TRUE
}


### instructor functions

#' start up an instructor window
#' 
#' Start an instructor window in a Shiny app.
#' 
#' 
#' 
#' @export
socratic_swirl_console <- function(lesson, course = "none") {
  # TODO: error handling
  options(socratic_swirl_course = course,
          socratic_swirl_lesson = lesson)
  shiny::runApp(system.file("socraticswirlapp", package = "swirl"))
}


#' For an instructor; upload exercises to the SocraticSwirl database
#' 
#' @param input Either a single .yaml file, or a directory containing...
#' 
#' @export
upload_exercises <- function(input) {
  # input file and directory are treated differently
  if (file.info(input)$isdir) {
    # a directory with multiple files
  }
  else {
    # a single YAML file
  }
}

