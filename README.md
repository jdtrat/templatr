# templatr

#### Easily Create Templated R(Studio) Projects

<!-- badges: start -->

[![R-CMD-check](https://github.com/jdtrat/templatr/workflows/R-CMD-check/badge.svg)](https://github.com/jdtrat/templatr/actions)

<!-- badges: end -->

------------------------------------------------------------------------

templatr provides an easy way to convert a YAML file with file/directory specifications to an R(Studio) project.

## Table of contents

-   [Installation](#installation)
-   [Getting Started](#getting-started)
-   [Further Reading](#further-reading)
-   [Feedback](#feedback)
-   [Code of Conduct](#code-of-conduct)

------------------------------------------------------------------------

## Installation

You can install and load the development version of templatr from GitHub as follows:

```r
# Install the development version from GitHub
if (!require("remotes")) install.packages("remotes")
remotes::install_github("jdtrat/templatr")

# Load package
library(templatr)
```

## Getting Started

Create a new project with a user-specified template that follows the following form:
```r
cat(readLines(template_demo_project()), sep = "\n")
#> project:
#>   name: templatr-demo
#>   structure:
#>     - README.md
#>     - R:
#>       - 01_import_data.R
#>       - 02_clean_data.R
#>     - data:
#>       - sample.csv
#>     - stan-files:
#>     - reports:
#>   git-ignore:
#>     - "data"
#>     - "R/01_import_data.R"

templatr::new_project(path = "path/templatr-demo", template = template_demo_project())
```

## Further Reading

More coming soon! Under active development.

## Feedback

If you want to see a feature, or report a bug, please [file an issue](https://github.com/jdtrat/templatr/issues) or open a [pull-request](https://github.com/jdtrat/templatr/pulls)! As this package is just getting off the ground, we welcome all feedback and contributions. See our [contribution guidelines](https://github.com/jdtrat/templatr/blob/main/.github/CONTRIBUTING.md) for more details on getting involved!

## Code of Conduct

Please note that the templatr project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.
