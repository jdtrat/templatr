demo_proj <- list(
  project = list(
    name = "templatr-demo",
    structure = list(
      "README.md", list(
        R = c(
          "01_import_data.R",
          "02_clean_data.R"
        )
      ), list(data = "sample.csv"),
      list(`stan-files` = NULL),
      list(reports = NULL)
    ),
    `git-ignore` = c(
      "data",
      "R/01_import_data.R"
    )
  )
)

test_that("`parse_proj_temmplate` works", {
  expect_snapshot(
    parse_proj_template(template_demo_project())
  )
})

test_that("`parse_proj_directories` works", {
  expect_equal(parse_proj_directories(demo_proj),
               c("R", "data", "stan-files", "reports"))
})

test_that("`parse_proj_files` works", {
  expect_equal(
    parse_proj_files(demo_proj),
    c("README.md", "R/01_import_data.R", "R/02_clean_data.R", "data/sample.csv")
  )
})
