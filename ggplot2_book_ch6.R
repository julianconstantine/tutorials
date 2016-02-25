library(datasets)
library(ggplot2)

# Creates plot of
p <- qplot(x=sleep_total, y=sleep_cycle, data=msleep, color=vore)
p

# Explicitly adds the default 'hue' scale for the 'color' aesthetic
# This doesn't change the plot because it was done automatically above
p + scale_color_hue()

# Now add a custom scale, which will change the values of the legend but not the colors themselves
p + scale_color_hue(name="What does\nit eat?", 
                    breaks=c('herbi', 'carni', 'omni', NA),
                    labels=c('plants', 'meat', 'both', 'don\'t know'))

# Need to use 'palette' argument instead of 'pal' (the book might using an older version)
p + scale_color_brewer(palette='Set1')


# POSITION SCALES -- CONTINUOUS VARIABLES
# This willl plot log(y) vs log(x) with x, y axis marks transformed to logarithmic scale
qplot(log10(carat), log10(price), data=diamonds)

# This will plot log(y) vs log(x) but with x,y axis marks still on normal ("linear/original") scale
qplot(carat, price, data=diamonds) + scale_x_continuous(trans='log10') + scale_y_continuous(trans='log10')

# This produces the same as above
qplot(carat, price, data=diamonds) + scale_x_log10() + scale_y_log10()


# POSITION SCALES -- DATETIME VARIABLES
