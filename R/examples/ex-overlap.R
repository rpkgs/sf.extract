file = "F:/CUG-Hydro/p2021.globalETtrend/data-raw/Multimodel mean E Trends from CIMP6 and GLEAM.RData"
load(file)

{
  # set_options(list(style = "EN"))
  # grid <- expand.grid(s1 = seq(-179.5, 179.5, 1), s2 = seq(-89.5, 89.5, 1)) %>%
  #   cbind(I = 1:nrow(.), .) %>%
  #   df2sp(formula = ~ s1 + s2) %>%
  #   sf2::as_SpatialPixelsDataFrame()
  # grid2 <- melt(grid, id.vars = c('lon','lat'), variable.name = 'Factor', value.name = 'trends')
  df2 <- Trends_ALL %>%
    map(~ cbind(I = 1:nrow(.), .)) %>%
    melt_tree(c("band")) %>%
    melt(c("band", "I"), variable.name = "forcing")
}

# the best way
d = df2[band == "E" & forcing == "ALL"]
grid <- make_grid(range = c(-180, 180, -90, 90), cellsize = 1)
grid@data <- d
spplot(grid, "value")

st = read_sf("data-raw/shp/Continents.shp") %>% as_Spatial()

grid@data <- d[, 2]
t1 = system.time(r <- over(grid, st) )
t2 = system.time(laps <- overlap(grid, st, return.id = TRUE))
print(t1)
print(t2)
# 60X times faster
t1["elapsed"]/t2["elapsed"]
