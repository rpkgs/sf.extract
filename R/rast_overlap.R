#' rast_overlap
#' 
#' Extract raster overlapping info by the function `[sf.extract:::CPP_exact_extract()]`
#' 
#' @param r raster
#' @param wkb WKB objects, e.g.
#' `sf::st_as_binary(sf::st_geometry(basins), EWKB=TRUE)`
#' 
#' @keywords internal
#' @import sf
#' @importFrom data.table as.data.table
#' @export
rast_overlap <- function(r, wkb,
    default_value = NA_real_,
    default_weight = NA_real_,

    include_xy = FALSE,
    include_cell = TRUE,
    include_area = FALSE,
    include_cols = NULL,
    coverage_area = FALSE)
{
    area_weights = TRUE
    # if (area_weights || include_area || coverage_area) {
    area_method <- "spherical" #.areaMethod(analysis_crs)
    # } else {
    #     area_method <- NULL
    # }
    names = names(r)
    if (length(names) <= 1) names = "values"

    # exactextractr:::
    CPP_exact_extract(r, NULL, wkb,
        default_value, default_weight,
        include_xy ,
        include_cell ,
        include_area ,
        area_weights ,
        coverage_area ,
        area_method ,
        include_cols = NULL,
        src_names = names,
        p_weights_names = "weight",
        warn_on_disaggregate = TRUE
    ) %>% as.data.table()
}
