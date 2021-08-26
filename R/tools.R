# guess first column name for the returned result
guess_col1 <- function(geoms) {
    class <- class(geoms)
    if ("sf" %in% class || grepl("Spatial", class)) {
        names(geoms)[1]
    } else "name"
}

#' @export
set_names_head <- function(x, names) {
    n <- length(names)
    names(x)[1:n] <- names
    x
}

runningId <- function(i, step = 1, N, prefix = "") {
    perc <- ifelse(missing(N), "", sprintf(", %.1f%% ", i / N * 100))
    if (mod(i, step) == 0) cat(sprintf("[%s] running%s %d ...\n", prefix, perc, i))
}

seq_along2 <- function(x) {
    seq_along(x) %>% set_names(names(x))
}

#' @export 
str_year <- function(x) {
    ans = stringr::str_extract(basename(x), "\\d{4}")
    ind_bad = which(is.na(ans))
    if (length(ind_bad) > 0) {
        ans[ind_bad] <- basename(x)[ind_bad]
    }
    ans
}

#' @export 
date_ym <- function(x) {
    lubridate::make_date(year(x), month(x), 1)
}
