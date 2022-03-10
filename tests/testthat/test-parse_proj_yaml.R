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
    parse_proj_template(
      template_demo_project()
    )
  )
})

test_that("`parse_proj_directories` works", {
  expect_equal(
    parse_proj_directories(demo_proj),
    c("R", "data", "stan-files", "reports")
  )
})

test_that("`parse_proj_files` works", {
  expect_equal(
    parse_proj_files(demo_proj),
    c("README.md", "R/01_import_data.R", "R/02_clean_data.R", "data/sample.csv")
  )
})

test_that("`parse_proj_file_structure` works", {
  expect_equal(
    parse_proj_file_structure(demo_proj),
    data.frame(
      name = c("README.md", "R/01_import_data.R", "R/02_clean_data.R", "data/sample.csv"),
      source = NA_character_,
      type = "file"
    )
  )

  expect_equal(
    parse_proj_file_structure(
      template_list = parse_proj_template(
        template_demo_project("demo-proj-source")
      )
    ),
    data.frame(
      stringsAsFactors = FALSE,
      name = c(".Renviron","README.md",
               "NEWS.md","R/01_import_data.R","R/02_clean_data.R",
               "R/03_model_data.R",
               "data/!source = \"inst/templates/source-files/data\"",
               "reports/!source = \"inst/templates/source-files/reports\""),
      source = c(" = \"inst/templates/source-files/sample.Renviron\"",
                 " = \"inst/templates/source-files/README.md\"",NA,
                 " = \"inst/templates/source-files/R/temp_import_data.R\"",
                 " = \"inst/templates/source-files/R/temp_clean_data.R\"",NA,NA,NA),
      type = c("file","file","file","file",
               "file","file","file","file")
    )
  )
})
