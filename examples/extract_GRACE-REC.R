library(exactextractr)
library(extract2)
library(raster)
library(sf)
library(glue)
library(magrittr)
library(purrr)
library(Ipaper)
library(dplyr)
library(stringr)
library(nctools)
library(matrixStats)

indir = "H:/global_WB/GRACE-REC/monthly"
files = dir(indir, "*.nc", full.names = TRUE)
prefixs = str_extract(files %>% basename(), "(?<=v03_).*(?=_monthly)")
files %<>% set_names(prefixs)

aggregate_mon2year <- function(file) {
    # file = files[1]
    prefix = str_extract(file %>% basename(), "(?<=v03_).*(?=_monthly)")

    dates <- nc_date(file)
    years_full = year(dates) %>% table() %>% {which(. == 12)} %>% names()
    date_begin = years_full %>% first() %>% paste0("-01-01") #%>% as.Date()
    date_end   = years_full %>% last() %>% paste0("-12-31") #%>% as.Date()

    dates_mon  = seq(date_begin %>% as.Date(), date_end %>% as.Date(), by = "month")
    dates_year = seq(date_begin %>% as.Date(), date_end %>% as.Date(), by = "year")

    x = ncread(file, 1, DatePeriod = c(date_begin, date_end))$data[[1]]
    x_yearly = apply_3d(x, by = year(dates_mon), FUN = rowSums2)

    lon = ncread(file, "lon")
    lat = ncread(file, "lat")
    dims = ncdim_def_lonlat(lon, lat, dates_year)
    outfile = glue("GRACE_REC_v03_{prefix}_yearly.nc")

    if (!file.exists(outfile) || overwrite) {
        ncwrite(list(rec_ensemble_mean = x_yearly), outfile, dims = dims,
                var.units = "mm/y",
                var.longname = "Ensemble mean of the TWS reconstruction (deseasonalized)")
    }
}
temp = map(files, aggregate_mon2year)
# select complete years


# dim(x)
shp <- read_sf("N:/Research/hydro/globalRunoff/INPUT/shp/globalRunoff_GSIM_10631basins.shp")

# rec_ensemble_mean  : Ensemble mean of the TWS reconstruction (deseasonalized),
# rec_seasonal_cycle : Seasonal cycle based on GRACE
library(terra)
lst <- map(files, function(file) {
    dates = nc_date(file) %>% ymon() %>% format()
    r = rast(file, "rec_ensemble_mean") 
    names(r) = dates
    #%>% set_names(dates)
    st_extract(r, shp) 
}) 
l <- readRDS("I:/Research/rpkgs/extract2/GRACE-REC_v03_GSIM_10631basins.rds")
d <- l$GSFC_ERA5[, -1]

df = map(l, get_deltaS) %>% melt_list("source")

get_year <- . %>% as.Date() %>% year()
get_deltaS <- function(d) {
    d = d[, -1]
    mon = names(d) %>% as.Date() %>%  month()
    mat =  d[, mon == 1] %>% as.matrix()
    x_01 = rowDiffs(mat) %>%
        set_colnames(colnames(mat) %>% {.[1:(length(.)-1)]} %>% get_year()) %>%
        as.data.table() %>% cbind(I = 1:nrow(.), .) %>%
        pivot_longer(-1, "year", values_to = "TWS_01") %>%
        data.table()
    mat = d[, mon == 12] %>% as.matrix()
    x_12 = rowDiffs(mat) %>%
        set_colnames(colnames(mat) %>% {.[-1]} %>% get_year()) %>%
        as.data.table() %>% cbind(I = 1:nrow(.), .) %>%
        pivot_longer(-1, "year", values_to = "TWS_12") %>%
        data.table()

    # the average of 12 and 1
    mat  =  d[, mon %in% c(1, 12)] %>% as.matrix()
    grps = colnames(mat) %>% as.Date() %>% diff() %>% {c(FALSE, . > 60)} %>% cumsum()
    I_cols = which(grps %in% {which(table(grps) == 2) %>% names()})
    mat2 = apply_row(mat[, I_cols], by = grps[I_cols])
    years = colnames(mat)[I_cols[seq(2, length(I_cols), 2)]] %>% get_year()
    x_2 = rowDiffs(mat2) %>%
        set_colnames(years %>% {.[1:(length(.)-1)]}) %>%
        as.data.table() %>% cbind(I = 1:nrow(.), .) %>%
        pivot_longer(-1, "year", values_to = "TWS_2mon") %>%
        data.table()
    d_S = merge(x_01, x_12, all = TRUE) %>% merge(x_2, all.x = TRUE)
    d_S
}

saveRDS(df, "GRACE-REC_v03_GSIM_10631basins_6source.rds")

