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
socratic_swirl <- function(lesson, instructor, course = "none", ...) {
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
}


#' Take an instructor-provided exercise with SocraticSwirl
#' 
#' This is to be called after \link{\code{socratic_swirl}} is used to set up
#' a SocraticSwirl session.
#' 
#' @param question Which quiz question to take; provided by instructor
#' 
#' @export
exercise <- function(question) {
  opts <- socratic_swirl_options()

  swirl("test",
        test_course = opts$course,
        test_lesson = opts$lesson,
        from = question,
        to = question + .5)
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

## Parse API functions

base_URL <- "https://api.parse.com"

Parse_headers <- function() {
  header_strs <- c('X-Parse-Application-Id' = Sys.getenv("PARSE_APPLICATION_ID"),
                   'X-Parse-REST-API-Key' = Sys.getenv("PARSE_API_KEY"))
  
  if (any(header_strs == "")) {
    stop("DEVELOPMENT: must set PARSE_APPLICATION_ID and PARSE_API_KEY environment variables")
  }
  
  httr::add_headers(.headers = header_strs)
}


Parse_GET <- function(path, ...) {
  req <- httr::GET(base_URL, path = paste0("1/", path), Parse_headers(), ...)
  process_Parse(req)
}


#' Perform a POST request to parse
Parse_POST <- function(path, body, ...) {
  req <- httr::POST(base_URL, path = paste0("1/", path),
                    body = rjson::toJSON(body),
                    encode = "json", Parse_headers(), ...)
  
  process_Parse(req)
}


#' process a request object from Parse
process_Parse <- function(req) {
  txt <- httr::content(req, as = "text")
  j <- jsonlite::fromJSON(txt)
  
  if ("results" %in% names(j)) {
    j <- j$results
  }
  
  for (col in names(j)) {
    if (grepl("At$", col)) {
      j[[col]] <- as.POSIXct(j[[col]], origin = "1970-01-01")
    }
  }
  
  j
}


Parse_create <- function(class_name, ...) {
  body <- list(...)
  Parse_POST(paste0("classes/", class_name), body)
}

#' retrieve one or more objects from Parse
#'
#' @param class_name
#' @param object_id if provided, a specific object ID to retrieve
#' @param ... fields to query by (not yet implemented)
#'
#' @export
Parse_retrieve <- function(class_name, object_id, ...) {
  url <- paste("classes", class_name, sep = "/")
  Parse_GET(url)
}


