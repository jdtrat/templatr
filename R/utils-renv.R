
init_quietly <- function(...) {
  x <- capture.output(
    suppressMessages(
      renv::init(...)
    )
  )
}

snapshot_quietly <- function(...) {
  x <- capture.output(
    suppressMessages(
      renv::snapshot(...)
    )
  )
}

has_renv_lock <- function() {
  pt <- fs::file_exists(
    fs::path_abs("renv.lock")
  )
}


#' If renv is initialized, what packages are in the 'renv.lock'?
#'
#' @return A character vector of packages recorded in 'renv.lock' or "None".
#' @export
#'
#' @examples
#' lockfile_pkgs()
lockfile_pkgs <- function() {
  rlang::check_installed("jsonlite")
  if (has_renv_lock()) {
    sort(
      names(
        jsonlite::read_json(
          fs::path_abs("renv.lock")
        )$Packages
      )
    )
  } else {
    "None"
  }
}

#' Initialize renv with explicit dependencies
#'
#' @description `use_renv()` initializes an renv package envrionment for a
#'   project with explicit dependencies. This means that it will only include
#'   packages and their dependencies that are included in a project's
#'   `DESCRIPTION` file.
#'
#' @param path Project path
#' @param restart Logical: should the R session be restarted after initializing
#'   the project?
#'
#' @return The project path where the renv environment was initialized,
#'   invisibly.
#' @export
use_renv <- function(
  path = usethis::proj_get,
  restart = rlang::is_interactive()
) {
  rlang::check_installed("renv")

  if (!fs::file_exists("DESCRIPTION")) {
    cli::cli_abort(
      "{.path DESCRIPTION} file needed to initialize renv environment explicitly."
      )
  }

  cli::cli_alert_success("Initializing {.pkg renv}")
  init_quietly(
    project = path,
    settings = list(snapshot.type = "explicit"),
    restart = restart
  )

  snapshot_quietly(
    project = path,
    prompt = FALSE
    )

  usethis::ui_done("Adding the following packages to
                   {usethis::ui_path('renv.lock')}: {usethis::ui_value(lockfile_pkgs())}")

  invisible(path)
}

