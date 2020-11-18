# RShiny_RMBL-phenology

RMBL-phenology is an interactive shiny app that allows any user to visualize the relationships between climatic variables and phenology of hibernating species, migratory species, and some plant species. It is a modified version of a student activity on climate change and phenology developed by Wu. The original pdf file is [here](https://tiee.esa.org/vol/v13/issues/data_sets/wu/pdf/wu.pdf). The data are collected in Rocky Mountain Biological Laboratory in Colorado for over 30 years.

## Prerequisites for opening in Rstudio
Git and Rstudio ([Instructions](https://resources.github.com/whitepapers/github-and-rstudio/))  
Installation of the following R packages:
shiny, magrittr, plotly, shinythemes, shinyWidgets, htmltools, cicerone

```
pkgs <- c('shiny', 'ggridges','plotly', 'shinythemes', 'shinyWidgets', 'htmltools', 'cicerone')
lapply(pkgs, FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
    }
  }
)
```

## Using RMBL-phenology
* Opening in Rstudio:  
Click on "Code" on the top right to copy the link to this repository.  
Click ```File```, ```New Project```, ```Version Control```, ```Git```  
Paste the repository URL and click ```Create Project```.

* Alternatively, go to [this link](https://huckley.shinyapps.io/RShiny_RMBL-phenology/).

We have a google doc with questions to guide through the app for further understanding of the topic.

## Contributing to RMBL-phenology
<!--- If your README is long or you have some specific process or steps you want contributors to follow, consider creating a separate CONTRIBUTING.md file--->
To contribute to RMBL-phenology, follow these steps:

1. Fork this repository.
2. Create a branch: `git checkout -b <branch_name>`.
3. Make your changes and commit them: `git commit -m '<commit_message>'`
4. Push to the original branch: `git push origin <project_name>/<location>`
5. Create the pull request.

Alternatively see the GitHub documentation on [creating a pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request).
