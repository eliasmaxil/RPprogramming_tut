## LESSON 03. MANIPULATING THE DATA
## https://datacarpentry.org/R-ecology-lesson/03-dplyr.html

# Manipulating and analyzing data with dplyr
library(tidyverse) # Instala tidyr & dplyr, ggplot2, tibble, ...
# dplyr: Data manipulation in DBs
# tidyr: Reshape

## Selecting
surveys <- read_csv("data_raw/portal_data_joined.csv") # Read data
select(surveys, plot_id, species_id, weight) # Selecto cols of DF
select(surveys, -record_id, -species_id) # Select EXCEPT (-) cols
filter(surveys, year == 1995)

## Pipes
# 1. By intermediate steps. Temp DF
surveys2 <- filter(surveys, weight < 5)
surveys_sml <- select(surveys2, species_id, sex, weight)
# 2. Nest functions
surveys_sml <- select(filter(surveys, weight < 5), species_id, sex, weight)
# 3. Pipes %>%
surveys_sml <- surveys %>%
  filter(weight < 5) %>%
  select(species_id, sex, weight)
surveys_sml # Muestra el resultado

## Mutate
surveys %>%
  filter(!is.na(weight)) %>%
  mutate(weight_kg = weight / 1000) %>%
  view()

## Split-apply-combine and summarize
surveys %>%
  group_by(sex) %>%
  summarize(mean_weight = mean(weight, na.rm = TRUE))
# Group by multiple columns, summarize, arrange descending & print
surveys %>%
  filter(!is.na(weight)) %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight),min_weight = min(weight)) %>%
  arrange(desc(min_weight)) %>%
  print(n = 15)
# Counting
surveys %>%
  count(sex, species) %>%
  arrange(species, desc(n))

## Reshaping with gather and spread
surveys_gw <- surveys %>%
  filter(!is.na(weight)) %>%
  group_by(plot_id, genus) %>%
  summarize(mean_weight = mean(weight))
# Spread (reshape)
surveys_spread <- surveys_gw %>%
  spread(key = genus, value = mean_weight)
# Gather (Opuesto a spread)
surveys_gather <- surveys_spread %>%
  gather(key = "genus", value = "mean_weight", -plot_id)

## Exporting data
surveys_complete <- surveys %>%
  filter(!is.na(weight),           # remove missing weight
         !is.na(hindfoot_length),  # remove missing hindfoot_length
         !is.na(sex))                # remove missing sex
# Extract the most common species_id
species_counts <- surveys_complete %>%
    count(species_id) %>%
    filter(n >= 50) %>%
    # Only keep the most common species
    filter(species_id %in% surveys_complete$species_id)
write_csv(surveys_complete, file = "data/surveys_complete.csv") # Write
