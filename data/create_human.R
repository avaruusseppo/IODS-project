# Seppo Nyrkkö Nov 20, 2020 + Nov 27, 2020
# Exercise 4 + 5 - Data wrangling with the human development and equality data

# The data

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors=F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors=F, na.strings="..")

# The Human development 
#   http://hdr.undp.org/en/content/human-development-index-hdi
# and Gender inequality 
#   http://hdr.undp.org/sites/default/files/hdr2015_technical_notes.pdf


# Let's explore the data loads ok

# dimensions (hd, gii)
dim(hd)
dim(gii)

# Structures overview (hd, gii)
str(hd)
str(gii)

# summaries of the data sets
summary(hd)
summary(gii)

# let's shorten the names

names(hd)
names(gii)

names(hd) <- c("hdirank","country","hdi","lifeexp","eduexpy","edumeany","gni","gnihdidiff")
names(gii) <- c("giirank","country","gii","matmort","adolbirth","parlrepr","f2edu","m2edu","flabor","mlabor")

# check all went right with the names

str(hd) 
str(gii)

# ok! now let's use the mutate from dplyr to calculate two columns

library(dplyr)

gii <- mutate(gii, ratiofm2edu = f2edu / m2edu)
gii <- mutate(gii, ratiofmlabor = flabor / mlabor)

# check all went ok
str(gii)

# inner join the data with country name

human <- inner_join(hd, gii, by=c("country"))

print("behold the new structure")
str(human)
dim(human)

# save the human data

write.csv(human, "human.csv", row.names = F)

# test the load

print("test load the csv:")

humantest <- read.csv("human.csv")
str(humantest)
dim(humantest)

# ok!

# Part 5: continuing... Nov 27 2020

# Loaded the ‘human’ data into R. 

str(human)
cat(names(human))

# This data set has has columns:
# hdirank country hdi lifeexp eduexpy edumeany gni gnihdidiff giirank
# gii matmort adolbirth parlrepr f2edu m2edu flabor mlabor ratiofm2edu ratiofmlabor
#
# combined from the Human development and Gender inequality statistics per country


# Mutate the data: transform the Gross National Income (GNI) variable to numeric 
# (Using string manipulation. Note that the mutation of 'human' was not done on DataCamp).
# (1 point)

str(human$gni)
as.numeric(gsub(',','',human$gni)) -> human$gni
str(human$gni)

# Exclude unneeded variables: keep only the columns matching the following variable names
# (described in the meta file above):  
# "Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", 
# "Mat.Mor", "Ado.Birth", "Parli.F"

keep_columns <- c("country", "ratiofm2edu", "ratiofmlabor", "eduexpy",
                  "lifeexp", "gni", "matmort", "adolbirth", "parlrepr")

names(human)

# select the 'keep_columns' to create a new dataset
library(tidyr)
library(dplyr)

human1 <-  dplyr::select(human,one_of(keep_columns))

# look at the summaries and structure of the data
summary(human1)
str(human1)

# Remove all rows with missing values...
human2 <- na.omit(human1)
str(human2)
# reduced to 162 obs and 9 variables, ok!

# Remove the observations which relate to regions ... not countries

human2$country

# The last 7 contains regions data, rows 1...155 are countries

human3 <- human2[1:155,]

str(human3)

# ok

human4 <- human3[,colnames(human3) != 'country']
rownames(human4) <- human3$country

# Define the row names of the data by the country names 
# and remove the country name column from the data.

str(human4)

# The data should now have 155 observations and 8 variables
# All OK.

# Save the human data again
write.csv(human4, "human.csv", row.names = T)






