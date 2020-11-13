# remotes::install_github("ColinFay/glouton")

library(shiny)
library(shinythemes)
library(shinyWidgets)
library(plotly)
library(readxl)
library(htmltools)
library(shinyBS)
library(magrittr)
library(glouton)
library(cicerone)


species <- c("Yellow-bellied marmot", "Least chipmunk", "American robin", "Steller's jay", 
             "Red-winged blackbird", "Dark-eyed junco", "Northern flicker", "Tree swallow", "Red-naped sapsucker", "Fox sparrow", "Ruby-crowned kinglet", 
             "Yellow-rumped warbler", "Cliff swallow", "Golden-mantled ground squirrel", "Broad-tailed hummingbird", "White-crowned sparrow", 
             "Brown-headed cowbird", "Mountain bluebird", "Yellow warbler", "Tall-fringed bluebell", "Glacier lily", "Western spring beauty")
vars <- c("Mean minimum April temperature (°C)", "Mean maximum April temperature (°C)", "Melt water (mm)")


guide <- Cicerone$
  new()$
  step(
    "period",
    "title here",
    "Text here"
  )


shinyUI <- fluidPage(
  use_glouton(),
  use_cicerone(),
  
  theme = shinytheme("united"),
  setBackgroundColor(color = "#F5F5F5"), 
  titlePanel(
    "RMBL Phenology"
  ),
  includeHTML("intro.html"),
  actionBttn("tour", "Take a Tour!", size = "sm", color = "success", block = TRUE),
  br(),
  br(),
  
  tabsetPanel(
    tabPanel("vs Year",
            sidebarLayout(
              sidebarPanel(
                selectInput("period", "Period", c("1974-1999", "2000-2010", "1974-2010")),
                pickerInput("snow", "Snow condition", choices = c("", "Snow melt date (JD)", "Annual snowfall (cm)", "Average snowpack (cm)"), 
                              options = list(style = "btn-success"), selected = "Snow melt date (JD)"),
                pickerInput("species", "Organism", choices = c("", list("Hibernating animals" = species[c(1,2)], 
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
               hr()
              )
            )
    ),
    
    tabPanel("vs snow conditions",
             sidebarLayout(
               sidebarPanel(
                 selectInput("period2", "Period", c("1974-1999", "2000-2010", "1974-2010")),
                 pickerInput("snow2", "Snow condition", choices = c("Snow melt date (JD)", "Annual snowfall (cm)", "Average snowpack (cm)"), 
                             options = list(style = "btn-success"), selected = "Snow melt date (JD)"),
                 pickerInput("species2", "Organism", choices = list("Hibernating animals" = species[c(1,2)], 
                                                                        "Migratory animals" = species[3:19],
                                                                        "Plants" = species[20:22]), 
                             options = list(style = "btn-success")),
                 materialSwitch("trend2", "Trend line", value = TRUE, status = "danger")
               ),
               mainPanel(
                 plotlyOutput("plot2"),
                 htmlOutput("stats2"),
                 hr()
               )
             ),
    ),
    
    tabPanel("vs other weather data",
             sidebarLayout(
               sidebarPanel(
                 selectInput("period3", "Period", c("1974-1999", "2000-2010", "1974-2010")),
                 pickerInput("weather", "Weather condition", choices = vars,
                             options = list(style = "btn-success")),
                 pickerInput("species3", "Organism", choices = list("Hibernating animals" = species[c(1,2)],
                                                                   "Migratory animals" = species[3:19],
                                                                   "Plants" = species[20:22]),
                             options = list(style = "btn-success")),
                 materialSwitch("trend3", "Trend line", value = TRUE, status = "danger")
               ),
               mainPanel(
                 plotlyOutput("plot3"),
                 htmlOutput("stats3"),
                 hr()
               )
             )
    )
  )
)