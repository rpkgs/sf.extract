% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sf_func.R
\name{sf_func}
\alias{sf_func}
\alias{sf_mean}
\alias{sf_sum}
\alias{sf_sd}
\alias{sf_median}
\alias{sf_var}
\title{functions of zonal statistics}
\usage{
sf_func(FUN)

sf_mean(vals, fraction, area, weight = TRUE, ...)

sf_sum(vals, fraction, area, weight = TRUE, ...)

sf_sd(vals, fraction, area, weight = TRUE, ...)

sf_median(vals, fraction, area, weight = TRUE, ...)

sf_var(vals, fraction, area, weight = TRUE, ...)
}
\arguments{
\item{vals}{matrix}

\item{fraction}{vector of overlaped ratio}

\item{area}{grid area}
}
\description{
functions of zonal statistics
}
\examples{
library(magrittr)
vals <- c(1, 2, 3, 4) \%>\% as.matrix()
ws <- c(5, 6, 7, 8) \%>\% as.matrix()
fracs <- c(0.5, 0, 1, 0.25) \%>\% as.matrix()

sf_sum(vals, fracs, ws)
sf_mean(vals, fracs, ws)
}
