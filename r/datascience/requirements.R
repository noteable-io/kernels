# *** If you add any packages to this file, be sure to test their installation in the dockerfile before the `RUN R -e "source('/tmp/install_packages.R')"` line. ***
# e.g. `RUN R -e "install.packages('NEW_PACKAGE', repos = 'http://cran.us.r-project.org')"
# This should make it easier to determine if any other dependencies are required and should result in less time spent waiting for the docker build to (possibly) fail.
arrow
caret
crayon
# ragg/pkgdown are required for devtools but not installed automatically
ragg
pkgdown
devtools
dplyr
e1071
forecast
ggplot2
ggpubr
hexbin
htmltools
htmlwidgets
nycflights13
odbc
randomForest
RCurl
rgdal
rmarkdown
RODBC
RSQLite
shiny
tidymodels
tidyverse
