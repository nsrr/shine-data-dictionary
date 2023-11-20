# Prepare SHINE for nsrr #

ver="0.1.0.pre2"

library(haven)
library(dplyr)

setwd("//rfawin.partners.org/bwh-sleepepi-nsrr-staging/20230504-shine/nsrr-prep/_datasets")

intake_main <- read_sas("intake_main.sas7bdat")
intake_dad <- read_sas("intake_dad.sas7bdat")

mom_anthro <- read_sas("mom_anthro.sas7bdat")
mom_anthro_0 <- mom_anthro[,c( "nsrrid",  "last_weight",   "prepreg_bmi", "prepreg_weight",   "gest_age",
                               "gest_weight_gain", "age_mom_delivery")]
mom_anthro_1 <- mom_anthro[,c( "nsrrid", "mom_height_v1",  "mom_weight_v1", "mom_bmi_v1")]
mom_anthro_2 <- mom_anthro[,c( "nsrrid", "mom_height_v2",  "mom_weight_v2", "mom_bmi_v2")]
mom_anthro_3 <- mom_anthro[,c( "nsrrid", "mom_height_v3",  "mom_weight_v3", "mom_bmi_v3")]
mom_anthro_4 <- mom_anthro[,c( "nsrrid", "mom_height_v4",  "mom_weight_v4", "mom_bmi_v4")]

mom_anthro_0$visitnumber <- 0
mom_anthro_1$visitnumber <- 1
mom_anthro_2$visitnumber <- 2
mom_anthro_3$visitnumber <- 3
mom_anthro_4$visitnumber <- 4

v1_main <- read_sas("v1_main.sas7bdat")
v2_dad <- read_sas("v2_dad.sas7bdat")

colnames(v2_dad) <- gsub("employment_f_int", 
                         "employment_f6_int", colnames(v2_dad))

child_anthro <- read_sas("child_anthro_100623.sas7bdat")
child_anthro$visitnumber[child_anthro$visitnumber=="birth data"] <- 0
child_anthro$visitnumber[child_anthro$visitnumber=="visit 1"] <- 1
child_anthro$visitnumber[child_anthro$visitnumber=="visit 2"] <- 2
child_anthro$visitnumber[child_anthro$visitnumber=="visit 3"] <- 3
child_anthro$visitnumber[child_anthro$visitnumber=="visit 4"] <- 4
child_anthro$visitnumber[child_anthro$visitnumber=="EHR data"] <- 99

child_anthro$visitnumber <- as.numeric(child_anthro$visitnumber)


v2_main <- read_sas("v2_main.sas7bdat")     
#v2_main$visit <- 2
v3_dad <- read_sas("v3_dad.sas7bdat")  
#v3_dad$visit <- 3
v3_main <- read_sas("v3_main.sas7bdat") 
#v3_main$visit <- 3
v4_main <- read_sas("v4_main.sas7bdat")  
#v4_main$visit <- 4

#take 'v?' out of variables to prep for long format

colnames(intake_main) <- gsub("_int","",colnames(intake_main))
colnames(intake_dad) <- gsub("_int","",colnames(intake_dad))
#colnames(mom_anthro_1) <- gsub("_v1","", colnames(mom_anthro_0))  
colnames(mom_anthro_1) <- gsub("_v1","", colnames(mom_anthro_1))  
colnames(mom_anthro_2) <- gsub("_v2","", colnames(mom_anthro_2))  
colnames(mom_anthro_3) <- gsub("_v3","", colnames(mom_anthro_3))  
colnames(mom_anthro_4) <- gsub("_v4","", colnames(mom_anthro_4))  
colnames(v1_main) <- gsub("_v1","",colnames(v1_main))
colnames(v2_dad) <- gsub("_v2","",colnames(v2_dad))
#colnames(child_anthro) <- gsub("_v3","",colnames(child_anthro))
colnames(v2_main) <- gsub("_v2","",colnames(v2_main))
colnames(v3_dad) <- gsub("_v3","",colnames(v3_dad))
colnames(v3_main) <- gsub("_v3","",colnames(v3_main))
colnames(v4_main) <- gsub("_v4","",colnames(v4_main))

#bpscX_mom is different questions for visits 2 and 3, so re-seperate

colnames(v2_main) <- gsub("bpsc", "bpsc_v2_", colnames(v2_main))
colnames(v3_main) <- gsub("bpsc", "bpsc_v3_", colnames(v3_main))

colnames(v2_main) <- gsub("swyc", "swyc_v2_", colnames(v2_main))
colnames(v3_main) <- gsub("swyc", "swyc_v3_", colnames(v3_main))

colnames(v2_dad) <- gsub("employment_f", "employment_f3", colnames(v2_dad))
colnames(v3_dad) <- gsub("employment_f", "employment_f5", colnames(v3_dad))
colnames(intake_dad) <- gsub("employment_f", "employment_f5", colnames(intake_dad))

