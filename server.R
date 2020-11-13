phen <- read.csv("phenology.csv")

snow <- c("Snow melt date (JD)" = "melt", "Annual snowfall (cm)" = "snowfall", "Average snowpack (cm)" = "snowpack")

species <- c("Yellow-bellied marmot", "Least chipmunk", "American robin", "Steller's jay", 
             "Red-winged blackbird", "Dark-eyed junco", "Northern flicker", "Tree swallow", "Red-naped sapsucker", "Fox sparrow", "Ruby-crowned kinglet", 
             "Yellow-rumped warbler", "Cliff swallow", "Golden-mantled ground squirrel", "Broad-tailed hummingbird", "White-crowned sparrow", 
             "Brown-headed cowbird", "Mountain bluebird", "Yellow warbler", "Tall-fringed bluebell", "Glacier lily", "Western spring beauty")
vars <- c("Mean minimum April temperature (°C)" = "mins", "Mean maximum April temperature (°C)" = "maxes", "Melt water (mm)" = "water")

d_x <- vector()
d_y <- vector()
d_save_x <- vector()
d_save_y <- vector()

# initial and final are a way I came up to reset the clicks and the vectors associated with it.
# Initialized to 0, and will be added whenever the user chooses a different parameter.
initial <- 0
final <- 0


guide <- Cicerone$
  new()$
  step(
    "period",
    "title here",
    "Text here"
  )

