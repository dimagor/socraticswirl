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
#' @param ... fields to query by
#'
#' @export
Parse_retrieve <- function(class_name, object_id, ...) {
  url <- paste("classes", class_name, sep = "/")
  
  # as of now, accepts only exact queries
  params <- list(...)
  if (length(params) > 0) {
    q <- list(where = rjson::toJSON())
  } else {
    q <- NULL
  }
  Parse_GET(url, query = q)
}
