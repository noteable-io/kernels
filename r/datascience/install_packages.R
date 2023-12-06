packages <- readLines("/tmp/requirements.R")

# Function to check if a package is installed
is_package_installed <- function(package) {
  return(package %in% rownames(installed.packages()))
}

# Install packages with error handling
for (pkg in packages) {
  tryCatch({
      # Attempt to install the package
      install.packages(pkg, repos='http://cran.us.r-project.org')
      
      # Check if installation was successful, otherwise raise error
      if (!is_package_installed(pkg)) {
        stop(paste("⛔ Installation of package", pkg, "failed."))
      } else {
        message(paste("✅ Package", pkg, "installed successfully."))
      }
    }, 
    error = function(e) {
      # Handle errors: print error message
      stop(paste("🔥 Error installing package", pkg, ":", e$message))
    }
  )
}
