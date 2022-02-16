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

create_source_file <- function(path, source) {
  if (fs::file_exists(path)) {
    return(invisible(FALSE))
  }
  fs::file_copy(
    path = source,
    new_path = path,
    overwrite = FALSE
  )
  usethis::ui_done("Copying {usethis::ui_path(source)} to {usethis::ui_path(path)}")
  invisible(TRUE)
}

use_source_file <- function(path, source, ignore = FALSE) {
  create_source_file(
    path = usethis::proj_path(path),
    source = source
  )

  if (ignore) {
    usethis::use_build_ignore(path)
  }
  invisible(TRUE)
}
