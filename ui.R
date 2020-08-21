library(shiny)
library(shinythemes)
library(shinyWidgets)
library(plotly)
library(readxl)
library(htmltools)
library(shinyBS)
library(magrittr)
species <- c("Yellow-bellied marmot", "Least chipmunk", "American robin", "Steller's jay", 
             "Red-winged blackbird", "Dark-eyed junco", "Northern flicker", "Tree swallow", "Red-naped sapsucker", "Fox sparrow", "Ruby-crowned kinglet", 
             "Yellow-rumped warbler", "Cliff swallow", "Golden-mantled ground squirrel", "Broad-tailed hummingbird", "White-crowned sparrow", 
             "Brown-headed cowbird", "Mountain bluebird", "Yellow warbler", "Tall-fringed bluebell", "Glacier lily", "Western spring beauty")
#vars <- c("Minimum temperature (°C)", "Maximum temperature (°C)", "Melt water (mm)", "Total snow (cm)", "Snow pack (cm)", "Rainfall (mm)")
shinyUI <- fluidPage(
  theme = shinytheme("united"),
  setBackgroundColor(color = "#F5F5F5"), 
  titlePanel(
    "RMBL Phenology"
  ),
  #p("This panel shows three climate variables and the first signting of 22 organisms which include 2 hibernating animals, 19 migratory animals and 3 plants."),
  includeHTML("intro.html"),
  tabsetPanel(
    tabPanel("vs Year",
            sidebarLayout(
              sidebarPanel(
                selectInput("period", "Period", c("1970-1999", "2000-2010", "1970-2010")),
                pickerInput("snow", "Snow", choices = c("", "Snow melt date (JD)", "Annual snowfall (cm)", "Average snowpack (cm)", "Melt water equivalent (mm)"), 
                              options = list(style = "btn-success"), selected = "Snow melt date (JD)"),
                pickerInput("species", "Species", choices = c("", list("Hibernating animals" = species[c(1,2)], 
                                                                       "Migratory animals" = species[3:19],
                                                                       "Plants" = species[20:22])), 
                            options = list(style = "btn-success")),
                materialSwitch("trend", "Trend line", value = TRUE, status = "danger"),
                radioButtons("style", "Style", choices = c("Points", "Lines"), inline = TRUE)
              ),
              
              mainPanel(
               plotlyOutput("plot"),
               htmlOutput("stats"),
               br(),
               strong("Click two points on the plot to see the rate of change"),
               htmlOutput("clickData"),
               br(),
               bsButton("reset", "Reset points", style = "danger", size = "small"),
               br(),
               hr()
               
              )
            )
    ),
    
    tabPanel("snow vs species",
             sidebarLayout(
               sidebarPanel(
                 pickerInput("snow2", "Snow", choices = c("Snow melt date (JD)", "Annual snowfall (cm)", "Average snowpack (cm)", "Melt water equivalent (mm)"), 
                             options = list(style = "btn-success"), selected = "Snow melt date (JD)"),
                 pickerInput("species2", "Species", choices = list("Hibernating animals" = species[c(1,2)], 
                                                                        "Migratory animals" = species[3:19],
                                                                        "Plants" = species[20:22]), 
                             options = list(style = "btn-success")),
                 materialSwitch("trend2", "Trend line", value = TRUE, status = "danger")
               ),
               mainPanel(
                 plotlyOutput("plot2"),
                 htmlOutput("stats2")
               )
             ),
             hr()
    
             
             
    )
    # tabPanel("Other weather data",
    #          sidebarLayout(
    #            sidebarPanel(
    #              pickerInput("weather", "Weather", choices = vars, 
    #                          options = list(style = "btn-success")),
    #              pickerInput("species3", "Species", choices = list("Hibernating animals" = species[c(1,2)], 
    #                                                                "Migratory animals" = species[3:19],
    #                                                                "Plants" = species[20:22]), 
    #                          options = list(style = "btn-success")),
    #              materialSwitch("trend3", "Trend line", value = TRUE, status = "danger")
    #            ),
    #            mainPanel(
    #              plotlyOutput("plot3"),
    #              htmlOutput("stats3")
    #            )
    #          ))
    # 
  )
)