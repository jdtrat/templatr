# Tests modified from https://github.com/r-lib/usethis/blob/main/tests/testthat/test-directory.R


# create_source_directory -------------------------------------------------

test_that("`create_source_directory()` does not overwrite an existing directory", {
  tmp <- fs::file_temp()
  fs::dir_create(tmp)

  expect_true(
    fs::is_dir(tmp)
  )

  expect_false(
    create_source_directory(
      path = tmp,
      source = test_path("templates/reports/")
    )
  )

  expect_true(
    fs::is_dir(tmp)
  )
})

test_that("`create_source_directory()` does not overwrite a file", {
  tmp <- fs::file_temp()
  fs::file_create(tmp)

  expect_true(
    fs::is_file(tmp)
  )

  expect_error(
    create_source_directory(
      path = tmp,
      source = test_path("templates/reports/")
    )
  )

  expect_true(
    fs::is_file(tmp)
  )
})

test_that("`create_source_directory()` needs a valid source", {

  tmp <- fs::file_temp()

  expect_error(
    create_source_directory(
      path = tmp,
      source = "reports/"
    ),
    regexp = "does not exist"
  )

})

test_that("`create_source_directory()` copies a directory successfully", {
  tmp <- fs::file_temp()
  create_source_directory(
    path = tmp,
    source = test_path("templates/reports/")
  )

  expect_true(
    fs::is_dir(tmp)
  )

  expect_true(
    fs::file_exists(
      file.path(tmp, "01_intro.Rmd")
    )
  )
  expect_equal(
    readLines(file.path(tmp, "01_intro.Rmd")),
    readLines(
      test_path("templates/reports/01_intro.Rmd")
    )
  )
})


# create_file -------------------------------------------------------------

test_that("`create_file()` does not overwrite an existing file", {
  tmp <- fs::file_temp()
  fs::file_create(tmp)

  expect_true(
    fs::is_file(tmp)
  )

  expect_false(
    create_file(
      path = tmp
    )
  )

  expect_true(
    fs::is_file(tmp)
  )

})

test_that("`create_file()` creates a (blank) file successfully", {

  tmp <- fs::file_temp()
  fs::dir_create(tmp)

  create_file(
    path = file.path(tmp, "temp.R")
  )

  expect_true(
    fs::is_file(
      file.path(tmp, "temp.R")
    )
  )

  expect_equal(
    readLines(file.path(tmp, "temp.R")),
    character(0)
    )

})


# create_source_file ------------------------------------------------------

test_that("`create_source_file()` does not overwrite an existing file", {
  tmp <- fs::file_temp()
  fs::file_create(tmp)

  expect_true(
    fs::is_file(tmp)
  )

  expect_false(
    create_source_file(
      path = tmp,
      source = test_path("templates/R/temp_import_data.R")
    )
  )

  expect_true(
    fs::is_file(tmp)
  )
})

test_that("`create_source_file()` copies a file successfully", {
  tmp <- fs::file_temp()
  fs::dir_create(tmp)

  create_source_file(
    path = file.path(tmp, "01_import.data.R"),
    source = test_path("templates/R/temp_import_data.R")
  )

  expect_true(
    fs::is_file(
      file.path(tmp, "01_import.data.R")
    )
  )

  expect_true(
    fs::file_exists(
      file.path(tmp, "01_import.data.R")
    )
  )

  expect_equal(
    readLines(file.path(tmp, "01_import.data.R")),
    readLines(
      test_path("templates/R/temp_import_data.R")
    )
  )
})

