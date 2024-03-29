library(raster)
library(terra)
library(sf)
library(sf.extract)

# skip_on_ci()
test_that("multiplication works", {
  expect_true({
    files = system.file("raster/PML2_yearly_static2017-01-01_2deg.tif", package = "sf.extract")

    # shape files
    # file_shp = system.file("shp/Continents.shp", package = "sf.extract")
    # st <- sf::read_sf(file_shp)
    # shp <- sf::as_Spatial(st)
    shp = basin_Baihe
    st = st_as_sf(shp)
    wkbs = sf::st_as_binary(sf::st_geometry(st), EWKB = TRUE) %>% set_names(st[["name"]])

    b <- rast(files[1]) # read raster
    b_in = raster::brick(files[1]) %>% readAll() %>% rast() # in memory

    ## 1. test for different poly obj
    r_name = st_extract(files, st) # sf obj
    r_Id  = st_extract(files, st[, 2]) # sf obj

    expect_equal(r_name[[1]]$depth, st$depth)
    expect_equal(r_Id[[1]]$name, st$name)

    r2 = st_extract(files, shp) # Spatial obj
    # get overlaped blocks first
    blocks <- overlap(b, st)
    r <- st_extract(b_in, blocks)
    # b_in fast in 5.2 times
    # microbenchmark::microbenchmark(
    #     r <- st_extract(b, blocks),
    #     r <- st_extract(b_in, blocks), times = 10
    # )
    r3 = st_extract(files, blocks, weight = FALSE)
    # default weight = TRUE, using area.weight, result differ significantly

    ## 2. test for different `st_` functions
    st_extract(b_in, blocks, fun = sf_median)
    st_extract(b_in, blocks, fun = sf_sd)
    st_extract(b_in, blocks, fun = sf_sum) %>% print() 
    st_extract(b_in, blocks, fun = sf_sum, weight = TRUE)
    st_extract(b_in, blocks, fun = sf_var, weight = TRUE)
    TRUE
  })
})