shinyServer <- function(input, output, session) {
  
  observeEvent(input$tour, guide$init()$start())
  
  output$plot <- renderPlotly({
    validate(
      need(input$snow != "" || input$species != "", "Select a snow condition or a species")
    )
    # This variable does nothing. Necessary so that the whole function renders when a change in reset is made.
    reset <- input$reset
    
    if (input$period == "1974-1999") {
      phen <- phen[phen$Year <= 1999,]
    } else if (input$period == "2000-2010") {
      phen <- phen[phen$Year >= 2000,]
    }
    
    spVar <- colnames(phen)[which(species %in% input$species) + 4]  # + 4 because the data set has 4 columns in the beginning that are year and snow conditions.
    snowVar <- snow[input$snow]
    
    style <- ifelse(input$style == "Points", "markers", "lines")
    
    p <- plot_ly(x = ~phen$Year)
    if (input$snow != "" && input$species == "") {
      p <- p %>%
        add_trace(y = ~phen[,snowVar], name = "Snow conditions", type = "scatter", mode = style, marker = list(color = "blue")) %>%
        layout(xaxis = list(title = "Year"),
               yaxis = list(title = input$snow))
      
    } else if (input$snow == "" && input$species != "") {
      p <- p %>%
        add_trace(y = ~phen[,spVar], type = "scatter", mode = style, name = "Species", color = "green", connectgaps = TRUE, marker = list(color = "green")) %>%
        layout(xaxis = list(title = "Year"),
               yaxis = list(title = paste(input$species, "(JD)")))

    } else if (input$snow != "" && input$species != ""){
      p <- p %>%
        add_trace(y = ~phen[,spVar], name = "Species", customdata = colnames(phen[spVar])[1], type = "scatter", mode = style, connectgaps = TRUE, color = "green", marker = list(color = "green")) %>%
        add_trace(y = ~phen[,snowVar], name = "Snow conditions", customdata = colnames(phen[snowVar])[1], type = "scatter", mode = style, yaxis = "y2", color = "blue", marker = list(color = "blue")) %>%
        layout(xaxis = list(title = "Year"),
               yaxis = list(title = paste(input$species, "(JD)")),
               yaxis2 = list(
                 overlaying = "y",
                 side = "right",
                 title = input$snow,
                 automargin = T
               ))
    }

    if (input$trend) {  # Show trend line 
      if (input$species != "") {  # Species trend line
        subset_sp <- phen[c("Year", spVar)] %>%
          filter(!is.na(phen[spVar]))
        
        fit_sp <- lm(subset_sp[,2] ~ subset_sp[,1])
        p <- p %>% add_lines(data = subset_sp, x = ~Year, y = ~fitted(fit_sp), name = "Species trendline", mode = "lines", line = list(color = "green"))
      }
      
      if(input$snow != "") { # Snow condition trend line
        subset_snow <- phen[c("Year", snowVar)] %>%
          filter(!is.na(phen[snowVar]))

        fit_snow <- lm(subset_snow[,2] ~ subset_snow[,1])
        if(input$species == "") { # When only snow condition
          p <- p %>% add_lines(data = subset_snow, x = ~Year, y = ~fitted(fit_snow), name = "Trend line", mode = "lines", line = list(color = "blue"))
        } else { 
          p <- p %>% add_lines(data = subset_snow, x = ~Year, y = ~fitted(fit_snow), yaxis = "y2", name = "Snow trendline", mode = "lines", line = list(color = "blue"))
        }
      }
    }
    if (input$period == "1974-2010") { # Add a vertical line at year = 2000
      vline <- function(x) {
        list(
          type = "line", 
          y0 = 0, 
          y1 = 1, 
          yref = "paper",
          x0 = x, 
          x1 = x, 
          line = list(color = "black")
        )
      }
      p <- p %>% layout(shapes = list(vline(2000)))
    }
    
    p <- p %>%
      layout(legend = list(orientation = "h",   # show entries horizontally
                           xanchor = "center",  # use center of legend as anchor
                           x = 0.5, y = 1))
    
    d <- event_data("plotly_click")

    d_x <<- c(d_x, d$x[1])
    d_y <<- c(d_y, d$y[1])

    p1x <- d_x[max(length(d_x) - 1, 1)]
    p1y <- d_y[max(length(d_y) - 1, 1)]
    p2x <- ifelse(length(d_x) < 2, NA, d_x[length(d_x)])
    p2y <- ifelse(length(d_y) < 2, NA, d_y[length(d_y)])
    
    # Number manipulation so that the first click on the plot is recognized.
    # The first click somehow adds 2 to final, so making initial to 2 to make initial equal to final.
    if (initial == 0) {
      initial <- 2
    }
    if(initial != final) {
      d_x <<- vector()
      d_y <<- vector()
    } else {
      yaxis <- ifelse(d$customdata %in% c("melt", "snowfall", "snowpack"), "y2", "y1")  # Which axis to refer to
      p <- p %>% 
        add_markers(x = p1x, y = p1y, name = "Point 1", marker = list(color = "black", size = 10), yaxis = yaxis) %>%
        add_markers(x = p2x, y = p2y, name = "Point 2", marker = list(color = "black", size = 10), yaxis = yaxis)
    
      if (length(d_x) > 1) {
        p <- p %>% 
          add_segments(x = p1x, y = p1y, xend = p2x, yend = p2y, name = "Selected", line = list(color = ""), yaxis = yaxis)
      }
    }
    p
  })

  
  output$stats <- renderText({
    if (input$period == "1974-1999") {
      phen <- phen[phen$Year <= 1999,]
    } else if (input$period == "2000-2010") {
      phen <- phen[phen$Year >= 2000,]
    }
    spVar <- colnames(phen)[which(species %in% input$species) + 4]
    snowVar <- snow[input$snow]
    
    trend <- ""
    if (input$trend) {
      trend <- "<b>Trend line analysis</b>"
      if (input$species != "") {
        subset_sp <- phen[c("Year", spVar)] %>%
          filter(!is.na(phen[spVar]))
        fit_sp <- lm(subset_sp[,2] ~ subset_sp[,1])
      }
      
      if(input$snow != "") {
        subset_snow <- phen[c("Year", snowVar)] %>%
          filter(!is.na(phen[snowVar]))
        fit_snow <- lm(subset_snow[,2] ~ subset_snow[,1])
      }
    }
    
    
    snowR <- ifelse(input$snow != "" && input$trend, 
                    paste("<br><b style = 'color:blue;'>Snow conditions</b>
                          <br>Slope:", round(as.numeric(fit_snow$coefficients[2]), digits = 2), 
                          "<br>p-value:", signif(summary(fit_snow)$coefficients[2,4], digits = 2),
                          "<br>R<sup>2</sup>:", signif(summary(fit_snow)$r.squared, digits = 2)), "")
    speciesR <- ifelse(input$species != "" && input$trend, 
                       paste("<br><b style = 'color:green;'>Species</b>
                             <br>Slope:", round(as.numeric(fit_sp$coefficients[2]), digits = 2), 
                             "<br>p-value:", signif(summary(fit_sp)$coefficients[2,4], digits = 2),
                             "<br>R<sup>2</sup>:", signif(summary(fit_sp)$r.squared, digits = 2)), "")
    HTML(trend, snowR, speciesR)
  })
  
  output$clickData <- renderText({
    # These variables do nothing. Necessary so that the whole function renders when a change in reset, snow or species is made.
    reset <- input$reset
    snow <- input$snow
    spe <- input$species
    per <- input$period
    
    d <- event_data("plotly_click")

    d_save_x <<- c(d_save_x, d$x[1])
    d_save_y <<- c(d_save_y, d$y[1])
    
    # Same thing here as I did in points above. Making initial match the final the first click.
    if (initial == 0) {
      initial <- 2
    }

    if(initial != final) {
      p1 <- ""
      p2 <- ""
      slope <- ""
      d_save_x <<- vector()
      d_save_y <<- vector()
      initial <<- final 
    } else {
      p1x <- d_save_x[max(length(d_save_x) - 1, 1)]
      p1y <- d_save_y[max(length(d_save_y) - 1, 1)]
      p1 <- ifelse(is.null(d), "", paste("(", p1x, ", ", p1y, ")"))
      
      p2x <- d_save_x[length(d_save_x)]
      p2y <- d_save_y[length(d_save_y)]
      p2 <- ifelse(length(d_save_x) < 2, "", paste("(", p2x, ", ", p2y, ")"))
      
      slope <- ifelse(length(d_save_x) < 2, "", round((p1y - p2y) / (p1x - p2x), digits = 2))
      
    }
    
    HTML("Point 1: ", p1, 
         "<br>Point 2: ", p2, 
         "<br>Slope:", slope)
  })
  
  # Adding 1 to final when any change in input$snow is made. This way, previously selected points won't stay on the plot.
  observeEvent(input$snow, {
    final <<- final + 1
  })
  
  # Same as above except that this is for the species selection.
  observeEvent(input$species, {
    final <<- final + 1
  })
  
  # Same as above except that this is for the period selection.
  observeEvent(input$period, {
    final <<- final + 1
  })
  
  # Points and values are reset when the reset button is clicked.
  observeEvent(input$reset, {
    final <<- final + 1
  })
  
  
  #______________________________________________________________________________
  #Plot 2
  
  output$plot2 <- renderPlotly({
    snowVar <- snow[input$snow2]
    spVar <- colnames(phen)[which(species %in% input$species2) + 4]  # + 4 because the data set has 4 columns in the beginning that are year and snow conditions.
    
    if (input$period2 == "1974-1999") {
      phen <- phen[phen$Year <= 1999,]
    } else if (input$period2 == "2000-2010") {
      phen <- phen[phen$Year >= 2000,]
    }
    
    p2 <- plot_ly() %>%
      add_markers(x = ~phen[, snowVar], y = ~phen[, spVar], name = "species", showlegend = F) %>%
      layout(xaxis = list(title = input$snow2),
             yaxis = list(title = paste(input$species2, "(JD)"))
             )
    
    if (input$trend2) {
      subset <- phen[c(snowVar, spVar)] %>%
        filter(!is.na(phen[spVar]))
      subset <- filter(subset, !is.na(subset[snowVar]))
      fit <- lm(subset[,2] ~ subset[,1])
      p2 <- p2 %>% add_lines(data = subset, x = ~subset[, snowVar], y = ~fitted(fit), name = "Trend line", mode = "lines", line = list(color = "green"))
    }
    p2
  })
  
  output$stats2 <- renderText({
    spVar <- colnames(phen)[which(species %in% input$species2) + 4]
    snowVar <- snow[input$snow2]
    
    if (input$period2 == "1974-1999") {
      phen <- phen[phen$Year <= 1999,]
    } else if (input$period2 == "2000-2010") {
      phen <- phen[phen$Year >= 2000,]
    }
    
    if (input$trend2) {
      subset <- phen[c(snowVar, spVar)] %>%
        filter(!is.na(phen[spVar]))
      subset <- filter(subset, !is.na(subset[snowVar]))
      fit <- lm(subset[,2] ~ subset[,1])
    
    pval <- signif(summary(fit)$coefficients[2,4], digits = 2)
    if (pval < 0.05) {
      pval <- paste("<b style = 'color:red;'>", pval, "</b>")
    }

    HTML("<b>Trend line analysis</b>
         <br>Slope:", round(as.numeric(fit$coefficients[2]), digits = 2), 
         "<br>p-value:", pval,
         "<br>R<sup>2</sup>:", signif(summary(fit)$r.squared, digits = 2))
    }
  })
  
  
  #_____________________________________________________________________________
  # Plot 3
  
  output$plot3 <- renderPlotly({
    weatherVar <- vars[input$weather]
    spVar <- colnames(phen)[which(species %in% input$species3) + 4]  # + 4 because the data set has 4 columns in the beginning that are year and snow conditions.
    
    if (input$period3 == "1974-1999") {
      phen <- phen[phen$Year <= 1999,]
    } else if (input$period3 == "2000-2010") {
      phen <- phen[phen$Year >= 2000,]
    }
    
    p3 <- plot_ly() %>%
      add_markers(x = ~phen[, weatherVar], y = ~phen[, spVar], name = "species", showlegend = F) %>%
      layout(xaxis = list(title = input$weather),
             yaxis = list(title = paste(input$species3, "(JD)"))
      )
    
    if (input$trend3) {
      subset <- phen[c(weatherVar, spVar)] %>%
        filter(!is.na(phen[spVar]))
      subset <- filter(subset, !is.na(subset[weatherVar]))
      fit <- lm(subset[,2] ~ subset[,1])
      p3 <- p3 %>% add_lines(data = subset, x = ~subset[, weatherVar], y = ~fitted(fit), name = "Trend line", mode = "lines", line = list(color = "green"))
    }
    p3
  })
  
  output$stats3 <- renderText({
    spVar <- colnames(phen)[which(species %in% input$species3) + 4]
    weatherVar <- vars[input$weather]
    
    if (input$period3 == "1974-1999") {
      phen <- phen[phen$Year <= 1999,]
    } else if (input$period3 == "2000-2010") {
      phen <- phen[phen$Year >= 2000,]
    }
    
    if (input$trend3) {
      subset <- phen[c(weatherVar, spVar)] %>%
        filter(!is.na(phen[spVar]))
      subset <- filter(subset, !is.na(subset[weatherVar]))
      fit <- lm(subset[,2] ~ subset[,1])
      
      pval <- signif(summary(fit)$coefficients[2,4], digits = 2)
      if (pval < 0.05) {
        pval <- paste("<b style = 'color:red;'>", pval, "</b>")
      }
      
      HTML("<b>Trend line analysis</b>
         <br>Slope:", round(as.numeric(fit$coefficients[2]), digits = 2), 
           "<br>p-value:", pval,
           "<br>R<sup>2</sup>:", signif(summary(fit)$r.squared, digits = 2))
    }
  })
}
