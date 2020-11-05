# Seppo Nyrkkö 
# Nov 05 2020
# Data Wrangling excercise

# load data into the lrn14
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# Look at the dimensions and structure of the data
print(dim(lrn14))
# [1] 183  60

# OK!

str(lrn14)

#'data.frame':	183 obs. of  60 variables:
#$ Aa      : int  3 2 4 4 3 4 4 3 2 3 ...
#$ Ab      : int  1 2 1 2 2 2 1 1 1 2 ...
#$ Ac      : int  2 2 1 3 2 1 2 2 2 1 ...
# ...
# all other are int, but  gender  : Factor w/ 2 levels "F","M"
# This is OK

# Access the dplyr library
library(dplyr)

# questions related to deep, surface and strategic learning, as from the datacamp exercise

deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30", "D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

# create a new dataset with only the desired columns

my_dataset <- data.frame(gender=lrn14$gender, age=lrn14$Age, attitude=lrn14$Attitude, deep=lrn14$deep, stra=lrn14$stra, surf=lrn14$surf, points=lrn14$Points)

# then drop out rows where points=0

my_nonzero_dataset <- my_dataset[my_dataset$points != 0,]


# Check that we got it right!

str(my_nonzero_dataset)
 
# 'data.frame':	166 obs. of  7 variables:
#   $ gender  : Factor w/ 2 levels "F","M": 1 2 1 2 2 1 2 1 2 1 ...
# $ age     : int  53 55 49 53 49 38 50 37 37 42 ...
# $ attitude: int  37 31 25 35 37 38 35 29 38 21 ...
# $ deep    : num  3.58 2.92 3.5 3.5 3.67 ...
# $ stra    : num  3.38 2.75 3.62 3.12 3.62 ...
# $ surf    : num  2.58 3.17 2.25 2.25 2.83 ...
# $ points  : int  25 12 24 10 22 21 21 31 24 26 ... 

# looks OK! 


# Now let's save this. 
# Let's not use numbered rows.

write.csv(my_nonzero_dataset, file = "learning2014.csv",row.names = FALSE)


# Now let's see how this reads back in!

testdata <- read.csv("learning2014.csv")


head(testdata)

#gender age attitude     deep  stra     surf points
#1      F  53       37 3.583333 3.375 2.583333     25
#2      M  55       31 2.916667 2.750 3.166667     12
#3      F  49       25 3.500000 3.625 2.250000     24
#4      M  53       35 3.500000 3.125 2.250000     10
#5      M  49       37 3.666667 3.625 2.833333     22
#6      F  38       38 4.750000 3.625 2.416667     21

# Seems OK


str(testdata)

#'data.frame':	166 obs. of  7 variables:
#$ gender  : Factor w/ 2 levels "F","M": 1 2 1 2 2 1 2 1 2 1 ...
#$ age     : int  53 55 49 53 49 38 50 37 37 42 ...
#$ attitude: int  37 31 25 35 37 38 35 29 38 21 ...
#$ deep    : num  3.58 2.92 3.5 3.5 3.67 ...
#$ stra    : num  3.38 2.75 3.62 3.12 3.62 ...
#$ surf    : num  2.58 3.17 2.25 2.25 2.83 ...
#$ points  : int  25 12 24 10 22 21 21 31 24 26 ...

# Quite alike to the original! Good job!
