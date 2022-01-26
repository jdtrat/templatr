test_that("new_project() creates a project", {
  dir <- create_local_new_project()
  proj_contents <- fs::dir_ls(dir, recurse = TRUE)
  # Get project contents
  proj_contents <- gsub(paste0(fs::path_dir(proj_contents[1]), "/"),
                        replacement = "", proj_contents)
  expect_equal(as.character(proj_contents),
               c("R", "R/01_import_data.R", "R/02_clean_data.R", "README.md",
                 "data", "data/sample.csv", "reports", "stan-files")
               )
  expect_true(possibly_in_proj(dir))
})
