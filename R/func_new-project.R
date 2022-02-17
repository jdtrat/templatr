
# Utility function, returns character from project structure with info needed to create files/directories
which_to_create <- function(proj_structure, type) {
  proj_structure[proj_structure$type == type & is.na(proj_structure$source), ]$name
}

# Utility function, returns data frame from project structure with info needed to copy files/directories
which_to_copy <- function(proj_structure, type) {
  proj_structure[proj_structure$type == type & !is.na(proj_structure$source), ]
}

#' Create New Project
#'
#' @param path A file path for where the new project should be created.
#' @param template The path to a YAML file containing the project structure.
#' @param rstudio Logical indicating whether RStudio should be used for the new
#'   project. By default, it detects if RStudio is currently running and, if
#'   `TRUE`, then [usethis::use_rstudio] is called to make an [RStudio
#'   Project](https://support.rstudio.com/hc/en-us/articles/200526207-Using-RStudio-Projects).
#'    If `FALSE`, then a `.here` file is places in the directory so it can be
#'   recognized within a project-oriented workflow via
#'   [here](https://here.r-lib.org) and
#'   [rprojroot](https://rprojroot.r-lib.org).
#' @param open Logical indicating whether the new project should be opened. By
#'   default, it checks whether the function is run interactively with
#'   [rlang::is_interactive]. If `TRUE`, the new project is activated and
#'   opened. If `FALSE`, the working directory and active project are unchanged.
#'
#' @return Path to the newly created project (invisibly).
#' @export
#'
#' @examples
#' \dontrun{
#' # Bare bones project with no existing content
#' new_project(
#'   path = "~/Desktop/templatr-demo/",
#'   template = template_demo_project()
#' )
#' # Project with files that have some structure
#' new_project(
#'   path = "~/Desktop/templatr-demo/",
#'   template = template_demo_project("demo-proj-source")
#' )
#' }
#'
new_project <- function(path, template,
                        rstudio = rstudioapi::isAvailable(),
                        open = rlang::is_interactive()) {
  cur_dir <- getwd()
  template <- parse_proj_template(template)

  project_structure <- parse_project_structure(
    template_list = template
  )

  # Replaced tilde expansion for user's home directory
  path <- fs::path_expand(path)
  # Returns the filename portion of the absolute path
  name <- fs::path_file(fs::path_abs(path))

  if (name != template$project$name && rlang::is_interactive()) {
    usethis::ui_info("Path does not match YAML-supplied project name.")
    if (usethis::ui_yeah("Should the project be called {usethis::ui_value(template$project$name)} as specified in the template?")) {
      path <- fs::path(fs::path_dir(path), template$project$name)
    } else {
      if (usethis::ui_nope("Should the project be called {usethis::ui_value(name)} as specified via the path argument?")) {
        usethis::ui_stop("Canceling project creation.")
      }
    }
  } else if (name != template$project$name && rlang::is_interactive()) {
    path <- fs::path(fs::path_dir(path), template$project$name)
  }

  challenge_nested_project(fs::path_dir(path), name)
  challenge_home_directory(path)

  create_directory(path)
  usethis::local_project(path, force = TRUE)

  if (!"DESCRIPTION" %in% project_structure$name) {
    use_templatr_description(project_name = template$project$name)
  }

  dirs_to_create <- which_to_create(project_structure, "directory")
  dirs_to_copy <- which_to_copy(project_structure, "directory")

  for (i in seq_along(dirs_to_create)) usethis::use_directory(dirs_to_create[i])
  if (nrow(dirs_to_copy) > 0) {
    for (i in 1:nrow(dirs_to_copy)) {
      use_source_directory(
        path = dirs_to_copy$name[i],
        source = fs::path_abs(
          dirs_to_copy$source[i],
          start = cur_dir
        )
      )
    }
  }

  files_to_create <- which_to_create(project_structure, "file")
  files_to_copy <- which_to_copy(project_structure, "file")

  for (i in seq_along(files_to_create)) use_file(files_to_create[i])

  if (nrow(files_to_copy) > 0) {
    for (i in 1:nrow(files_to_copy)) {
      use_source_file(
        path = files_to_copy$name[i],
        source = fs::path_abs(
          files_to_copy$source[i],
          start = cur_dir
        )
      )
    }
  }

  if (rstudio) {
    usethis::use_rstudio()
  } else {
    usethis::ui_done("Writing a sentinel file {usethis::ui_path('.here')}")
    usethis::ui_todo("Build robust paths within your project via {usethis::ui_code('here::here()')}")
    usethis::ui_todo("Learn more at <https://here.r-lib.org>")
    fs::file_create(usethis::proj_path(".here"))
  }

  if (open) {
    if (usethis::proj_activate(usethis::proj_get())) {
      withr::deferred_clear()
    }
  }

  invisible(usethis::proj_get())
}

# Adapted from usethis test helper:
# https://github.com/r-lib/usethis/blob/57b109ab1e376d8fbf560e7e6adc19e0a04c5edd/tests/testthat/helper.R#L28
create_local_new_project <- function(dir = fs::file_temp("testproj"),
                                     template = template_demo_project(),
                                     env = parent.frame(),
                                     rstudio = FALSE) {
  if (fs::dir_exists(dir)) {
    usethis::ui_stop("Target {usethis::uicode('dir')} {usethis::uipath(dir)} already exists.")
  }


  old_project <- proj_get_() # this could be `NULL`, i.e. no active project
  old_wd <- getwd() # not necessarily same as `old_project`

  withr::defer(
    {
      usethis::ui_done("Deleting temporary project: {usethis::ui_path(dir)}")
      fs::dir_delete(dir)
    },
    envir = env
  )
  usethis::ui_silence(
    new_project(path = dir, template = template, rstudio = rstudio, open = FALSE)
  )

  withr::defer(usethis::proj_set(old_project, force = TRUE), envir = env)
  usethis::proj_set(dir)

  withr::defer(
    {
      usethis::ui_done("Restoring original working directory: {usethis::ui_path(old_wd)}")
      setwd(old_wd)
    },
    envir = env
  )
  setwd(usethis::proj_get())

  invisible(usethis::proj_get())
}
