
# extract2

<!-- badges: start -->
<!-- badges: end -->

The goal of extract2 is to ...

## Installation

``` r
remotes::install_gitlab("cug-hydro/sf.extract")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(sf.extract)
## basic example code
str_year <- function(files) {str_extract(basename(files), "\\d{4}")}

indir = "C:/Users/kongdd/Google 云端硬盘（kongdd.sysu@gmail.com）/PMLV2_yearly"
files = dir(indir, "*.tif$", full.names = TRUE) %>% set_names(., str_year(.))

polys <- read_sf("data-raw/shp/Continents.shp")[-8, 1]
polys <- rbind(polys, st_sf(CONTINENT = "Global", geometry = st_combine(polys[1:7, ])))

# add the polygon union, global
shp_wkb <- sf::st_as_binary(sf::st_geometry(polys), EWKB = TRUE)

# 1. get the overlap grids fraction and area
r = raster(files[1])
geoms <- overlap(r, shp_wkb)

res = foreach(file = files, i = icount()) %do% {
    runningId(i)
    r <- rast(file) #%>% readAll()
    r$ET = rowSums(as.matrix(r)[, 2:4], na.rm = TRUE) # not include ET_water
    r2 = r[[c("GPP", "ET")]]
    # exact_extract(r2[[1]], polys, "mean")
    extract2(r2, geoms)
}
```

##  References

1. https://github.com/isciences/exactextract
2. https://github.com/isciences/sf.extract
