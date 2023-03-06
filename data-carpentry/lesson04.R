## LESSON 04. VISUALIZING DATA
## https://datacarpentry.org/R-ecology-lesson/04-visualization-ggplot2.html
## https://github.com/rstudio/cheatsheets/raw/master/data-visualization-2.1.pdf

# Paquetes para instalar
# install.packages(c("hexbin", "patchwork", "gridExtra", "svSocket"))

# Libraries
library(tidyverse)
library(gridExtra)
library(hexbin)
library(patchwork)
library(grid)

# Data
surveys_complete <- read_csv("data/surveys_complete.csv")


## Plotting with ggplot2
# aes: Aesthetic mappings
ggplot(data = surveys_complete, aes(x = weight, y = hindfoot_length)) + 
    geom_point() # Use + operator. Because 2 continuous variables


# Otra manera de escribirlo:
# Assign plot to a variable
surveys_plot <- ggplot(data = surveys_complete,
                       mapping = aes(x = weight, y = hindfoot_length))

# Draw the plot
surveys_plot +  # El + tiene que ir aqui.
    geom_point(alpha = 0.1, color = "blue")

# Colores por especies
ggplot(data = surveys_complete, mapping =
    aes(x = weight, y = hindfoot_length)) +
    geom_point(alpha = 0.1, aes(color = species_id))


## Boxplot
ggplot(data = surveys_complete, mapping = aes
    (x = species_id, y = log10(weight))) +
    geom_violin(alpha = 0.8) +
    geom_jitter(alpha = 0.1, color = "tomato")


## Time series data
# Datos a graficar
yearly_counts <- surveys_complete %>%
  count(year, genus)
# Grafica
ggplot(data = yearly_counts, aes(x = year, y = n, color = genus)) +
    geom_line()

# Link data manipulation with visualization
# (Integrating with pipe operator)
yearly_counts_graph <- surveys_complete %>%
    count(year, genus) %>% 
    ggplot(mapping = aes(x = year, y = n, color = genus)) +
    geom_line()
yearly_counts_graph

## Faceting
# Otra variable para tener 2 lineas en cada plot de faceting
yearly_sex_counts <- surveys_complete %>%
                      count(year, genus, sex)
# Plot
ggplot(data = yearly_sex_counts, mapping = aes(x = year, y = n, color = sex)) +
  geom_line() +
  facet_wrap(facets =  vars(genus))

# One column, facet by rows, themes
ggplot(data = yearly_sex_counts,
        mapping = aes(x = year, y = n, color = sex)) +
     geom_line() +
     facet_wrap(vars(genus)) +
     theme_bw()

## Customization
ggplot(data = yearly_sex_counts, mapping = aes(x = year, y = n, color = sex)) +
    geom_line() +
    facet_wrap(vars(genus)) +
    labs(title = "Observed genera through time",
        x = "Year of observation",
        y = "Number of individuals") +
    theme(axis.text.x =
        element_text(colour = "grey20",
            size = 12, angle = 90, hjust = 0.5, vjust = 0.5),
            axis.text.y = element_text(colour = "grey20", size = 12),
            strip.text = element_text(face = "italic"),
            text = element_text(size = 16))

# Guardar la customization
grey_theme <- theme(axis.text.x =
                element_text(colour = "grey20", size = 12,
                    angle = 90, hjust = 0.5, vjust = 0.5),
                    axis.text.y = element_text(colour = "greyuniq20", size = 12),
                    text = element_text(size = 16))

ggplot(surveys_complete, aes(x = species_id, y = hindfoot_length)) +
    geom_boxplot() +
    grey_theme

## Arranging plots
# Poner 2 plots hechos en un mismo plot
plot1 <- ggplot(data = surveys_complete, aes(x = species_id, y = weight)) +
  geom_boxplot() +
  labs(x = "Species", y = expression(log[10](Weight))) +
  scale_y_log10()

plot2 <- ggplot(data = yearly_counts, aes(x = year, y = n, color = genus)) +
  geom_line() + 
  labs(x = "Year", y = "Abundance")

plot1 / plot2 + plot_layout(heights = c(3, 2))

## Exportar resultados

my_plot <- ggplot(data = yearly_sex_counts,
                  aes(x = year, y = n, color = sex)) +
    geom_line() +
    facet_wrap(vars(genus)) +
    labs(title = "Observed genera through time",
        x = "Year of observation",
        y = "Number of individuals") +
    theme_bw() +
    theme(axis.text.x = element_text(colour = "grey20", size = 12, angle = 90,
                                     hjust = 0.5, vjust = 0.5),
          axis.text.y = element_text(colour = "grey20", size = 12),
          text = element_text(size = 16))

ggsave("PlotLesson04_1.png", my_plot, width = 15, height = 10)

## This also works for grid.arrange() plots
combo_plot <- grid.arrange(plot1, plot2, ncol = 2,
                           widths = c(4, 6))
ggsave("PlotLesson04_2.png", combo_plot, width = 10, dpi = 300)
