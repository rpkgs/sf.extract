
{
    library(sf2)
    
    basin = basin_Baihe
    x <- basin
    cellsize <- 0.5
    range <- st_range(basin, cellsize)
    r_mask <- make_grid(range, cellsize) %>% as_rast()

    wkb <- sf::st_as_binary(sf::st_geometry(st_as_sf(x)), EWKB = TRUE)
    # r_mask %<>% raster::raster()
}
r <- sf.extract::rast_overlap(r_mask, wkb[[1]])

# 2.2 pixel overlap faction
# r_fract <- overlap_fraction(basin, cellsize, range) %>% as_rast()
