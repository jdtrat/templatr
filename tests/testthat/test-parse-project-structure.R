demo_source_temp <- parse_proj_template(
  template_demo_project("demo-proj-source")
)

demo_temp <- parse_proj_template(
  template_demo_project("demo-proj")
)

test_that("`parse_project_structure()` works with 'demo-proj-source.yaml'", {
  parsed <- parse_project_structure(
    template_list = demo_source_temp
  )

  expected <- data.frame(
    stringsAsFactors = FALSE,
    name = c(
      ".Renviron", "README.md",
      "NEWS.md", "R/01_import_data.R", "R/02_clean_data.R",
      "R/03_model_data.R", "data", "R", "reports", "stan-files"
    ),
    source = c(
      "inst/templates/source-files/sample.Renviron", "inst/templates/source-files/README.md", NA,
      "inst/templates/source-files/R/temp_import_data.R",
      "inst/templates/source-files/R/temp_clean_data.R", NA, "inst/templates/source-files/data", NA,
      "inst/templates/source-files/reports", NA
    ),
    type = c(
      "file", "file", "file", "file",
      "file", "file", "directory", "directory", "directory",
      "directory"
    )
  )

  expect_equal(
    parsed[order(parsed$name), ],
    expected[order(expected$name), ],
    ignore_attr = TRUE
  )
})

test_that("`parse_project_structure()` works with 'demo-proj.yaml'", {
  parsed <- parse_project_structure(
    template_list = demo_temp
  )

  expected <- data.frame(
    stringsAsFactors = FALSE,
    name = c(
      "README.md",
      "R/01_import_data.R",
      "R/02_clean_data.R",
      "data/sample.csv",
      "R", "data", "reports", "stan-files"
    ),
    source = NA_character_,
    type = c(
      "file", "file", "file", "file",
      "directory", "directory", "directory", "directory"
    )
  )

  expect_equal(
    parsed[order(parsed$name), ],
    expected[order(expected$name), ],
    ignore_attr = TRUE
  )
})
