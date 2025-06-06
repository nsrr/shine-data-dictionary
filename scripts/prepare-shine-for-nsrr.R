# Prepare SHINE for nsrr #

ver="0.2.0"

library(haven)
library(dplyr)


setwd("/Volumes/bwh-sleepepi-nsrr-staging/20230504-shine/nsrr-prep/_datasets")

act_sum <- read_sas("shinechildsleepsummary_nsrr.sas7bdat")
act_sum$visitnumber <- act_sum$timepoint

#match subject to NSRR ID with Key
key <- read.csv("/Volumes/bwh-sleepepi-nsrr-staging/20230504-shine/nsrr-prep/_datasets/NSRR_RiseandSHINE_randomid_key.csv")
colnames(key) <- c("subject", "nsrrid")
act_sum <- full_join(act_sum, key, by="subject")

#drop 49 blank rows
act_sum <- act_sum[!is.na(act_sum$visitnumber),]
#drop some variables, slice ID's and dates
act_sum <- act_sum[,colnames(act_sum)[!colnames(act_sum)%in%c("act_sheet_id", "dia_sheet_id", 
                     "startdate_dia","enddate_dia",  "startdate_act","enddate_act","subject", "timepoint")]]

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
child_anthro$visitnumber <- NA
child_anthro$visitnumber[child_anthro$visit=="birth data"] <- 0
child_anthro$visitnumber[child_anthro$visit=="visit 1"] <- 1
child_anthro$visitnumber[child_anthro$visit=="visit 2"] <- 2
child_anthro$visitnumber[child_anthro$visit=="visit 3"] <- 3
child_anthro$visitnumber[child_anthro$visit=="visit 4"] <- 4
child_anthro$visitnumber[child_anthro$visit==("survey data")] <- 97
child_anthro$visitnumber[child_anthro$visit==("")] <- 98
child_anthro$visitnumber[child_anthro$visit==("EHR data")] <- 99

child_anthro$visitnumber <- as.numeric(child_anthro$visitnumber)
child_anthro <- child_anthro[,c("nsrrid", "visitnumber", colnames(child_anthro)[!colnames(child_anthro)%in%c("nsrrid", "visitnumber")])]
child_anthro$visit <- NULL


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

colnames(v3_main) <- gsub("employmntstatus_mom","employmtstatus_mom",colnames(v3_main))

colnames(v1_main) <- gsub("takebabybed_mom","takechildbed_mom",colnames(v1_main))
colnames(v2_main) <- gsub("takebabybed_mom","takechildbed_mom",colnames(v2_main))


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
allvars <- data.frame(matrix(ncol = length(x), nrow = 433))
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
all_data <- left_join(all_data, child_anthro[child_anthro$visitnumber%in%0:4,], by=c("nsrrid", "visitnumber"))

#fix emplotmeny status consistency
#colnames(all_data) <- gsub("employmntstatus_mom","employmtstatus_mom",colnames(all_data))
# fix take child bed from take bay bed
#colnames(all_data) <- gsub("takebabybed_mom","takechildbed_mom",colnames(all_data))


all_data <- all_data[,sort(colnames(all_data))]

# Up-to-date Data dictionary can be generated and moved to this location
dict <- read.csv("/Volumes/bwh-sleepepi-nsrr-staging/20230504-shine/nsrr-prep/shine-data-dictionary-0.1.0.pre5-variables.csv")

#restrict to data that's in the current dictionary
data_select <- cbind(all_data[, c(colnames(all_data)%in%c(dict$id))],
              all_data[,c("httfeet_f","htinch_f")])

data <- full_join(data_select, act_sum, by=c("visitnumber", "nsrrid"))

# not required in current dataset"
#
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

#put visit and nsrrid at the front,
data <- data[,c("nsrrid", "visitnumber", colnames(data)[!colnames(data)%in%c("nsrrid", "visitnumber")])]

#pull race and sex across from intake to all visits
data <- data %>%
  group_by(nsrrid) %>%
  mutate(race_baby = unique(race_baby)[1],
         infantsex = unique(infantsex)[1])

# add missing code to missing maternal-reported father's height & weight
data$biofathht_cm[is.na(data$biofathht_cm)] <- "DK"
data$biofathwght_kg[is.na(data$biofathwght_kg)] <- "DK"

data$biofathwtyn_mom <- NULL
data$biofathhtyn_mom <- NULL

# combine months in US and years in US to 1 month's variable
# if we have both, multiply & add
data$countrymnths_mom[!is.na(data$countryyrs_mom)&!is.na(data$countrymnths_mom)] <- data$countrymnths_mom[!is.na(data$countryyrs_mom)&!is.na(data$countrymnths_mom)] +
  12*data$countryyrs_mom[!is.na(data$countryyrs_mom)&!is.na(data$countrymnths_mom)]
