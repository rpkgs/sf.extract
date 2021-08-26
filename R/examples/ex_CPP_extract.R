# ret = sf.extract:::CPP_exact_st_extract(b, wkbs[[1]])
# geoms = CPP_exact_st_extract(b[[1]], wkbs[[1]]) # area is much

rc <- rowColFromCell(b, geoms$cell)
nrow <- rc[, 1] %>% range()
ncol <- rc[, 2] %>% range()

# trace(sf.extract:::CPP_exact_extract, edit = TRUE)
r <- exact_extract(b, st, function(value, cov_frac) length(value[cov_frac > 0.9]))
