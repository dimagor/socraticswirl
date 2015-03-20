library(swirl)
install_course_directory("none")
socratic_swirl("ggplot2 exercises", "dgrtwo")
# opts <- swirl:::socratic_swirl_options()

# exercise(1)

swirl("test", test_course = "none", test_lesson = "ggplot2 exercises", from = 1, to = 1.5)

f <- function() {
  swirl("test", test_course = "none", test_lesson = "ggplot2 exercises", from = 1, to = 1.5)
}

# f()

library(swirl)
# install_from_swirl("R Programming")
g <- function(env = parent.frame()) {
  do.call(swirl, list("test", test_course = "R Programming", test_lesson = "Basic Building Blocks", from = 1), envir = env)
}
# g()

