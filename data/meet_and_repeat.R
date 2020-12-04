# Seppo Nyrkkö Dec 4, 2020
# IODS Exercise 6 - Data wrangling for longitudinal analysis

library(dplyr)
library(tidyr)

# i) read the RATS and BPRS files in

rats <- read.table("rats.txt",header = T)
bprs <- read.table("BPRS.txt", header=T)

# ii) Study the data and factorize the categorical data

str(rats)

# rats = Rat growth rates. Rats were weighted on 11 control days (WDnn columns)
# Three different diet groups. Each rat has an unique ID. 
# Each ID is only in one diet group.
# Data Includes 2 category variables: ID and test group. Let's factorize them

rats$ID <- factor(paste0("rat-",rats$ID))
rats$Group <- factor(paste0("Grp",rats$Group))

summary(rats)

# seems ok now

# Now the second data (BPRS rating for patients):

str(bprs)

# bprs = Rating of treatments on psychiatric patients. 
# Followups for 8 weeks.
# Two treatments (real=study and control=normal groups)

# Subjects are unique ID-numerified within the control group.
# This could cause strange effects, must be made unique!

# Data includes 2 category variables: treatment and subject. Factor magic again...

bprs$subject=factor(paste0("G",bprs$treatment,"P",bprs$subject))
bprs$treatment=factor(paste0("T",bprs$treatment))

summary(bprs)
summary(bprs$treatment)
summary(bprs$subject)

# factorized ok. Let's continue

# iii) we need to change these to the long format.

# BPRS: Add week data. Keep the treatment and subject categories

bprslong <- gather(bprs, key=weeks, value=bprs, -treatment, -subject)

# change the weeks to numeric, drop the "week" prefix.

bprslong$weeks = as.numeric(substr(bprslong$weeks,5,999))

glimpse(bprslong)

# Rats: weights in columns, by days.

ratslong <- gather(rats, key=days, value=weight, -ID, -Group)

# convert the days into numeric from WDnn
ratslong$days <- as.numeric(substr(ratslong$days,3,999))

glimpse(ratslong)

# looks good

# iv) ready to save the data!

# This long data makes sense for the analysis since the factors are kind of
# categorical data which may not be the main point of the study
# The most interesting thing, ie. the time and measurement "run" through 
# the rows from top to bottom, and the treatments and diets
# can be modeled as a function of time.

write.csv(file = "ratslong.csv", x = ratslong, row.names = F)
write.csv(file = "bprslong.csv", x = bprslong, row.names = F)

# test the reads

testrats <- read.csv("ratslong.csv")
glimpse(testbprs)

testbprs <- read.csv("bprslong.csv")
glimpse(testbprs)

# wonderful, ok
