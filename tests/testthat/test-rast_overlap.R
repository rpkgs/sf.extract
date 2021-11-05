test_that("rast_overlap works", {

    basin = basin_Baihe
    cellsize <- 0.5
    range <- st_range(basin, cellsize)
    r_mask <- make_rast(range, cellsize, vals = 1) 
    wkb <- sf::st_as_binary(sf::st_geometry(st_as_sf(basin)), EWKB = TRUE)

    r <- rast_overlap(r_mask, wkb[[1]])
    r2 <- rast_overlap(raster::raster(r_mask), wkb[[1]]) # raster object also works

    expect_true(all.equal(r, r2))
    expect_equal(nrow(r), 37)
})
