# Prepare SHINE for nsrr #

ver="0.1.0.pre"

library(haven)
library(dplyr)

setwd("//rfawin.partners.org/bwh-sleepepi-nsrr-staging/20230504-shine/nsrr-prep/_datasets")

list.files()
intake_main <- read_sas("intake_main.sas7bdat")
intake_dad <- read_sas("intake_dad.sas7bdat")
mom_anthro <- read_sas("mom_anthro.sas7bdat")
v1_main <- read_sas("v1_main.sas7bdat")
v2_dad <- read_sas("v2_dad.sas7bdat")



data = full_join(full_join(full_join(full_join(intake_main, intake_dad, by="participant_id"),
mom_anthro, by="participant_id"), v1_main, by="participant_id"), v2_dad, by="participant_id")

# time w baby variables should be numeric, units tbd
data$timeinusyrs_f_v2 <- as.numeric(data$timeinusyrs_f_v2)
data$timewbaby10_f_v2 <- as.numeric(data$timewbaby10_f_v2)
data$timewbaby1_f_v2 <- as.numeric(data$timewbaby1_f_v2)
data$timewbaby2_f_v2 <- as.numeric(data$timewbaby2_f_v2)
data$timewbaby3_f_v2 <- as.numeric(data$timewbaby3_f_v2)
data$timewbaby4_f_v2 <- as.numeric(data$timewbaby4_f_v2)
data$timewbaby5_f_v2 <- as.numeric(data$timewbaby5_f_v2)
data$timewbaby6_f_v2 <- as.numeric(data$timewbaby6_f_v2)
data$timewbaby7_f_v2 <- as.numeric(data$timewbaby7_f_v2)
data$timewbaby8_f_v2 <- as.numeric(data$timewbaby8_f_v2)
data$timewbaby9_f_v2 <- as.numeric(data$timewbaby9_f_v2)

data$visitnumber <- 1

#Height for father, inches in htinch_f_int variable
# feet 1 = 4 feet, 2 = 5 feet, 3 = 6 feet

data$httfeet_f_int[data$httfeet_f_int==1] <- 4
data$httfeet_f_int[data$httfeet_f_int==2] <- 5
data$httfeet_f_int[data$httfeet_f_int==3] <- 6

data$fath_height <- data$httfeet_f_int*30.48 + data$htinch_f_int*2.54
data$httfeet_f_int <- NULL
data$htinch_f_int <- NULL

write.csv(data, paste("shine-dataset-",ver,".csv",sep=""), row.names = F, na="")
