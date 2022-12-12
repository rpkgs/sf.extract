#' st_extract_par
#'
#' @export
st_extract_par <- function(lst_files, shp) {
    if (!is.list(lst_files)) lst_files = list(lst_files)
    f <- lst_files[[1]][1]

    blocks <- overlap(f, shp, return.data = FALSE)
    
    cl = options("cl")
    parallel::clusterExport(cl, c("blocks"), environment())

    lst = plyr::llply(lst_files, function(files) {
        Ipaper::llply_par(files, function(file) { sf.extract::st_extract(file, blocks) })
    })
    lst
}
