
parse_proj_template <- function(template) {
  yaml::read_yaml(file = template)
}

parse_proj_directories <- function(template_list) {
  # Only first name in case we add future param options
  do.call(c, lapply(template_list$project$structure, function(x) names(x)[1]))
}

parse_proj_files <- function(template_list) {
  # Paste any directory names with file names
  file_names <- do.call(c,
                        lapply(
                          template_list$project$structure, function(x) {
                            paste0(names(x), "/", x[[1]])
                          })
  )
  # Clean any files at the top level directory
  file_names <- gsub("^\\/", "", file_names)
  # Remove any empty directories from file names
  file_names <- file_names[which(!grepl("\\/$", file_names))]
  file_names
}
