#' make_rast
#'
#' @param range A numeric vector, `[lon_min, lon_max, lat_min, lat_max]`
#' @inheritParams terra::rast
#' @param ... other parameters to [terra::rast()], e.g., `names`, `vals`.
#'
#' @seealso [terra::rast()]
#' @importFrom terra ext
#' @export
make_rast <- function(range = c(-180, 180, -90, 90), res = 1, nlyrs = 1, ...) {
    if (length(res) == 1) {
        res <- rep(res, 2)
    }
    e <- ext(range[1], range[2], range[3], range[4])
    rast(e, res = res, nlyrs = nlyrs, ...)
}

#' st_range
#' get range of `sf` object
#' @export
st_range <- function(x, cellsize = 0.1) {
    bbox <- x %>% st_bbox()
    range <- (bbox / cellsize) %>% {
        c(floor(.[1]), ceiling(.[3]), floor(.[2]), ceiling(.[4]))
    } * cellsize
    range
}
