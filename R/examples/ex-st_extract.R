\dontrun{
library(raster)
library(exactextractr)
library(extract2)

# shape files
file_shp = system.file("shp/Continents.shp", package = "extract2")
# raster files
files = system.file("raster/PML2_yearly_static2017-01-01.tif", package = "extract2")

st <- sf::read_sf(file_shp)
shp <- sf::as_Spatial(st)
wkbs = sf::st_as_binary(sf::st_geometry(st), EWKB = TRUE) %>% set_names(st[[1]])

b <- raster::brick(files[1]) # read raster
b_in = brick(files[1]) %>% readAll() # in memory

## 1. test for different poly obj
r1 = st_extract(files, st)  # sf obj
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
st_extract(b_in, blocks, fun = sf_sum) # no colnames
st_extract(b_in, blocks, fun = sf_sum, weight = TRUE)
st_extract(b_in, blocks, fun = sf_var, weight = TRUE)

## 3. compared with exactextractr
files_10 = rep(files, 10)
system.time(r_0 <- exact_extract(brick(files[1]), st, 'mean'))

# 1 file is 4.77 second
system.time(r_kong <- st_extract(files_10[1], st, weight = FALSE))
system.time(r_kong <- st_extract(files_10, st, weight = FALSE))

# st_extract(r, geoms, fun = sf_max)
# st_extract(r, geoms, fun = sf_min)
}
