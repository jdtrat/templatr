% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/func_new-project.R
\name{new_project}
\alias{new_project}
\title{Create New Project}
\usage{
new_project(
  path,
  template,
  rstudio = rstudioapi::isAvailable(),
  open = rlang::is_interactive()
)
}
\arguments{
\item{path}{A file path for where the new project should be created.}

\item{template}{The path to a YAML file containing the project structure.}

\item{rstudio}{Logical indicating whether RStudio should be used for the new
project. By default, it detects if RStudio is currently running and, if
\code{TRUE}, then \link[usethis:use_rstudio]{usethis::use_rstudio} is called to make an \href{https://support.rstudio.com/hc/en-us/articles/200526207-Using-RStudio-Projects}{RStudio Project}.
If \code{FALSE}, then a \code{.here} file is places in the directory so it can be
recognized within a project-oriented workflow via
\href{https://here.r-lib.org}{here} and
\href{https://rprojroot.r-lib.org}{rprojroot}.}

\item{open}{Logical indicating whether the new project should be opened. By
default, it checks whether the function is run interactively with
\link[rlang:is_interactive]{rlang::is_interactive}. If \code{TRUE}, the new project is activated and
opened. If \code{FALSE}, the working directory and active project are unchanged.}
}
\value{
Path to the newly created project (invisibly).
}
\description{
Create New Project
}
\examples{
\dontrun{
# Bare bones project with no existing content
new_project(
  path = "~/Desktop/templatr-demo/",
  template = template_demo_project()
)
# Project with files that have some structure
new_project(
  path = "~/Desktop/templatr-demo/",
  template = template_demo_project("demo-proj-source")
)
}

}
