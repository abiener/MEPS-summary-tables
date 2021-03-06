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

/* Employment Status */
data MEPS; set MEPS;
 ARRAY OLDEMP(3) EMPST1 EMPST2 EMPST96;
 if year = 1996 then do;
  EMPST53 = EMPST96;
  EMPST42 = EMPST2;
  EMPST31 = EMPST1;
 end;

 if EMPST53 >= 0 then employ_last = EMPST53;
 else if EMPST42 >= 0 then employ_last = EMPST42;
 else if EMPST31 >= 0 then employ_last = EMPST31;
 else employ_last = .;

 employed = 1*(employ_last = 1) + 2*(employ_last > 1);
 if employed < 1 and AGELAST < 16 then employed = 9;
run;

proc format;
 value employed
 1 = "Employed"
 2 = "Not employed"
 9 = "Inapplicable (age < 16)"
 . = "Missing"
 0 = "Missing";
run;

/* Adults advised to quit smoking */
data MEPS; set MEPS;
 ARRAY SMKVAR(2) ADDSMK42 ADNSMK42;
 if year <= 2002 then adult_nosmok = ADDSMK42;
 else adult_nosmok = ADNSMK42;

 domain = (ADSMOK42=1 & CHECK53=1);
 if domain = 0 and SAQWT02F = 0 then SAQWT02F = 1;
run;

proc format;
 value adult_nosmok
  1 = "Told to quit"
  2 = "Not told to quit"
  3 = "Had no visits in the last 12 months"
 -9 = "Not ascertained"
 -1 = "Inapplicable";
run;

ods output CrossTabs = out;
proc surveyfreq data = MEPS missing;
 FORMAT adult_nosmok adult_nosmok. employed employed.;
 STRATA VARSTR;
 CLUSTER VARPSU;
 WEIGHT SAQWT02F;
 TABLES domain*employed*adult_nosmok / row;
run;

proc print data = out;
 where domain = 1 and adult_nosmok ne . and employed ne .;
 var adult_nosmok employed WgtFreq StdDev Frequency RowPercent RowStdErr;
run;
