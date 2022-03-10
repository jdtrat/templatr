
parse_proj_template <- function(template) {

  parse_template_handlers <- list(
    `source` = function(x) {
      paste0("!source ", x)
    },
    `source_expr` = function(x) {
      paste0("!source_expr ", x)
    }
  )

  if (fs::is_file(template)) {
    yaml::yaml.load_file(
      input = template,
      eval.expr = FALSE,
      handlers = parse_template_handlers
    )
  } else if (is.character(template)) {
    yaml::yaml.load(
      string = template,
      eval.expr = FALSE,
      handlers = parse_template_handlers
    )
  } else {
   cli::cli_abort(
     "{.arg template} must be a file path or character string."
     )
  }

}

parse_proj_directories <- function(template_list) {
  # Only first name in case we add future param options
  do.call(c, lapply(template_list$project$structure, function(x) names(x)[1]))
}

parse_proj_files <- function(template_list) {
  # Paste any directory names with file names
  file_names <- do.call(
    c,
    lapply(
      template_list$project$structure, function(x) {
        paste0(names(x), "/", x[[1]])
      }
    )
  )
  # Clean any files at the top level directory
  file_names <- gsub("^\\/", "", file_names)
  # Remove any empty directories from file names
  file_names <- file_names[which(!grepl("\\/$", file_names))]
  file_names
}


#' Parse Project File Structure
#'
#' @param template_list The parsed template from [parse_proj_template()].
#'
#' @return A data frame with three columns 'name', 'source', and 'type'
#'   referring to the name of the folder/file to be created, the source of the
#'   folder/file (or NA if none provided), and the type ('folder' or 'file').
#'   files.
#' @keywords internal
#' @noRd
parse_proj_file_structure <- function(template_list) {

  # Parse the file names with ' - source = ' to return a list with character
  # vectors of length one or two.
  file_names <- strsplit(
    parse_proj_files(template_list = template_list),
    split = " - !source| -!source"
  )

  # Create data frame for file structures with 'source' = NA as appropriate
  do.call(
    rbind,
    lapply(
      file_names,
      function(x) {
        if (length(x) == 1) {
          info <- c(x, NA_character_)
        } else if (length(x) == 2) {
          info <- x
        } else {
          cli::cli_abort("Please check file input structure.")
        }

        data.frame(
          name = info[1],
          source = info[2],
          type = "file"
        )
      }
    )
  )
}


#' Parse Project Directory Structure
#'
#' @param file_structure The data frame of the initial file structure parsing,
#'   output from [parse_proj_file_structure()].
#' @param directories A character vector of directories (e.g., the output of
#'   [parse_proj_directories()]).
#' @param source_folder_indices A numeric vector with indices corresponding to
#'   the rows of `file_structure` that correspond to the directories with
#'   'source = '.
#'
#' @return A data frame with three columns 'name', 'source', and 'type'
#'   referring to the name of the folder/file to be created, the source of the
#'   folder/file (or NA if none provided), and the type ('folder' or 'file').
#'   files.
#' @keywords internal
#' @noRd
#'
parse_proj_dir_structure <- function(file_structure,
                                     directories,
                                     source_folder_indices) {

  # Combine the parsed directories and those included in initial file structure,
  # splitting the latter ones by '/source = ' to return a list with character
  # vectors of length one or two.
  dir_names <- strsplit(
    c(
      directories,
      file_structure[source_folder_indices, ]$name
    ),
    "/!source"
  )

  # Create initial data frame for directories with 'source' = NA as appropriate
  initial_dir_df <- do.call(
    rbind,
    lapply(
      dir_names,
      function(x) {
        if (length(x) == 1) {
          info <- c(x, NA_character_)
        } else if (length(x) == 2) {
          info <- x
        } else {
          cli::cli_abort("Please check file input structure.")
        }

        data.frame(
          name = info[1],
          source = info[2],
          type = "directory"
        )
      }
    )
  )

  # Because initial_dir_df may have repeated directory rows, this returns one
  # row per directory with the correct source if applicable
  do.call(
    rbind,
    lapply(
      split(initial_dir_df, as.factor(initial_dir_df$name)),
      function(entry) {
        if (nrow(entry) == 1) {
          entry
        } else {
          entry[!is.na(entry$source), ]
        }
      }
    )
  )
}

# Wrap the source column for expressions
wrap_source <- function(source_column) {
  expr_indices <- grep("^_expr", source_column)

  if (identical(expr_indices, integer(0))) {
    return(
      source_column
    )
  } else {
    c(
      source_column[-expr_indices],
      paste0(
        "expression(",
        trimws(
          gsub("_expr", "", source_column[expr_indices])
        ),
        ")"
      )
    )
  }

}
