library(sf.extract)
library(extract2)
library(raster)
library(sf)

files <- dir("H:/global_WB/ET/diagnosed_PML/v017", "ERA5.*.tif", full.names = TRUE)
file = files[1]
shp = read_sf("N:/Research/hydro/globalRunoff/INPUT/shp/globalRunoff_GSIM_10631basins.shp")

## 1. overlap and extract separately
system.time({
    blocks <- overlap(files[1] %>% raster(), shp, return.data = FALSE) # overlap information for each feature
})
system.time(lst <- st_extract(files, blocks))

# 140.97s
library(plyr)
## 2. sf.extract way
wkbs = sf::st_as_binary(sf::st_geometry(shp), EWKB=TRUE)
bandNames <- function(file) names(rast(file))
rs = files %>% map(rast) %>% do.call(c, .)
{
    bands = bandNames(files[1])
    source = terra::sources(rs)$source %>% basename()
    names <- paste(rep(source, each = length(bands)), bands, sep = "__")
    names(rs) <- names
}

system.time({
    r <- exact_extract(rs, shp, "weighted_mean", weights = rast(files[1]) * 0 + 1)
})
names(r) %>% gsub

library(tidyr)
d = pivot_longer(lst[[1]], everything(),
                 names_to = c("date", "band"),
             # names_transform = list(date = lubridate::as_date),
             names_pattern = "(.*)_(.*)")

write_fig({
    terra::plot(rs)
}, "a.pdf")
# 10.90
# 190.0 s

system.time({
    lst2 = llply(files, function(file) {
        r = brick(file) %>% readAll()
        # exact_extract(r, shp, "mean")
    }, .progress = "text")
})
