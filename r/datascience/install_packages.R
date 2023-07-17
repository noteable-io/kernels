packages <- readLines("/tmp/requirements.R")
install.packages(packages, repos='http://cran.us.r-project.org')
