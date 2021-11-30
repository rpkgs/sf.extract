library(magrittr)
vals <- c(1, 2, 3, 4) %>% as.matrix()
ws <- c(5, 6, 7, 8) %>% as.matrix()
fracs <- c(0.5, 0, 1, 0.25) %>% as.matrix()

sf_sum(vals, fracs, ws)
sf_mean(vals, fracs, ws)
