# `parse_proj_temmplate` works

    Code
      parse_proj_template(template_demo_project())
    Output
      $project
      $project$name
      [1] "templatr-demo"
      
      $project$structure
      $project$structure[[1]]
      [1] "README.md"
      
      $project$structure[[2]]
      $project$structure[[2]]$R
      [1] "01_import_data.R" "02_clean_data.R" 
      
      
      $project$structure[[3]]
      $project$structure[[3]]$data
      [1] "sample.csv"
      
      
      $project$structure[[4]]
      $project$structure[[4]]$`stan-files`
      NULL
      
      
      $project$structure[[5]]
      $project$structure[[5]]$reports
      NULL
      
      
      
      $project$`git-ignore`
      [1] "data"               "R/01_import_data.R"
      
      $project$renv
      [1] TRUE
      
      $project$packages
      [1] "dplyr"          "ggplot2"        "targets"        "jdtrat/jdtools"
      
      

