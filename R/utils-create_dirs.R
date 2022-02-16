# Adapted from `usethis:::create_directory()`
create_source_directory <- function(path, source) {
  if (fs::dir_exists(path)) {
    return(invisible(FALSE))
  } else if (fs::file_exists(path)) {
    usethis::ui_stop("{usethis::ui_path(path)} exists but is not a directory.")
  } else if (!fs::dir_exists(source)) {
    usethis::ui_stop("{usethis::ui_path(source)} does not exist.")
  }
  fs::dir_copy(
    path = source,
    new_path = path,
    overwrite = FALSE
  )
  usethis::ui_done("Copying {usethis::ui_path(source)} to {usethis::ui_path(path)}")
  invisible(TRUE)
}

use_source_directory <- function(path, source, ignore = FALSE) {
  create_source_directory(
    path = usethis::proj_path(path),
    source = source
  )

  if (ignore) {
    usethis::use_build_ignore(path)
  }
  invisible(TRUE)
}
