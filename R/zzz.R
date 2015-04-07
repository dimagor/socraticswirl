.onAttach <- function(...) {
  packageStartupMessage(
      make_pretty("Hi! When you're ready, type socratic_swirl(...) ",
                  "with the options your instructor gives you to ",
                  "specify your lesson and instructor.",
                  skip_after=TRUE)
    )
  
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
