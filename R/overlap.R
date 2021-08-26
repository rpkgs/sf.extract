#' Get the detailed information of overlapped grids
#'
#' @param r Raster, RasterBrick, SpatialPixelsDataFrame or SpatialGridDataFrame object
#' @param geoms WKB objects, e.g.
#' `sf::st_as_binary(sf::st_geometry(basins), EWKB=TRUE)`
#'
#' @return `blocks`
#' - `fraction`: fraction percentage
#' - `area`: area in km^2
#' - `row`,`col`: begining `row` and `col` of the overlapped region
#' - `nrow`,`ncol`: number of the rows and columns of the overlapped region
#'
#' @importFrom plyr llply
#' @export
overlap <- function(r, geoms, return.id = FALSE) {
    r %<>% check_raster() %>% .[[1]]
    # r %<>% raster::raster()
    area <- raster::area(raster::raster(r)) %>% rast()
    geoms %<>% check_wkb() # convert to wkbs
    # readStart(r)
    # on.exit(readStop(r))
    blocks <- llply(geoms, function(wkb) {
        ret <- CPP_exact_extract_wkb(r, wkb = wkb)
        names(ret)[3] <- "fraction"
        dim <- dim(ret$fraction)
        ret$nrow <- dim[1]
        ret$ncol <- dim[2]
        ret$fraction <- as.vector(t(ret$fraction))

        ret$area <-
            terra::readValues(area,
            # raster::getValuesBlock(area,
                row = ret$row,
                col = ret$col,
                nrow = ret$nrow, ncol = ret$ncol
            )
        ret
    }, .progress = "text")
    attr(blocks, "Id") = attr(geoms, "Id")

    if (return.id) {
        getBlockValues(r, blocks)
    } else {
        blocks
    }
}

#' @rdname overlap
#' @importFrom data.table data.table
#' @export
getBlockValues <- function(r, blocks, .progress = "none") {
    r %<>% check_raster()
    readStart(r)
    on.exit(readStop(r))
    res <- llply(blocks, function(ret) {
        vals <- terra::readValues(r,
            row = ret$row,
            col = ret$col,
            nrow = ret$nrow, ncol = ret$ncol
        ) %>% as.data.table()
        d <- vals %>% cbind(ret[c("fraction", "area")] %>% as.data.table())
        d %>% subset(fraction > 0)
    }, .progress = .progress)
    res
}

check_raster <- function(r) {
    if ("SpatialPixelsDataFrame" %in% class(r) ||
        "SpatialGridDataFrame" %in% class(r) ||
        is.character(r))
        r %<>% rast()
    r
}

#' check_overlap
#' @param inheritParams st_extract
#' @rdname overlap
#' @export
check_overlap <- function(geoms, r) {
    geoms %<>% check_wkb()
    if ("WKB" %in% class(geoms)) {
        b <- rast(r[[1]]) #%>% readAll()
        Id <- attr(geoms, "Id")
        geoms <- overlap(b, geoms, return.id = FALSE) %>%
            set_attr("Id", Id)
    }
    geoms
}

check_wkb <- function(geoms) {
    if ("SpatialPolygonsDataFrame" %in% class(geoms)) {
        geoms %<>% sf::st_as_sf()
    }
    if ("sf" %in% class(geoms)) {
        Id <- geoms[[1]]
        geoms <- sf::st_as_binary(sf::st_geometry(geoms), EWKB = TRUE) %>%
            set_names(Id)
        attr(geoms, "Id") <- Id
    } else {
        if (is.null(attr(geoms, "Id")))
            attr(geoms, "Id") <- seq_along(geoms)
    }
    geoms
}
