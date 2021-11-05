#' @name st_extract
#' @title Get zonal statistics from raster
#'
#' @param r Raster, RasterBrick or character (raster paths) object
#' @param geoms WKB, sf or sf Spatial object,
#' e.g. `sf::st_as_binary(sf::st_geometry(basins), EWKB=TRUE)`.
#' @param fun one of [sf_mean()], [sf_median()], [sf_sum()], [sf_sd()], [sf_var()]
#' @param weight boolean. If true, `fraction = fraction * area`
#' @param ... other parameters to `fun`
#'
#' @seealso [sf_func()]
#' @example R/examples/ex-st_extract.R
#' @importFrom terra readValues readStart readStop
NULL

.st_extract <- function(r, geoms, fun = sf_mean, weight = TRUE, ...) {
  name_col1 = guess_col1(geoms)
  nbands = length(names(r))
  .fun_sum = if (nbands > 1) colSums else sum
  n = length(geoms)

  geoms = check_overlap(geoms, r)
  names = names(r)
  
  readStart(r)
  on.exit(readStop(r))
  
  res = llply(geoms, function(ret){
    # v <- readValues(x, ...)
    vals <- terra::readValues(r,
      row = ret$row,
      col = ret$col,
      nrow = ret$nrow, ncol = ret$ncol, 
      mat = TRUE
    ) %>% set_colnames(names)
    
    fun(vals, ret$fraction, area = ret$area, weight = weight, ...)
  }, .progress = "text")
  do.call(rbind, res) %>% as.data.frame() %>%
    set_rownames(NULL) %>%
    cbind(name = attr(geoms, "Id"), .) %>% set_names_head(name_col1)
}

setGeneric("st_extract", function(r, geoms, ...) standardGeneric("st_extract"))

#' @rdname st_extract
#' @export
setMethod("st_extract", signature(r = "RasterLayer"), .st_extract)

#' @export
#' @rdname st_extract
setMethod("st_extract", signature(r = "RasterStack"), .st_extract)

#' @rdname st_extract
#' @export
setMethod("st_extract", signature(r = "SpatRaster"), .st_extract)

#' @export
#' @rdname st_extract
setMethod("st_extract", signature(r = "list"),
function(r, geoms, fun = sf_mean, weight = TRUE, ...) {
  res = list()
  geoms = check_overlap(geoms, r)

  llply(seq_along2(r), function(i){
    runningId(i)
    b <- rast(r[[i]])
    st_extract(b, geoms, fun, weight, ...)
  })
})

#' @rdname st_extract
#' @importFrom terra rast
#' @export
setMethod(
  "st_extract", signature(r = "character"),
  function(r, geoms, fun = sf_mean, weight = TRUE, ...) {
    name_col1 = guess_col1(geoms)
    geoms <- check_overlap(geoms, r)

    if (is.null(names(r))) {
      names = basename(r) %>% stringr::str_extract(".*(?=\\.)")
      names(r) = names
    }

    llply(seq_along2(r), function(i) {
      runningId(i)
      # b <- brick(r[[i]]) %>% readAll()
      b <- rast(r[[i]])
      st_extract(b, geoms, fun, weight, ...) %>% set_names_head(name_col1)
    })
  }
)

#' @note `extract2` was renamed to `st_extract`
#' @rdname st_extract
#' @export
extract2 <- st_extract

