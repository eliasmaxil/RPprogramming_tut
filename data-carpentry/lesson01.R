# Notas del cursos

## Lesson 1
# https://datacarpentry.org/R-ecology-lesson/01-intro-to-r.html
args(round)

weight_g <- c(50, 60, 65, 82) # Un vector. Se asigna con c()
weight_g > 64 # Booleans: FALSE FALSE TRUE TRUE

# Vectores combinados cambian a un una str
animals <- c("mouse", "cat", "dog", "rat")
(combined <- c(animals, weight_g))

# Expansion de vectores
letras <- c("a", "b", "c", "d")
(mas_letras <- letras[c(1, 2, 4, 4, 4, 1, 1, 5)]) # NA al final
(letras[1]) # a . Los indices en R empiezan en 1, no en 0

# Conditional subsetting
weight_g <- c(21, 34, 39, 54, 55)
(weight_g[c(TRUE, FALSE, FALSE, TRUE, TRUE)]) # 21 54 55
weight_g[weight_g > 50 & weight_g < 66] # Vector < >
weight_g[weight_g <= 30 | weight_g == 50] # == |
animals %in% c("rat", "cat", "dog", "duck", "goat") # Booleans
animals[animals %in% c("rat", "cat", "dog", "duck", "goat")] # Vector

# Missing data
heights <- c(2, 4, 4, NA, 6)
mean(heights)
mean(heights, na.rm = TRUE) # Calcular removiendo missing data
(heights[!is.na(heights)]) # Remueve NAs
(na.omit(heights)) # Idem de arriba?
(heights[complete.cases(heights)])

# NOTAS:
# "four" > "five" -> TRUE porque asi es su orden alfabetico
# What does %in% Mean in R:
#   Operator. Can be used to id if an element belongs to vector or DF
#
