library(cicerone)

guide <- Cicerone$
  new()$
  step(
    el = "viz-wrapper",
    title = "Visualization",
    description = "Welcome to our RMBL phenology visualization tool. Notice there are three tabs on the top. We will go over them one by one. Click next to get started."
  )$
  step(
    el = "plot1-wrapper",
    title = "vs. Year plot",
    description = "In the first tab, the plot shows how the parameters related to phenology have changed in Colorado over the years."
  )$
  step(
    el = "inputs1-wrapper",
    title = "Selecting parameters",
    description = "This tells you what parameters are depicted on the plot. Be careful with the axes since they can differ between the parameters."
  )$
  step(
    el = "period-wrapper",
    title = "Period",
    description = "This tells you the years that are currently plotted.",
    position = "top"
  )$
  step(
    el = "trendline",
    title = "Trend line",
    description = "Clicking here shows and hides trendlines on the plot. Keep it on for now."
  )$
  step(
    el = "stats",
    title = "Stats",
    description = "The statistics appears when the trendline is present."
  )$
  step(
    el = "viz-wrapper",
    title = "Next up...",
    description = "Now, let's move on to the second tab. Click on 'vs. snow conditions'"
  )$
  step(
    el = "plot2-wrapper",
    title = "vs. Snow conditions plot",
    description = "In the second tab, the plot shows how the species phenology has shifted in relation to snow conditions. Each point represents a year."
  )$
  step(
    el = "sidebar-wrapper",
    title = "Sidebar",
    description = "The parameters are the same as in the first tab."
  )$
  step(
    el = "viz-wrapper",
    title = "Next up...",
    description = "Now, let's look at the last tab."
  )$
  step(
    el = "plot3-wrapper",
    title = "vs. Other weather data plot",
    description = "In the last tab, the plot shows how the species phenology has shifted in relation to some environmental variables other than snow."
  )