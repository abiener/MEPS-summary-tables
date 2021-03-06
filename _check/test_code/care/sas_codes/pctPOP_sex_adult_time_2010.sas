ods graphics off;

/* Read in dataset and initialize year */
FILENAME h138 "C:\MEPS\h138.ssp";
proc xcopy in = h138 out = WORK IMPORT;
run;

data MEPS;
 SET h138;
 year = 2010;
 ind = 1;
 count = 1;

 /* Create AGELAST variable */
 if AGE10X >= 0 then AGELAST=AGE10x;
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

/* How often doctor spent enough time (adults) */
data MEPS; set MEPS;
 adult_time = ADPRTM42;
 domain = (ADAPPT42 >= 1 & AGELAST >= 18);
 if domain = 0 and SAQWT10F = 0 then SAQWT10F = 1;
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
 FORMAT adult_time freq. sex sex.;
 STRATA VARSTR;
 CLUSTER VARPSU;
 WEIGHT SAQWT10F;
 TABLES domain*sex*adult_time / row;
run;

proc print data = out;
 where domain = 1 and adult_time ne . and sex ne .;
 var adult_time sex WgtFreq StdDev Frequency RowPercent RowStdErr;
run;
