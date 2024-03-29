# Generated by using Rcpp::compileAttributes() -> do not edit by hand
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

CPP_coverage_fraction <- function(rast, wkb, crop) {
    .Call(`_sf_extract_CPP_coverage_fraction`, rast, wkb, crop)
}

CPP_exact_extract_wkb <- function(rast, wkb) {
    .Call(`_sf_extract_CPP_exact_extract_wkb`, rast, wkb)
}

CPP_exact_extract <- function(rast, weights, wkb, default_value, default_weight, include_xy, include_cell_number, include_area, area_weights, coverage_areas, p_area_method, include_cols, src_names, p_weights_names, warn_on_disaggregate) {
    .Call(`_sf_extract_CPP_exact_extract`, rast, weights, wkb, default_value, default_weight, include_xy, include_cell_number, include_area, area_weights, coverage_areas, p_area_method, include_cols, src_names, p_weights_names, warn_on_disaggregate)
}

CPP_stats <- function(rast, weights, wkb, default_value, default_weight, coverage_areas, p_area_method, stats, max_cells_in_memory, quantiles) {
    .Call(`_sf_extract_CPP_stats`, rast, weights, wkb, default_value, default_weight, coverage_areas, p_area_method, stats, max_cells_in_memory, quantiles)
}

CPP_resample <- function(rast_in, rast_out, stat) {
    .Call(`_sf_extract_CPP_resample`, rast_in, rast_out, stat)
}

