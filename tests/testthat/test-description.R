# Adapted from https://github.com/r-lib/usethis/blob/main/tests/testthat/test-description.R

test_that("`description_defaults()` works", {
  d <- description_defaults(
    project_name = "Project name"
      )

  expect_equal(d$Project, "Project name")
  expect_equal(d$Title, "What's the Purpose of this Project (One Line, Title Case)")
  expect_equal(d$Description, "What's the purpose of the package (one paragraph).")
  expect_equal(d$`Authors@R`,
               "c(\n  person(\n    given = \"First\",\n    family = \"Last\",\n    email = \"first.last@example.com\",\n    role = c(\"aut\", \"cre\"),\n    comment = c(ORCID = \"YOUR-ORCID-ID\")\n    )\n  )"
               )
  expect_equal(d$License, "`use_mit_license()`, `use_gpl3_license()` or friends to pick a license")
  expect_equal(d$Encoding, "UTF-8")

})

test_that("`check_pkg_type()` works", {

  expect_equal(
    check_pkg_type(c("dplyr", "targets",
                     "jdtools", "jdtrat/jdtools",
                     "shinysurveys", "ghee")
    ),
    c("standard", "standard", "github", "github",
      "standard", "standard"),
    ignore_attr = TRUE # ignore names
  )
})
