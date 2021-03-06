ods graphics off;

/* Read in dataset and initialize year */
FILENAME h129 "C:\MEPS\h129.ssp";
proc xcopy in = h129 out = WORK IMPORT;
run;

data MEPS;
 SET h129;
 year = 2009;
 ind = 1;
 count = 1;

 /* Create AGELAST variable */
 if AGE09X >= 0 then AGELAST=AGE09x;
 else if AGE42X >= 0 then AGELAST=AGE42X;
 else if AGE31X >= 0 then AGELAST=AGE31X;
run;

proc format;
 value ind 1 = "Total";
run;

/* Sex */
proc format;
 value sex
 1 = "Male"
 2 = "Female";
run;

/* Ability to schedule a routine appt. (adults) */
data MEPS; set MEPS;
 adult_routine = ADRTWW42;
 domain = (ADRTCR42 = 1 & AGELAST >= 18);
 if domain = 0 and SAQWT09F = 0 then SAQWT09F = 1;
run;


proc format;
  value freq
   4 = "Always"
   3 = "Usually"
   2 = "Sometimes/Never"
   1 = "Sometimes/Never"
  -7 = "Don't know/Non-response"
  -8 = "Don't know/Non-response"
  -9 = "Don't know/Non-response"
  -1 = "Inapplicable"
  . = "Missing";
run;


ods output CrossTabs = out;
proc surveyfreq data = MEPS missing;
 FORMAT adult_routine freq. sex sex.;
 STRATA VARSTR;
 CLUSTER VARPSU;
 WEIGHT SAQWT09F;
 TABLES domain*sex*adult_routine / row;
run;

proc print data = out;
 where domain = 1 and adult_routine ne . and sex ne .;
 var adult_routine sex WgtFreq StdDev Frequency RowPercent RowStdErr;
run;
