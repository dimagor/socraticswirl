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
  exercise <- getOption("socratic_swirl_exercise")
  student <- digest::digest(Sys.info())
  
  if (is.null(course) || is.null(lesson) || is.null(instructor)) {
    if (!error) {
      return(NULL)
    }
    stop("SocraticSwirl is not set up; did you forget to call ",
         "socratic_swirl?")
  }
  
  parse_object("StudentSession", course = course, lesson = lesson,
               instructor = instructor, student = student,
               ACL = socratic_swirl_acl())

  return(list(course = course, lesson = lesson, instructor = instructor,
              student = student, exercise = exercise))
}

#' Create an ACL (Access Control List) object for instructor-only objects
#' 
#' Create an ACL preventing anyone but the instructor from seeing the student's
#' response.
socratic_swirl_acl <- function() {
  ID <- getOption("socratic_swirl_instructor_id")
  if (is.null(ID)) {
    stop("SocraticSwirl instructor not set")
  }
  ret <- list()
  ret[[ID]] <- list(read = TRUE)
  ret
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
#' @import rparse
#' 
#' @export
socratic_swirl <- function(lesson, course = "default", instructor, ...) {
  # check the instructor
  instructor_user <- parse_query("_User", username = instructor)
  if (is.null(instructor_user)) {
    stop("Instructor ", instructor, " not found")
  }
  
  message("Installing course ", course)
  install_course_socratic_swirl(course)
  
  # check that lesson exists in the directory
  course_name <- stringr::str_replace_all(course, " ", "_")
  lesson_name <- stringr::str_replace_all(lesson, " ", "_")
  lesson_dir <- file.path(find.package("swirl"), "Courses", course_name, lesson_name)
  
  if (!file.exists(lesson_dir)) {
    stop("Lesson '", lesson, "' not found in course '", course, "'")
  }

  # set course and lesson name options
  options(socratic_swirl_course = course, socratic_swirl_lesson = lesson,
          socratic_swirl_instructor = instructor,
          socratic_swirl_instructor_id = instructor_user$objectId)
  
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
  
  opts <- socratic_swirl_options(error = FALSE)
  if (is.null(opts)) {
    return(NULL)
  }

  ret <- parse_object("StudentResponse",
                      course = opts$course,
                      lesson = opts$lesson,
                      exercise = opts$exercise,
                      instructor = opts$instructor,
                      isCorrect = FALSE,
                      command = command,
                      isError = TRUE,
                      errorMsg = err_message,
                      student = opts$student,
                      ACL = socratic_swirl_acl())
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
#' @import rparse
#' 
#' @return boolean describing whether it uploaded the Socratic Swirl results
notify_socratic_swirl <- function(e, correct = TRUE) {
  o <- socratic_swirl_options(error = FALSE)
  if (is.null(o)) {
    # no socratic swirl set up
    return(FALSE)
  }

  answer <- paste(str_trim(deparse(e$expr)), collapse = " ")
  ret <- parse_object("StudentResponse",
                      course = e$test_course,
                      lesson = e$test_lesson,
                      exercise = e$test_from,  # index of question
                      instructor = o$instructor,
                      isCorrect = correct,
                      isError = FALSE,
                      command = answer,
                      student = o$student,
                      ACL = socratic_swirl_acl())
  
  # TODO: check that there wasn't an error communicating with the server
  TRUE
}


#' install a course from the Socratic Swirl server
#'
#' Given the title of a course, install it from the server
#'
#' @param course Course title
#' 
#' @import rparse
#'
#' @export
install_course_socratic_swirl <- function(course) {
  # retrieve course
  co <- parse_query("Course", title = course)
  
  if (length(co) == 0) {
    stop("No course with title ", course, " found")
  }
  
  # get the first one (there should never be redundant; but just in case)
  install_course_url(co$zipfile$url[1])
}

