ods graphics off;

/* Read in dataset and initialize year */
FILENAME h70 "C:\MEPS\h70.ssp";
proc xcopy in = h70 out = WORK IMPORT;
run;

data MEPS;
 SET h70;
 year = 2002;
 ind = 1;
 count = 1;

 /* Create AGELAST variable */
 if AGE02X >= 0 then AGELAST=AGE02x;
 else if AGE42X >= 0 then AGELAST=AGE42X;
 else if AGE31X >= 0 then AGELAST=AGE31X;
run;

proc format;
 value ind 1 = "Total";
run;

/* Perceived health status */
data MEPS; set MEPS;
 ARRAY OLDHLT(2) RTEHLTH1 RTEHLTH2;
 if year = 1996 then do;
  RTHLTH53 = RTEHLTH2;
  RTHLTH42 = RTEHLTH2;
  RTHLTH31 = RTEHLTH1;
 end;

 if RTHLTH53 >= 0 then health = RTHLTH53;
 else if RTHLTH42 >= 0 then health = RTHLTH42;
 else if RTHLTH31 >= 0 then health = RTHLTH31;
 else health = .;
run;

proc format;
 value health
 1 = "Excellent"
 2 = "Very good"
 3 = "Good"
 4 = "Fair"
 5 = "Poor"
 . = "Missing";
run;

/* Ability to schedule a routine appt. (adults) */
data MEPS; set MEPS;
 adult_routine = ADRTWW42;
 domain = (ADRTCR42 = 1 & AGELAST >= 18);
 if domain = 0 and SAQWT02F = 0 then SAQWT02F = 1;
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
 FORMAT adult_routine freq. health health.;
 STRATA VARSTR;
 CLUSTER VARPSU;
 WEIGHT SAQWT02F;
 TABLES domain*health*adult_routine / row;
run;

proc print data = out;
 where domain = 1 and adult_routine ne . and health ne .;
 var adult_routine health WgtFreq StdDev Frequency RowPercent RowStdErr;
run;
