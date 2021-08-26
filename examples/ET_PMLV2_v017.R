library(exactextractr)
library(extract2)
library(raster)
library(sf)
library(glue)
library(magrittr)
library(purrr)
library(Ipaper)
library(dplyr)

infile_shp = "n:/Research/hydro/ET_evaluation/INPUT/DATABASE_WORLD_V3/globalRunoff_WORLD_V3_yearly_670basins_final.shp"
shp <- read_sf(infile_shp)
# shp <- read_sf("N:/Research/hydro/globalRunoff/INPUT/shp/globalRunoff_GSIM_10631basins.shp")

# ET_water，在数据聚合过程中ET_water存在明显错误！20210617
## 1.1 PMLV2-V017
if (1) {
    patterns = c("GLDASv21", "ERA5L", "CFSV2") %>% set_names(., .)
    indir = "H:/global_WB/ET/diagnosed_PML/v017"
    lst_files = map(patterns, ~ dir(indir, glue("{.x}.*.tif"), full.names = TRUE))
    file <- lst_files[[1]][1]#files[1]

    lst <- st_extract_par(lst_files, shp)
    # blocks <- overlap(file, shp, return.id = FALSE)
    # lst = map(lst_files, ~ st_extract(.x, blocks))
    lst2 = map(lst, function(l) {
        map(l, ~ cbind(I = 1:nrow(.x), .x) %>% dplyr::select(-name)) %>%
            set_names(str_year(names(.))) %>%
            melt_list("year")
    })
    df = melt_list(lst2, "forcing") %>%
        mutate(ET = Ec + Es + Ei, year = as.integer(year))
    df_v017 = dplyr::select(df, -ET_pot) %>% rename(version = forcing)
    # saveRDS(df, "ET_PMLV2_v017.rds")
}

if (0) {
    patterns = c("v014", "v016") %>% set_names(., .)
    indir = "H:/global_WB/ET/diagnosed_PML/PMLV2_v016"
    lst_files = map(patterns, ~ dir(indir, glue("{.x}.*.tif"), full.names = TRUE))
    file <- lst_files[[1]][1]#files[1]
    # blocks <- overlap(file, shp, return.id = FALSE)
    # Ipaper::InitCluster(6, kill = FALSE)
    lst <- st_extract_par(lst_files, shp)
    # lst = map(lst_files, ~ st_extract(.x, blocks))
    lst2 = map(lst, function(l) {
        map(l, ~ cbind(I = 1:nrow(.x), .x) %>%
                dplyr::select(I, GPP, Ec, Es, Ei, ET_water, ET)) %>%
            set_names(str_year(names(.))) %>%
            melt_list("year")
    })
    df_v014 = melt_list(lst2, "version") %>%
        mutate(year = as.integer(year))
}

# ET_water出现了错误
df_PML2 = rbind(df_v014, df_v017) %>%
    .[, version := paste0("PMLV2_", version)]
saveRDS(df_PML2, "ET_PMLV2_v014&v016&v017_670basins.rds")

## 2. prcp
# melt("name", variable.name = "year", value.name = "prcp")
# saveRDS(df_prcp, "GSIM_10631basin_prcp_yearly_MSWEPV280_1980-2020.rds")
# df_all = merge(df, df_prcp)
# df_all2 = df_all %>% dplyr::rename(prcp_MSWEP = prcp) %>%
#     merge(df_prcp, all.x = TRUE)
# saveRDS(df_all2, "GSIM_10631basin_PML_ET&prcp.rds")


