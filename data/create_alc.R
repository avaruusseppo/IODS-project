# create_alc - prepare the alcohol data set
# Seppo Nyrkkö Nov 13 2020


### Read the data and explore dimensions

d1=read.table("student-mat.csv",sep=";",header=TRUE)
d2=read.table("student-por.csv",sep=";",header=TRUE)

dim(d1) 
# [1] 395  33 

dim(d2)
# [1] 649  33

str(d1)
str(d2)
# ok -- contains factors and integers...


### We will join the students with the identifier columns
### Keep only students which are in both files

join_by = c( "school", "sex", "age", "address", "famsize", "Pstatus", 
            "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")

library(dplyr)

# join the two datasets by the selected identifiers
math_por <- inner_join(d1, d2, by = join_by, suffix = c(".math", ".por"))

colnames(math_por)
# seems ok ... G3.math G3.por

dim(math_por)
# contains only students which appear in both source files

### Clean up the duplicated columns 

# create a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))

# columns that were not used for joining the data
notjoined_columns <- colnames(d1)[!colnames(d1) %in% join_by]

notjoined_columns
# seems ok, summarize or pick one of these

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column  vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# Check that all went OK
str(alc)
dim(alc)
# looks ok, now the numerics are averaged, and column names joined.
# [1] 382  33  -- Seems OK

alc$alc_use <- (alc$Dalc+alc$Walc)/2
alc$high_use <- alc$alc_use > 2
summary(alc$high_use)
#    Mode   FALSE    TRUE 
# logical     268     114 

# high_users seem OK

### Now let's save the data out
dim(alc)

# [1] 382  35 ... Seems OK

write.csv(alc, "alc.csv", row.names = F)

test <- read.csv("alc.csv")
dim(test)
str(test)
# looks similar -- OK


