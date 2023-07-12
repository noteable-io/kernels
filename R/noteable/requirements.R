install.packages('reticulate', repos='http://cran.us.r-project.org')
library(reticulate)
# Python packages to be used in R via reticulate
# ref: https://rstudio.github.io/reticulate/articles/python_packages.html
py_install('pandas==1.5.3', pip=TRUE)
