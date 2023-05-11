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


write.csv(data, paste("shine-dataset-",ver,".csv",sep=""), row.names = F, na="")

classes <- ((sapply(data,class)))
