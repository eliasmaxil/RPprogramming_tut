# Notas del curso
# https://datacarpentry.org/R-ecology-lesson/02-starting-with-data.html

## Lesson 2
url <- "https://ndownloader.figshare.com/files/2292169"
download.file(url = url, destfile = "data_raw/portal_data_joined.csv")

## load the tidyverse packages, incl. dplyr
# Para installar install.packages("tidyverse")
library(tidyverse)
surveys <- read_csv("data_raw/portal_data_joined.csv") # To DF
head(surveys)
surveys <- read_csv("data_raw/portal_data_joined.csv")
view(surveys)
str(surveys)    # Estructura de DF
surveys[1, 6] # 1st row, 6th col (as vector)
surveys[, 1] # 1st col as vector
surveys[1:3, 6] # primeras 3 lineas 6a col
surveys[3, ] # Linea 3 todas las cols
surveys[, -1] # The whole data frame, except the first column

## Llamado por nombres
surveys["species_id"]       # Result is a data.frame
surveys[, "species_id"]     # Result is a vector
surveys_30 <- surveys[1:30, "record_id"] # DF?

## Factors (categorical data). Los valores se llaman levels
# La conversion es manual despues de cargar el DF
surveys$sex <- factor(surveys$sex)
summary(surveys$sex)
genus <- surveys[, "genus"]
as.character(genus)
plot(surveys$sex)
sex <- surveys$sex
levels(sex)
sex <- addNA(sex)
levels(sex)[3] <- "undetermined"
plot(sex)

## Formatting dates
library(lubridate)
my_date <- ymd("2015-01-01")
my_date <- ymd(paste("2016", "1", "1", sep = "-")) 
str(my_date)
ymd(paste(surveys$year, surveys$month, surveys$day, sep = "-"))
surveys$date <- ymd(paste(surveys$year, surveys$month, surveys$day, sep = "-"))
summary(surveys$date)
# Extraer missing dates
missing_dates <- surveys[is.na(surveys$date), c("year", "month", "day")]
head(missing_dates)