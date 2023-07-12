library(IRdisplay)
library(repr)
library(reticulate)

prepare_dex_content <- function(df) {
  #'
  #' Create schema and data structure for data frame to be rendered by DEX
  #'

  # create a schema for a dataframe, which DEX uses to determine column dtypes.
  # R data frames don't have this functionality, so we have to use reticulate
  # to call into the python pandas library
  pandas <- import("pandas")

  # If df is a matrix, convert it to a data frame
  if (is.matrix(df)) {
    # In R, a matrix is a 2D vector, not a data frame. When reticulate converts an R matrix to Python,
    # it becomes a numpy array, not a pandas DataFrame. The pandas function we're using requires a DataFrame,
    # so we need to convert the matrix to a data frame first.
    #
    # We use stringsAsFactors = FALSE to prevent R from converting strings to factors. This is a feature of R
    # that can be confusing for people used to Python, where there's no direct equivalent of factors.
    #
    # We use row.names = FALSE to prevent R from using the first column of the data as row names. This is
    # because R matrices don't have row names in the same way that data frames do, and we want to keep the
    # structure of the data consistent when we convert it to a DataFrame.
    df <- as.data.frame(df, stringsAsFactors = FALSE, row.names = FALSE)
  }
  df_py <- r_to_py(df)
  schema <- pandas$io$json$build_table_schema(df_py, index=FALSE)

  # vectorized format (list of lists)
  #data = as.matrix.data.frame(t(df))
  # pandas df.to_dict("records") format
  data = as.data.frame.list(df)

  list(
    schema = schema,
    data = data
  )
}

prepare_dex_metadata <- function(df) {
  #'
  #' Create metadata for data frame to be rendered by DEX
  #'
  list(
    default_index_used=TRUE,
    dataframe_info = list(
      orig_num_rows = dim(df)[0],
      orig_num_cols = dim(df)[1]
    )
  )
}

repr_dex <- function(obj, ...) {
  if (is(obj, "data.frame") || is(obj, "matrix")) {
    data <- prepare_dex_content(obj)
    metadata <- prepare_dex_metadata(obj)
    bundle_data <- list("application/vnd.dataresource+json"=data)
    bundle_metadata <- list("application/vnd.dataresource+json"=metadata)
    # we could use publish_mimebundle() to provide the data and metadata,
    # but that doesn't return anything, which triggers repr_html/repr_markdown, etc
    #publish_mimebundle(bundle_data, metadata=bundle_metadata)
    return(data)
  } else {
    # if it's not a matrix or data.frame, return NULL to let other repr_* functions handle it.
    return(NULL)
  }
}

enable_dex_formatter <- function() {
  # Add custom display formatter to newly added mimetype
  IRkernel:::replace_in_package('repr', 'mime2repr', c(repr::mime2repr, list(`application/vnd.dataresource+json` = repr_dex)))

  # Add dataresource mimetype to list of recognized mimetypes
  mimetypes <- c(getOption('jupyter.display_mimetypes'), "application/vnd.dataresource+json")
  options(jupyter.display_mimetypes = mimetypes)

  # Register custom formatter for matrix and data.frame
  registerS3method("repr_html", "matrix", repr_dex)
  registerS3method("repr_html", "data.frame", repr_dex)
}

disable_dex_formatter <- function() {
  # Remove custom display formatter
  IRkernel:::replace_in_package('repr', 'mime2repr', repr::mime2repr)

  # Remove dataresource mimetype from list of recognized mimetypes
  mimetypes <- setdiff(getOption('jupyter.display_mimetypes'), "application/vnd.dataresource+json")
  options(jupyter.display_mimetypes = mimetypes)

  # Reset the formatter for matrix and data.frame to the default
  registerS3method("repr_html", "matrix", repr:::repr_html.matrix)
  registerS3method("repr_html", "data.frame", repr:::repr_html.data.frame)
}

# enable by default
enable_dex_formatter()
