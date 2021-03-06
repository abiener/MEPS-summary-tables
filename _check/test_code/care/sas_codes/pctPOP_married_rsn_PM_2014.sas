ods graphics off;

/* Read in dataset and initialize year */
FILENAME h171 "C:\MEPS\h171.ssp";
proc xcopy in = h171 out = WORK IMPORT;
run;

data MEPS;
 SET h171;
 year = 2014;
 ind = 1;
 count = 1;

 /* Create AGELAST variable */
 if AGE14X >= 0 then AGELAST=AGE14x;
 else if AGE42X >= 0 then AGELAST=AGE42X;
 else if AGE31X >= 0 then AGELAST=AGE31X;
run;

proc format;
 value ind 1 = "Total";
run;

/* Marital Status */
data MEPS; set MEPS;
 ARRAY OLDMAR(2) MARRY1X MARRY2X;
 if year = 1996 then do;
  if MARRY2X <= 6 then MARRY42X = MARRY2X;
  else MARRY42X = MARRY2X-6;

  if MARRY1X <= 6 then MARRY31X = MARRY1X;
  else MARRY31X = MARRY1X-6;
 end;

 if MARRY14X >= 0 then married = MARRY14X;
 else if MARRY42X >= 0 then married = MARRY42X;
 else if MARRY31X >= 0 then married = MARRY31X;
 else married = .;
run;

proc format;
 value married
 1 = "Married"
 2 = "Widowed"
 3 = "Divorced"
 4 = "Separated"
 5 = "Never married"
 6 = "Inapplicable (age < 16)"
 . = "Missing";
run;

/* Reason for difficulty receiving needed prescribed medicines */
data MEPS; set MEPS;
 delay_PM  = (PMUNAB42=1|PMDLAY42=1);
 afford_PM = (PMDLRS42=1|PMUNRS42=1);
 insure_PM = (PMDLRS42 in (2,3)|PMUNRS42 in (2,3));
 other_PM  = (PMDLRS42 > 3|PMUNRS42 > 3);
 domain = (ACCELI42 = 1 & delay_PM=1);
run;

proc format;
 value afford 1 = "Couldn't afford";
 value insure 1 = "Insurance related";
 value other 1 = "Other";
run;

ods output CrossTabs = out;
proc surveyfreq data = MEPS missing;
 FORMAT afford_PM afford. insure_PM insure. other_PM other. married married.;
 STRATA VARSTR;
 CLUSTER VARPSU;
 WEIGHT PERWT14F;
 TABLES domain*married*(afford_PM insure_PM other_PM) / row;
run;

proc print data = out;
 where domain = 1 and (afford_PM > 0 or insure_PM > 0 or other_PM > 0) and married ne .;
 var afford_PM insure_PM other_PM married WgtFreq StdDev Frequency RowPercent RowStdErr;
run;
