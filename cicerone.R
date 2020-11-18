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
    description = HTML("In the first tab, the plot shows the change in snow conditions or phenology over the years.<br> 
                       Hovering over the point on the far left shows you that in 1976, snow melted at day 136, which corresponds to sometime in the middle of May.<br>
                       The trend line tracks how the snow melt date has changed over the years. 
                       There are fluctuations, but overall, it doesn't look like the snow melt date had changed much between 1976 and 1999.")
  )$
  step(
    el = "inputs1-wrapper",
    title = "Selecting parameters",
    description = "This tells you what parameters are depicted on the plot. Be careful with the axes since they can differ between the parameters. Keep them as they are for now."
  )$
  step(
    el = "period-wrapper",
    title = "Period",
    description = HTML("This shows you the years that are currently plotted.<br>
                       Comparing the years before 2000 and after 2000 is useful to see if the trend had held or not."),
    position = "top"
  )$
  step(
    el = "trendline",
    title = "Trend line",
    description = "Clicking here shows and hides trendlines on the plot. Keep it on for now."
  )$
  step(
    el = "stats1-wrapper",
    title = "Stats",
    description = HTML("The statistics appears when the trendline is present.<br>
                       The value of the slope tells us that the snow melt date delayed by 0.1 day per year.
                       The p-value of 0.78 suggests that the snow melt date had not significantly changed between 1974 and 1999. 
                       The R<sup>2</sup> value shows us that only 0.35% of the variation in snow melt is explained by years.")
  )$
  step(
    el = "viz-wrapper",
    title = "Next up...",
    description = HTML("Now, let's move on to the second tab. Click on <b>vs. snow conditions</b>")
  )$
  step(
    el = "plot2-wrapper",
    title = "vs. Snow conditions plot",
    description = HTML("In the second tab, the plot shows how the species phenology has shifted in relation to snow conditions.<br>
                       Each point represents a year. At a quick glance, we can see that the Yellow-bellied marmots are sighted later in the year when the snow sticks around until later.")
  )$
  step(
    el = "sidebar-wrapper",
    title = "Sidebar",
    description = "The parameters are the same as in the first tab."
  )$
  step(
    el = "stats2-wrapper",
    title = "Stats",
    description = "Here, it shows that the Yellow-bellied marmots are sighted 0.74 days later per day of delay in snow melt date.
                  We can see that the p-value is colored red, meaning the trend is significant as the value is less than 0.05.
                  As much as 34% of the variation in Yellow-bellied marmots' sighting date is explained by the variation in the snow melt date as well."
  )$
  step(
    el = "viz-wrapper",
    title = "Next up...",
    description = HTML("Now, let's look at the last tab. Click on <b>vs. other weather data</b>")
  )$
  step(
    el = "plot3-wrapper",
    title = "vs. Other weather data plot",
    description = HTML("In the last tab, the plot shows how the species phenology has shifted in relation to some environmental variables other than snow.<br>
                       It looks like the Yellow-bellied marmots tend to appear earlier in warmer springs.")
  )