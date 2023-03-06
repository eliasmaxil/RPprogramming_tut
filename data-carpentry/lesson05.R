## LESSON 05. SQL DBs & R
# https://datacarpentry.org/R-ecology-lesson/05-r-and-databases.html

# Paquetes
# install.packages(c("dbplyr", "RSQLite"))

# Datos
dir.create("data_raw", showWarnings = FALSE)
download.file(url = "https://ndownloader.figshare.com/files/2292171",
              destfile = "data_raw/portal_mammals.sqlite", mode = "wb")

# Librerias
library(dplyr)
library(dbplyr)
library(tidyverse)

## Abrir datos
mammals <- DBI::dbConnect(RSQLite::SQLite(), "data_raw/portal_mammals.sqlite")
# Closer look
src_dbi(mammals)


## Querying en SQL sintaxis
# tbl() sirve para conectarse a DBs -tabla?-
surveyssql <- tbl(mammals, sql("SELECT year, species_id, plot_id FROM surveys"))
head(surveyssql)

## Querying con dplyr sintaxis
# Abrir datos de mammals tabla surveys y dejarlos en var surveys
surveys <- tbl(mammals, "surveys")
# Seleccionar columnas de la nueva var
surveysr <- surveys %>%
    select(year, species_id, plot_id)
head(surveysr)

nrow(surveys) # NA porque dplyr solo envia el query
show_query(head(surveys, n = 10)) # Muestra la SQL query enviada pot dplyr

## Simple DB Qs con dyplr
surveys %>%
  filter(weight < 5) %>%
  select(species_id, sex, weight) # ... with more rows (Laziness)


## Laziness (dplyr tries to be as lazy as possible)
# Para parar Lazyness usar collect()
data_subset <- surveys %>%
  filter(weight < 5) %>%
  select(species_id, sex, weight) %>%
  collect()

## Complex DB Qs (Con dplyr)
plots <- tbl(mammals, "plots")
plots # Col plot_id tambien esta en la tabla surveys

# Inner join 
# tabla "plots" con tabla "surveys" en cols plot_id
plots %>%
  filter(plot_id == 1) %>%
  inner_join(surveys) %>%
  collect()

# Left join
species <- tbl(mammals, "species")
view(species)

unique_genera <- left_join(surveys, plots) %>%
    left_join(species) %>%
    group_by(plot_type) %>%
    summarize(
        n_genera = n_distinct(genus)
    ) %>%
    collect()
view(surveys)
view(plots)
view(plot_type)
view(unique_genera)

## Cerrar coneccion
DBI::dbDisconnect(mammals)

## Creating new SQL database
# download.file("https://ndownloader.figshare.com/files/3299483",
#               "data_raw/species.csv")
# download.file("https://ndownloader.figshare.com/files/10717177",
#               "data_raw/surveys.csv")
# download.file("https://ndownloader.figshare.com/files/3299474",
#               "data_raw/plots.csv")


