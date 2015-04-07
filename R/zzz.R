.onAttach <- function(...) {
  if(length(ls(envir=globalenv())) > 0) {
    packageStartupMessage(
      make_pretty("Hi! I see that you have some variables saved in your",
      "workspace. To keep things running smoothly, I recommend you clean up",
      "before starting swirl.", skip_after=TRUE),
      make_pretty("Type ls() to see a list of the variables in your workspace.",
      "Then, type rm(list=ls()) to clear your workspace.", skip_after=TRUE),
      make_pretty("Type swirl() when you are ready to begin.", skip_after=TRUE)
    )
  } else {
    packageStartupMessage(
      make_pretty("Hi! Type swirl() when you are ready to begin.",
                  skip_after=TRUE)
    )
  }
  
  # set socratic swirl options
  Sys.setenv(PARSE_APPLICATION_ID = "C0pM75Sepnt5WhK6P6yhRA0TqVa6Xa3vqwZjpLfT",
             PARSE_API_KEY = "HyXS1gEn6gf7gibjDJVWPYsnIoc0SXcp4mwohdmI")
  
  invisible()
}

make_pretty <- function(..., skip_before=TRUE, skip_after=FALSE) {
  wrapped <- strwrap(str_c(..., sep = " "),
                     width = getOption("width") - 2)
  mes <- str_c("| ", wrapped, collapse = "\n")
  if(skip_before) mes <- paste0("\n", mes)
  if(skip_after) mes <- paste0(mes, "\n")
  mes
}