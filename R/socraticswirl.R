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
  student <- digest::digest(Sys.info())
  
  if (is.null(course) || is.null(lesson) || is.null(instructor)) {
    if (!error) {
      return(NULL)
    }
    stop("SocraticSwirl is not set up; did you forget to call ",
         "socratic_swirl?")
  }
  
  return(list(course = course, lesson = lesson, instructor = instructor,
              student = student))
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
  
  message("Installing course ", course)
  install_course_socratic_swirl(course)

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
  command <- stringr::str_trim(tail(readLines(".hist"), 1))
  unlink(".hist")
  
  opts <- socratic_swirl_options()
  exercise <- getOption("socratic_swirl_exercise")
  
  ret <- Parse_create("StudentResponse",
                      course = opts$course,
                      lesson = opts$lesson,
                      exercise = exercise,
                      instructor = opts$instructor,
                      isCorrect = FALSE,
                      command = command,
                      isError = TRUE,
                      errorMsg = err_message,
                      student = opts$student)
}



#' Take an instructor-provided exercise with SocraticSwirl
#' 
#' This is to be called after \link{\code{socratic_swirl}} is used to set up
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
  ret <- Parse_create("StudentResponse",
                      course = e$test_course,
                      lesson = e$test_lesson,
                      exercise = e$test_from,  # index of question
                      instructor = o$instructor,
                      isCorrect = correct,
                      isError = FALSE,
                      command = answer,
                      student = o$student)
  
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


#' install a course from the Socratic Swirl server
#'
#' Given the title of a course, install it from the server
#'
#' @param course Course title
#'
#' @export
install_course_socratic_swirl <- function(course) {
  # retrieve course
  course <- stringr::str_replace_all(course, " ", "_")

  co <- Parse_retrieve("Course", title = course)
  
  if (length(co) == 0) {
    stop("No course with title ", course, " found")
  }
  
  # get the first one (TODO: there should never be redundant)
  url <- co$zipfile$url[1]
  install_course_url(url)
}

