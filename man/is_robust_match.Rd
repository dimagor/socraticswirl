% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/rmatch_calls.R
\name{is_robust_match}
\alias{is_robust_match}
\title{Recursively expand both the correct expression and the user's expression and
test for a match. CAUTION: May raise errors, as in rmatch_calls.}
\usage{
is_robust_match(expr1, expr2, eval_for_class, eval_env = NULL)
}
\arguments{
\item{expr1}{expression}

\item{expr2}{expression}

\item{eval_for_class}{TRUE or FALSE. If TRUE, evaluate the first argument of an S3 method to determine its class. Default=FALSE.}

\item{eval_env}{parent environment for evaluations to determine class. Ignored if eval_for_class=FALSE}
}
\value{
TRUE or FALSE according to whether expanded expressions match.
}
\description{
Recursively expand both the correct expression and the user's expression and
test for a match. CAUTION: May raise errors, as in rmatch_calls.
}
\examples{
\dontrun{

  expr1 <- quote(print(paste("my_name_is", "mud")))
  expr2 <- quote(print(paste("my_name_is", "mud", sep=" ")))
  err <- try(ans <- is_robust_match(expr1, expr2, eval_for_class=TRUE), silent=TRUE)
  if(is(ans, "try-error")){
    ans <- isTRUE(all.equal())
  }
}
}

