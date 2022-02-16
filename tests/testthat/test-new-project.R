test_that("new_project() creates a project - demo template", {
  dir <- create_local_new_project()
  proj_contents <- fs::dir_ls(dir, recurse = TRUE)
  # Get project contents
  proj_contents <- gsub(paste0(fs::path_dir(proj_contents[1]), "/"),
    replacement = "", proj_contents
  )
  expect_equal(
    as.character(proj_contents),
    c(
      "R", "R/01_import_data.R", "R/02_clean_data.R", "README.md",
      "data", "data/sample.csv", "reports", "stan-files"
    )
  )
  expect_true(possibly_in_proj(dir))
})

test_that("new_project() creates a project - source template", {

  # Read initial templates
  import_data_contents <- readLines(
    test_path("templates/R/temp_import_data.R")
  )
  clean_data_contents <- readLines(
    test_path("templates/R/temp_clean_data.R")
  )
  data_file_contents <- readLines(
    test_path("templates/data/head_mtcars.csv")
  )
  report_file_conents <- readLines(
    test_path("templates/reports/01_intro.Rmd")
  )

  # Create project

  dir <- create_local_new_project(
    template = test_path("templates/proj-source.yaml")
  )
  proj_contents <- fs::dir_ls(dir, recurse = TRUE)
  # Get project contents
  proj_contents <- gsub(paste0(fs::path_dir(proj_contents[1]), "/"),
                        replacement = "", proj_contents
  )

  expect_equal(
    as.character(proj_contents),
      c(
        "NEWS.md", "R", "R/01_import_data.R", "R/02_clean_data.R",
        "R/03_model_data.R", "data", "data/head_mtcars.csv",
        "reports", "reports/01_intro.Rmd", "stan-files"
      )
    )

  # Ensure created project contents and original source are equal
  expect_equal(
    readLines(
      file.path(dir, "R/01_import_data.R")
    ),
    import_data_contents
  )

  expect_equal(
    readLines(
      file.path(dir, "R/02_clean_data.R")
    ),
    clean_data_contents
  )

  expect_equal(
    readLines(
      file.path(dir, "data/head_mtcars.csv")
    ),
    data_file_contents
  )

  expect_equal(
    readLines(
      file.path(dir, "reports/01_intro.Rmd")
    ),
    report_file_conents
  )

})
