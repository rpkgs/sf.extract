if (getRversion() < "3.3.0") {
  stop("Your version of R is too old. This package requires R-3.3.0 or newer on Windows.")
}

VERSION <- commandArgs(TRUE)
GDAL = sprintf("gdal2-%s", VERSION)

if (!file.exists(sprintf("../windows/gdal2-%s/include/gdal/gdal.h", VERSION))) {
  # url <- sprintf("https://github.com/rwinlib/gdal2/archive/v%s.zip", VERSION)
  url <- sprintf("https://gitlab.com/cug-hydro/gdal2/-/archive/v%s/gdal2-%s.zip", VERSION, VERSION)
  download.file(url, "lib.zip", quiet = FALSE)
  
  dir.create("../windows", showWarnings = FALSE)
  unzip("lib.zip", exdir = "../windows")
  status = file.rename(
    dir("../windows", full.names = TRUE), 
    paste0("../windows/", GDAL))
    
  unlink("lib.zip")
}
