# Crash course in R PDF

## Functions
x <- c(1, 2, 3, 4, 5)

# La funcion
our.mean <- function(x) {
    return(sum(x) / length(x))
}

our.summary <- function(x) {
mean <- mean(x)
median <- median(x)
standard_deviation <- sd(x)
foo <- cbind(mean, median, standard_deviation)
return(foo)
}


## FOR loop
y <- c(2010, 2011, 2012, 2013, 2014, 2015)
for (year in y) {
  print(paste("The year is", year))
}

for (i in 2010:2015) {
  print(paste("The year is", i))
}

## FOR con IF
for (i in 1:10) {
  if (!i %% 2) {
    next
  }
    print(i)
}
## Array
# Creacion por funcion
my_array <- array(1:20, dim <- c(20, 20, 20))
# Creacion con un for
for (i in 1:dim(my_array)[1]) {
  for (j in 1:dim(my_array)[2]) {
    for (k in 1:dim(my_array)[3]) {
      my_array[i, j, k] <- i * j * k
    }
  }
}
# Show a 10x10x15 chunk of your array
my_array[1:10, 1:10, 1:15]