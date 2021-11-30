\dontrun{
library(terra)
library(sf.extract)

## 0. load data
# raster files
files <- system.file("raster/PML2_yearly_static2017-01-01_2deg.tif", package = "sf.extract")
# shape files
file_shp <- system.file("shp/Continents.shp", package = "sf.extract")

st <- sf::read_sf(file_shp)
shp <- sf::as_Spatial(st)
wkbs = sf::st_as_binary(sf::st_geometry(st), EWKB = TRUE) %>% set_names(st[[1]])

## 1. test for different poly obj
r1 = st_extract(files, st)  # sf obj
r2 = st_extract(files, shp) # Spatial obj

## 2. test for different `st_` functions
st_extract(files, blocks, fun = sf_median)
st_extract(files, blocks, fun = sf_sd)
st_extract(files, blocks, fun = sf_sum) # no colnames
st_extract(files, blocks, fun = sf_sum, weight = TRUE)
st_extract(files, blocks, fun = sf_var, weight = TRUE)

}
