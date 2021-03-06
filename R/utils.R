challenge_nested_project <- utils::getFromNamespace("challenge_nested_project", "usethis")
challenge_home_directory <- utils::getFromNamespace("challenge_home_directory", "usethis")
create_directory <- utils::getFromNamespace("create_directory", "usethis")
proj_get_ <- utils::getFromNamespace("proj_get_", "usethis")
possibly_in_proj <- utils::getFromNamespace("possibly_in_proj", "usethis")

# Modified from `usethis:::create_directory()`
create_file <- function(path) {
  if (fs::file_exists(path)) {
    return(invisible(FALSE))
  }
  fs::file_create(path)
  usethis::ui_done("Creating {usethis::ui_path(path)}")
  invisible(TRUE)
}

use_file <- function(path, ignore = FALSE) {
  create_file(usethis::proj_path(path))
  if (ignore) {
    usethis::use_build_ignore(path)
  }
  invisible(TRUE)
}

has_file_ext <- function(path) {
  vapply(path, function(x) {
    if (fs::path_ext(x) != "") TRUE else FALSE
  }, FUN.VALUE = logical(1))
}

#' Returns File Path for Demo Project Template
#'
#' @param name (Optional) name to specify the template file path. Defaults to
#'   'demo-proj' template.
#' @return Path to Template YAML file
#' @export
#'
#' @examples
#' cat(readLines(template_demo_project()), sep = "\n")
template_demo_project <- function(name = "demo-proj") {
  system.file(paste0("templates/yaml-files/", name, ".yaml"),
    package = "templatr"
  )
}
