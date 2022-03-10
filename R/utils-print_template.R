
colorize_fs <- function(x, source = FALSE) {

  if (inherits(x, "fs_path") || inherits(x, "character")) {

    if (fs::is_file(x)) {
      col <- crayon::green(x)
    } else if (fs::is_dir(x)) {
      col <- crayon::blue(paste0(x, "/"))
    }
    if (source) {
      crayon::italic(col)
    } else {
      crayon::bold(col)
    }
  } else if (inherits(x, "data.frame")) {
    if (x$type == "file") {
      col <- crayon::green(x$name)
    } else if (x$type == "directory") {
      col <- crayon::blue(paste0(x$name, "/"))
    }
    if (source) {
      crayon::italic(col)
    } else {
      crayon::bold(col)
    }
  }
}

dir_needs_printing <- function(dir_list, index) {
  dir <- dir_list[which(names(dir_list) == dir_list$.[index,]$name)]
  if (length(dir) == 0) {
    invisible()
  } else {
    names(dir)
  }
}

# From fs:::pc
pc <- function(...) paste0(..., collapse = "")

# from fs:::is_latex_output
is_latex_output <- function ()
{
  if (!("knitr" %in% loadedNamespaces()))
    return(FALSE)
  get("is_latex_output", asNamespace("knitr"))()
}

# from fs:::is_utf8_output
is_utf8_output <- function ()
{
  opt <- getOption("cli.unicode", NULL)
  if (!is.null(opt)) {
    isTRUE(opt)
  }
  else {
    l10n_info()$`UTF-8` && !is_latex_output()
  }
}

# From fs:::box_chars
box_chars <- function ()
{
  if (is_utf8_output()) {
    list(
      "h" = "\u2500",                   # horizontal
      "v" = "\u2502",                   # vertical
      "l" = "\u2514",
      "j" = "\u251C"
    )
  }
  else {
    list(h = "-", v = "|", l = "\\", j = "+")
  }
}

print_template <- function(template, show_source = TRUE) {
  proj_struc <- parse_project_structure(template)
  proj_struc$top <- fs::path_dir(proj_struc$name)
  proj_struc <- proj_struc[order(proj_struc$name),]
  dirs <- split(proj_struc, as.factor(proj_struc$top))
  ch <- box_chars()


  print_source <- function(entry, indent = " ", show_source = TRUE) {
    if (is.na(entry$source) | !show_source) {
      invisible()
    } else if (show_source) {
      pc("\n", indent, ch$l, ch$h, crayon::italic(paste0(" source: ", entry$source)))
    }
  }

  for (i in 1:nrow(dirs$.)) {
    if (i == 1) cat(colorize_fs("."), "\n", sep = "")
    cur_dir <- dir_needs_printing(dirs, i)
    if (is.null(cur_dir)) {
      cat(pc(ch$j, ch$h, ch$h, " ", colorize_fs(dirs$.[i,])),
          print_source(dirs$.[i,], show_source = show_source),
          "\n", sep = "")
    } else if (!is.null(cur_dir)) {
      printing_dir <- dirs[[cur_dir]]
      cat(pc(ch$j, ch$h, ch$h, " ", colorize_fs(dirs$.[i,])),
          print_source(dirs$.[i,], show_source = show_source),
          "\n", sep = "")
      for (e in 1:nrow(printing_dir)) {
        cat("  ", pc(ch$j, ch$h, ch$h, " ", colorize_fs(printing_dir[e,])),
            print_source(printing_dir[e,], indent = "   ", show_source = show_source),
            "\n", sep = "")
      }
    }
  }

}

