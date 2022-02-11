#' Parse Project Structure
#'
#' @param template_list The parsed template from [parse_proj_template()].
#'
#' @return A data frame with three columns 'name', 'source', and 'type'
#'   referring to the name of the folder/file to be created, the source of the
#'   folder/file (or NA if none provided), and the type ('folder' or 'file').
#'   files.
#' @keywords internal
#' @noRd
#'
parse_project_structure <- function(template_list) {

  # Get directories from YAML file (anything with a colon)
  dirs <- parse_proj_directories(template_list = template_list)

  # Get a character vector of the files
  files <- parse_proj_files(template_list = template_list)

  # Get indices for which of the directories have 'source = '
  dirs_with_source_folders <- do.call(c,
                                      lapply(
                                        paste0(dirs, "/source = "),
                                        function(x) {grep(x, files)}
                                      )
  )

  # Get a data frame with the initial file structure of the project
  file_struc <- parse_proj_file_structure(
    template_list = template_list
  )

  # Return initial dataframe with directory structures
  dir_struc <- parse_proj_dir_structure(
    file_structure = file_struc,
    directories = dirs,
    source_folder_indices = dirs_with_source_folders
  )

  # If there are no directories with source folders,
  # returning file_struc[-integer(0),] won't work
  if (identical(dirs_with_source_folders, integer(0))) {
    rbind(file_struc,
          dir_struc)
  } else {
    rbind(
      file_struc[-dirs_with_source_folders,],
      dir_struc
    )
  }

}