colnames(v2_main) <- gsub("maternleave_mom", "employmtmatleave_mom", colnames(v2_main))
colnames(v2_main) <- gsub("matleavetime_mom", "employmtmatleavenum_mom", colnames(v2_main))
colnames(v2_main) <- gsub("matleavwkmo_mom", "emplymtmatleavewkmth_mom", colnames(v2_main))

colnames(v3_main) <- gsub("firstsolid_mom", "firstsolidfood_mom", colnames(v3_main))

colnames(v1_main) <- gsub("waktime_ampmag_mom", "waketimeampm_mom", colnames(v1_main))
colnames(v2_main) <- gsub("waktime_ampmag_mom", "waketimeampm_mom", colnames(v2_main))


allvars <- data.frame(matrix(ncol = 622, nrow = 433))
x <- unique(c( colnames(intake_main),
  colnames(mom_anthro_0),
  colnames(intake_dad), 
  colnames(mom_anthro_1),
  colnames(mom_anthro_2),
  colnames(mom_anthro_3), 
  colnames(mom_anthro_4),
  colnames(v1_main),
  colnames(v2_dad),
  colnames(v2_main),
  colnames(v3_dad),
  colnames(v3_main),
  colnames(v4_main)))
colnames(allvars) <- x
allvars$nsrrid <- unique(intake_main$nsrrid)

#match some class for this variable
v2_main$feed1_mom <- as.numeric(v2_main$feed1_mom)

#make 1 dataset per visit, with a full set of variables, so we can rowbind
v0 <-intake_main %>% full_join(intake_dad, by="nsrrid") %>%
     full_join(mom_anthro_0, by="nsrrid") 
v1 <-mom_anthro_1 %>% full_join(v1_main, by="nsrrid")
v2 <-mom_anthro_2 %>%  full_join(v2_main, by="nsrrid") %>%  full_join(v2_dad, by="nsrrid") 
v3 <-mom_anthro_3 %>% full_join(v3_dad, by="nsrrid")  %>% full_join(v3_main, by="nsrrid") 
v4 <-mom_anthro_4 %>%  full_join(v4_main, by="nsrrid") 

v0 <- v0 %>% full_join(allvars[,c("nsrrid", setdiff(colnames(allvars),colnames(v0)))])
v1 <- v1 %>% full_join(allvars[,c("nsrrid", setdiff(colnames(allvars),colnames(v1)))])
v2 <- v2 %>% full_join(allvars[,c("nsrrid", setdiff(colnames(allvars),colnames(v2)))])
v3 <- v3 %>% full_join(allvars[,c("nsrrid", setdiff(colnames(allvars),colnames(v3)))])
v4 <- v4 %>% full_join(allvars[,c("nsrrid", setdiff(colnames(allvars),colnames(v4)))])

v0$visitnumber <- 0
v1$visitnumber <- 1
v2$visitnumber <- 2
v3$visitnumber <- 3
v4$visitnumber <- 4

all_data <- rbind(v0, v1, v2, v3, v4)
all_data <- left_join(all_data, child_anthro, by=c("nsrrid", "visitnumber"))

#fix emplotmeny status consistency
colnames(all_data) <- gsub("employmntstatus_mom","employmtstatus_mom",colnames(all_data))
# fix take child bed from take bay bed
colnames(all_data) <- gsub("takebabybed_mom","takechildbed_mom",colnames(all_data))


all_data <- all_data[,sort(colnames(all_data))]

dict <- read.csv("C:/Users/mkt27/shine-data-dictionary/imports/shine-data-dictionary-0.1.0.pre-variables.csv")


data <- cbind(all_data[, c(colnames(all_data)%in%c(dict$id))],
              all_data[,c("httfeet_f","htinch_f", "visitnumber", "employment_f5", "employment_f3")])

# not req in needed dataset
# time w baby variables should be numeric, units tbd
# make_numeric <- c("timeinusyrs_f",
#   "timewbaby10_f",
#   "timewbaby1_f",
#   "timewbaby2_f",
#   "timewbaby3_f",
#   "timewbaby4_f",
#   "timewbaby5_f",
#   "timewbaby6_f",
#   "timewbaby7_f",
#   "timewbaby8_f",
#   "timewbaby9_f")

# for(i in make_numeric){
#   data[,i] <- as.numeric(data[,i])
# }

#Height for father, inches in htinch_f_int variable
# feet 1 = 4 feet, 2 = 5 feet, 3 = 6 feet
#Height for father, inches in htinch_f_int variable
# inches: 1 = 0 inches, 2=1inches, 3=2inches etc 



data$httfeet_f[data$httfeet_f==1] <- 4
data$httfeet_f[data$httfeet_f==2] <- 5
data$httfeet_f[data$httfeet_f==3] <- 6

data$htinch_f <- data$htinch_f -1

data$fath_height <- data$httfeet_f*30.48 + data$htinch_f*2.54
data$httfeet_f <- NULL
data$htinch_f <- NULL

setwd("//rfawin.partners.org/bwh-sleepepi-nsrr-staging/20230504-shine/nsrr-prep/_releases")
write.csv(data, paste(ver,"/shine-dataset-",ver,".csv",sep=""), row.names = F, na="")








