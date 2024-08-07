guide <- Cicerone$
  new()$
  step(
  el = "viz-wrapper",
  title = "Visualization",
  description = HTML("Welcome to our RMBL phenology visualization tool!<br><br>
                        Notice there are three tabs on the top and we will go over them one by one.<br><br>
                       So, keep it at <b>'vs. Year'</b> for now and click <b>Next</b> to get started.")
)$
  step(
  el = "plot1-wrapper",
  title = "vs. Year plot",
  description = HTML("In the first tab, the plot shows the change in snow conditions and phenology over the years.<br><br>
                       - Hovering over the point on the far left shows you that in 1976, snow melted at the day 136, which corresponds to sometime in the middle of May.<br><br>
                       - The trend line tracks how the snow melt date has changed over the years.
                       There are fluctuations, but overall, it doesn't look like the snow melt date had changed much between 1976 and 1999.")
)$
  step(
  el = "inputs1-wrapper",
  title = "Selecting parameters",
  description = "This tells you what parameters are depicted on the plot. <br><br>
                Note: Be careful with the axes since they can differ between the parameters. Keep them as they are for now."
)$
  step(
  el = "period-wrapper",
  title = "Period",
  description = HTML("You can choose different time period you want the plot to be shown.<br><br>
                      Recommended: Select <b>2000-2010</b> by clicking on the dropdown menu."),
  position = "top"
)$
  step(
  el = "trendline",
  title = "Trend line",
  description = "Clicking here shows or hides trendlines on the plot.
                In this case, we keep it on for better visualization."
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
  el = "tabs",
  title = "Next up...",
  description = HTML("Now, let's move on to the second tab. Click on <b>vs. snow conditions</b> before hitting next.")
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
  el = "tabs",
  title = "Next up...",
  description = HTML("Now, let's look at the last tab. Click on <b>vs. other weather data</b> and then hit next.")
)$
  step(
  el = "plot3-wrapper",
  title = "vs. Other weather data plot",
  description = HTML("In the last tab, the plot shows how the species phenology has shifted in relation to some environmental variables other than snow.<br>
                       It looks like the Yellow-bellied marmots tend to appear earlier in warmer springs.")
)
