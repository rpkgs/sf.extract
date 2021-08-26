library(sf.extract)
library(extract2)
library(raster)
library(sf)
library(glue)
library(magrittr)
library(purrr)
library(Ipaper)
library(dplyr)
library(terra)
library(rtrend)

as_rast = . %>% raster() %>% rast()
r_mask = make_grid(cellsize = 1) %>% as_rast()

tidy_ERA5_nc <- function(r, value.name = "ET") {
    d = st_extract(r, shp)
    data.table(year = 1979:2020, 
        Ocean = d[1, -1] %>% as.matrix() %>% as.numeric(),
        Land = d[2, -1] %>% as.matrix() %>% as.numeric()) %>% 
        melt("year", variable.name = "region", value.name = value.name)
}

r_Prcp = rast("H:/global_WB/basemap/ERA5/yearly/ERA5_yearly_total_precipitation_(1979-2020).nc") * 1000
r_ET = rast("H:/global_WB/basemap/ERA5/yearly/ERA5_yearly_evaporation_(1979-2020).nc") * -1000

## check about precipitation difference
# r = rast("H:/global_WB/basemap/ERA5_year/ERA5L_1979-01-01.tif")
d_ET = tidy_ERA5_nc(r_ET)
d_Prcp = tidy_ERA5_nc(r_Prcp, "Prcp")
d = merge(d_Prcp, d_ET)

# plot(r_Prcp[[1]])
df2 = merge(df, d_ET, all = TRUE)

if (1) {
    shp = read_sf("H:/global_WB/basemap/Land_Ocean.shp")
    files = dir("H:/global_WB/basemap/ERA5_year", full.names = TRUE) %>% 
        set_names(str_year(.))
    
    res = plyr::llply(files, function(file) {
        r = rast(file) %>% crop(r_mask)
        st_extract(r, shp)
    }, .progress = "text")
    
    df = melt_list(res, "year") %>% dplyr::rename(region = FID_ne_10m) %>% 
        mutate(year = as.integer(year), 
            # ET = -ET,
            region = factor(region, c(0, 1), c("Ocean", "Land"))) %>% 
        arrange(region)
    d = melt(df2, c("year", "region"))
    prefix = "ERA5"
    fwrite(df2, glue("meteForcing_{prefix}_yearly_Land&Ocean.csv"))
}

if (1) {
    shp = read_sf("H:/global_WB/basemap/Land_Ocean.shp")
    files = dir("H:/global_WB/basemap/CFSV2_year", full.names = TRUE) %>% 
        set_names(str_year(.))

    res = plyr::llply(files, function(file) {
        r = rast(file) %>% crop(r_mask)
        st_extract(r, shp)
    }, .progress = "text")

    df = melt_list(res, "year") %>% dplyr::rename(region = FID_ne_10m) %>% 
        mutate(year = as.integer(year), 
            # ET = -ET,
            region = factor(region, c(0, 1), c("Ocean", "Land"))) %>% 
        arrange(region)
    d = melt(df, c("year", "region"))
}

library(ggplot2)
p <- ggplot(d, aes(year, value, shape = region, color = region)) + 
    geom_line() + 
    facet_wrap(~variable, scales = "free_y")
write_fig(p, glue("land&Ocean_{prefix}.pdf"))
# 0: Ocean
# 1: Land
# ERA5L