# if we only have year multiply
data$countrymnths_mom[!is.na(data$countryyrs_mom)&is.na(data$countrymnths_mom)] <- 12*data$countryyrs_mom[!is.na(data$countryyrs_mom)&is.na(data$countrymnths_mom)]
#drop years variable
data$countryyrs_mom <- NULL

#sort by ID

data <- data[order(data$nsrrid),]


# seperate shineparentsleepsummary to mother and father datasets and add suffixes
# match _subject with nsrrid

library(haven)      
library(dplyr)
library(readr) 

sas_file_path <- "/Volumes/BWH-SLEEPEPI-NSRR-STAGING/20230504-shine/nsrr-prep/_datasets/shineparentsleepsummary_nsrr.sas7bdat"
key_file_path <- "/Volumes/BWH-SLEEPEPI-NSRR-STAGING/20230504-shine/nsrr-prep/_datasets/NSRR_RiseandSHINE_randomid_key.csv"


shine_parent <- read_sas(sas_file_path)
nsrr_key <- read_csv(key_file_path)

shine_parent <- shine_parent %>%
  rename(participant_id = `_subject`)

shine_parent <- shine_parent %>%
  left_join(nsrr_key, by = "participant_id") %>%
  select(-participant_id) 

shine_mother <- shine_parent %>% 
  filter(paq_which_parent == 1)  

shine_father <- shine_parent %>% 
  filter(paq_which_parent == 2)  

add_suffix <- function(df, suffix, exclude_cols = c("nsrrid")) {
  col_names <- names(df)
  for (i in seq_along(col_names)) {
    if (!col_names[i] %in% exclude_cols) {
      col_names[i] <- paste0(col_names[i], suffix)
    }
  }
  names(df) <- col_names
  return(df)
}

shine_mother <- add_suffix(shine_mother, "_mother", exclude_cols = c("nsrrid"))
shine_father <- add_suffix(shine_father, "_father", exclude_cols = c("nsrrid"))

shine_mother <- shine_mother %>%
  select(-subjectidfull_mother, -paq_which_parent_mother) %>%
  rename(visitnumber = paq_visit_mother) %>%
  select(nsrrid, everything()) 

shine_father <- shine_father %>%
  select(-subjectidfull_father, -paq_which_parent_father) %>%
  rename(visitnumber = paq_visit_father) %>%
  select(nsrrid, everything())  

write.csv(shine_mother,"/Volumes/BWH-SLEEPEPI-NSRR-STAGING/20230504-shine/nsrr-prep/_datasets/shinemothersleepsummary_nsrr.csv",row.names = F, na = '')
write.csv(shine_father,"/Volumes/BWH-SLEEPEPI-NSRR-STAGING/20230504-shine/nsrr-prep/_datasets/shinefathersleepsummary_nsrr.csv",row.names = F, na = '')

data_with_mother <- data %>%
  left_join(shine_mother, by = c("nsrrid", "visitnumber"))
data_final <- data_with_mother %>%
  left_join(shine_father, by = c("nsrrid", "visitnumber"))
write.csv(data_final, 
          "/Volumes/BWH-SLEEPEPI-NSRR-STAGING/20230504-shine/nsrr-prep/_releases/0.2.0.pre/shine-dataset-0.2.0.pre.csv",
          row.names = FALSE, 
          na = '')

#Harmonized dataset
harmonized_data<-data[,c("nsrrid", "visitnumber","infant_agedays","infant_bmi","race_baby","infantsex")]%>%
	dplyr::mutate(nsrr_age=infant_agedays/365,
				  nsrr_bmi=infant_bmi,
				  nsrr_race=dplyr::case_when(
				  race_baby==1 ~ "white",
				  race_baby==2 ~ "black or african american",
				  race_baby==3 ~ "asian",
				  race_baby==4 ~ "hispanic",
				  race_baby==5 ~ "unknown",
				  TRUE ~ "not reported"
				  ),
				  nsrr_sex=dplyr::case_when(
				  infantsex==1 ~ "male",
				  infantsex==2 ~ "female",
				  TRUE ~ "not reported"
				))%>%
	select(nsrrid,visitnumber,nsrr_age,nsrr_race,nsrr_sex,nsrr_bmi)
				

setwd("/Volumes/bwh-sleepepi-nsrr-staging/20230504-shine/nsrr-prep/_releases")
write.csv(data, paste(ver,"/shine-dataset-",ver,".csv",sep=""), row.names = F, na="")
write.csv(harmonized_data, paste(ver,"/shine-harmonized-dataset-",ver,".csv",sep=""), row.names = F, na="")

names(child_anthro)[names(child_anthro) == 'visitnumber'] <- 'visitanthro'
write.csv(child_anthro, paste(ver,"/shine-child-anthropometry-dataset-",ver,".csv",sep=""), row.names = F, na="")



