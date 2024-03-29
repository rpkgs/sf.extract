% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/st_extract.R
\name{st_extract}
\alias{st_extract}
\alias{st_extract,RasterLayer-method}
\alias{st_extract,RasterStack-method}
\alias{st_extract,RasterBrick-method}
\alias{st_extract,SpatRaster-method}
\alias{st_extract,list-method}
\alias{st_extract,character-method}
\alias{extract2}
\title{Get zonal statistics from raster}
\usage{
\S4method{st_extract}{RasterLayer}(r, geoms, fun = sf_mean, weight = TRUE, ...)

\S4method{st_extract}{RasterStack}(r, geoms, fun = sf_mean, weight = TRUE, ...)

\S4method{st_extract}{RasterBrick}(r, geoms, fun = sf_mean, weight = TRUE, ...)

\S4method{st_extract}{SpatRaster}(r, geoms, fun = sf_mean, weight = TRUE, ...)

\S4method{st_extract}{list}(r, geoms, fun = sf_mean, weight = TRUE, ...)

\S4method{st_extract}{character}(r, geoms, fun = sf_mean, weight = TRUE, ...)

st_extract(r, geoms, ...)
}
\arguments{
\item{r}{Raster, RasterBrick or character (raster paths) object}

\item{geoms}{WKB, sf or sf Spatial object,
e.g. \code{sf::st_as_binary(sf::st_geometry(basins), EWKB=TRUE)}.}

\item{fun}{one of \code{\link[=sf_mean]{sf_mean()}}, \code{\link[=sf_median]{sf_median()}}, \code{\link[=sf_sum]{sf_sum()}}, \code{\link[=sf_sd]{sf_sd()}}, \code{\link[=sf_var]{sf_var()}}}

\item{weight}{boolean. If true, \code{fraction = fraction * area}}

\item{...}{other parameters to \code{fun}}
}
\description{
Get zonal statistics from raster
}
\note{
\code{extract2} was renamed to \code{st_extract}
}
\examples{
\dontrun{
library(terra)
library(sf.extract)

## 0. load data
# raster files
files <- system.file("raster/PML2_yearly_static2017-01-01_2deg.tif", package = "sf.extract")
# shape files
file_shp <- system.file("shp/Continents.shp", package = "sf.extract")

r = rast(files[1])

st <- sf::read_sf(file_shp)
shp <- sf::as_Spatial(st)
wkbs <- sf::st_as_binary(sf::st_geometry(st), EWKB = TRUE) \%>\% set_names(st[[1]])
blocks <- sf.extract::overlap(r, wkbs)

## 1. test for different poly obj
r1 = st_extract(files, st)  # sf obj
r2 = st_extract(files, shp) # Spatial obj

## 2. test for different `st_` functions
st_extract(files, blocks, fun = sf_median)
st_extract(files, blocks, fun = sf_sd)
st_extract(files, blocks, fun = sf_sum) # no colnames
st_extract(files, blocks, fun = sf_sum, weight = TRUE)
st_extract(files, blocks, fun = sf_var, weight = TRUE)

}
}
\seealso{
\code{\link[=sf_func]{sf_func()}}
}
