# Seppo Nyrkkö Nov 20, 2020
# Exercise 4 - Data wrangling with the human development and equality data

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