#' @name sf_func
#' @title functions of zonal statistics
#'
#' @param vals matrix
#' @param fraction vector of overlaped ratio
#' @param area grid area
#'
#' @example R/examples/ex_sf_func.R
#' 
#' @importFrom plyr llply
#' @import matrixStats
#' @export
sf_func = function(FUN) {
    function(vals, fraction, area, weight = TRUE, ...) {
        if (weight) fraction = fraction * area
        FUN(vals, fraction, na.rm = TRUE) %>% set_names(colnames(vals))
    }
}

#' @export
#' @keywords internal
colWeightedSums <- function(x, w = NULL, na.rm = TRUE, ...) {
    if (is.null(w)) colSums2(x, na.rm = na.rm) else colSums2(x * w, na.rm = na.rm)
}

#' @rdname sf_func
#' @export
sf_mean <- sf_func(colWeightedMeans)

#' @rdname sf_func
#' @export
sf_sum <- sf_func(colWeightedSums)

#' @rdname sf_func
#' @export
sf_sd <- sf_func(colWeightedSds)

#' @rdname sf_func
#' @export
sf_median <- sf_func(colWeightedMedians)

#' @rdname sf_func
#' @export
sf_var <- sf_func(colWeightedVars)

# #' @rdname sf_func
# #' @export
# sf_min <- sf_func(colMins)

# #' @rdname sf_func
# #' @export
# sf_max <- sf_func(colMaxs)
