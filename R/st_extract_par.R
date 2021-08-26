#' st_extract_par
#'
#' @export
st_extract_par <- function(lst_files, shp) {
    if (!is.list(lst_files)) lst_files = list(lst_files)
    file <- lst_files[[1]][1] # files[1]

    blocks <- overlap(file, shp, return.id = FALSE)
    parallel::clusterExport(cl, c("blocks"), environment())

    lst = plyr::llply(lst_files, function(files) {
        Ipaper::llply_par(files, function(file) { extract2::st_extract(file, blocks) })
    })
    lst
}
