
# Adapted from usethis::use_description() and usethis::use_description_defaults()
description_defaults <- function(project_name) {
  list(
    Project = project_name,
    Title = "What's the Purpose of this Project (One Line, Title Case)",
    Description = "What's the purpose of the package (one paragraph).",
    `Authors@R` =
      'c(
  person(
    given = "First",
    family = "Last",
    email = "first.last@example.com",
    role = c("aut", "cre"),
    comment = c(ORCID = "YOUR-ORCID-ID")
    )
  )',
  License = "`use_mit_license()`, `use_gpl3_license()` or friends to pick a license",
  Encoding = "UTF-8"
  )
}

use_templatr_description <- function(project_name) {
  fields <- description_defaults(project_name = project_name)
  desc <- desc::desc(text = glue::glue("{names(fields)}: {fields}"))
  tf <- withr::local_tempfile(
    pattern = glue::glue("use_description-{project_name}-")
  )
  desc$write(file = tf)
  tf_contents <- readLines(tf, encoding = "UTF-8")

  usethis::write_over(
    usethis::proj_path("DESCRIPTION"),
    tf_contents
  )
}



