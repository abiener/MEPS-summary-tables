ods graphics off;

/* Read in dataset and initialize year */
FILENAME h38 "C:\MEPS\h38.ssp";
proc xcopy in = h38 out = WORK IMPORT;
run;

data MEPS;
 SET h38;
 ARRAY OLDVAR(5) VARPSU99 VARSTR99 WTDPER99 AGE2X AGE1X;
 year = 1999;
 ind = 1;
 count = 1;

 if year <= 2001 then do;
  VARPSU = VARPSU99;
  VARSTR = VARSTR99;
 end;

 if year <= 1998 then do;
  PERWT99F = WTDPER99;
 end;

 /* Create AGELAST variable */
 if year = 1996 then do;
   AGE42X = AGE2X;
   AGE31X = AGE1X;
 end;

 if AGE99X >= 0 then AGELAST = AGE99x;
 else if AGE42X >= 0 then AGELAST = AGE42X;
 else if AGE31X >= 0 then AGELAST = AGE31X;
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

/* Load event files */
%macro load_events(evnt,file) / minoperator;

 FILENAME &file. "C:\MEPS\&file..ssp";
 proc xcopy in = &file. out = WORK IMPORT;
 run;

 data &evnt;
  SET &syslast; /* Most recent dataset loaded */
  ARRAY OLDVARS(2) LINKIDX EVNTIDX;
  event = "&evnt.";
  year = 1999;

  %if &evnt in (IP OP ER) %then %do;
  ARRAY OLDVARS2(3) &evnt.DCH99X &evnt.FCH99X SEEDOC ;
   SF99X = &evnt.DSF99X + &evnt.FSF99X;
   MR99X = &evnt.DMR99X + &evnt.FMR99X;
   MD99X = &evnt.DMD99X + &evnt.FMD99X;
   PV99X = &evnt.DPV99X + &evnt.FPV99X;
   VA99X = &evnt.DVA99X + &evnt.FVA99X;
   OF99X = &evnt.DOF99X + &evnt.FOF99X;
   SL99X = &evnt.DSL99X + &evnt.FSL99X;
   WC99X = &evnt.DWC99X + &evnt.FWC99X;
   OR99X = &evnt.DOR99X + &evnt.FOR99X;
   OU99X = &evnt.DOU99X + &evnt.FOU99X;
   OT99X = &evnt.DOT99X + &evnt.FOT99X;
   XP99X = &evnt.DXP99X + &evnt.FXP99X;

   if year <= 1999 then TR99X = &evnt.DCH99X + &evnt.FCH99X;
   else TR99X = &evnt.DTR99X + &evnt.FTR99X;
  %end;

  %else %do;
  ARRAY OLDVARS2(2) &evnt.CH99X SEEDOC ;
   SF99X = &evnt.SF99X;
   MR99X = &evnt.MR99X;
   MD99X = &evnt.MD99X;
   PV99X = &evnt.PV99X;
   VA99X = &evnt.VA99X;
   OF99X = &evnt.OF99X;
   SL99X = &evnt.SL99X;
   WC99X = &evnt.WC99X;
   OR99X = &evnt.OR99X;
   OU99X = &evnt.OU99X;
   OT99X = &evnt.OT99X;
   XP99X = &evnt.XP99X;

   if year <= 1999 then TR99X = &evnt.CH99X;
   else TR99X = &evnt.TR99X;
  %end;

  PR99X = PV99X + TR99X;
  OZ99X = OF99X + SL99X + OT99X + OR99X + OU99X + WC99X + VA99X;

  keep DUPERSID LINKIDX EVNTIDX event SEEDOC XP99X SF99X PR99X MR99X MD99X OZ99X;
 run;
%mend;

%load_events(RX,h33a);
%load_events(DV,h33b);
%load_events(IP,h33d);
%load_events(ER,h33e);
%load_events(OP,h33f);
%load_events(OB,h33g);
%load_events(HH,h33h);

/* Define sub-levels for office-based, outpatient, and home health */
data OB; set OB;
 if SEEDOC = 1 then event_v2X = 'OBD';
 else if SEEDOC = 2 then event_v2X = 'OBO';
 else event_v2X = '';
run;

data OP; set OP;
 if SEEDOC = 1 then event_v2X = 'OPY';
 else if SEEDOC = 2 then event_v2X = 'OPZ';
 else event_v2X = '';
run;

/* Merge with FYC file */
data FYCsub; set MEPS;
 keep sex DUPERSID PERWT99F VARSTR VARPSU;
run;

proc format;
 value CCCFMT
  -9 - -1                = [2.]
  1-9                    = 'Infectious diseases                                         '
  11-45                  = 'Cancer                                                      '
  46, 47                 = 'Non-malignant neoplasm                                      '
  48                     = 'Thyroid disease                                             '
  49,50                  = 'Diabetes mellitus                                           '
  51, 52, 54 - 58        = 'Other endocrine, nutritional & immune disorder              '
  53                     = 'Hyperlipidemia                                              '
  59                     = 'Anemia and other deficiencies                               '
  60-64                  = 'Hemorrhagic, coagulation, and disorders of White Blood cells'
  65-75, 650-670         = 'Mental disorders                                            '
  76-78                  = 'CNS infection                                               '
  79-81                  = 'Hereditary, degenerative and other nervous system disorders '
  82                     = 'Paralysis                                                   '
  84                     = 'Headache                                                    '
  83                     = 'Epilepsy and convulsions                                    '
  85                     = 'Coma, brain damage                                          '
  86                     = 'Cataract                                                    '
  88                     = 'Glaucoma                                                    '
  87, 89-91              = 'Other eye disorders                                         '
  92                     = 'Otitis media                                                '
  93-95                  = 'Other CNS disorders                                         '
  98,99                  = 'Hypertension                                                '
  96, 97, 100-108        = 'Heart disease                                               '
  109-113                = 'Cerebrovascular disease                                     '
  114 -121               = 'Other circulatory conditions arteries, veins, and lymphatics'
  122                    = 'Pneumonia                                                   '
  123                    = 'Influenza                                                   '
  124                    = 'Tonsillitis                                                 '
  125 , 126              = 'Acute Bronchitis and URI                                    '
  127-134                = 'COPD, asthma                                                '
  135                    = 'Intestinal infection                                        '
  136                    = 'Disorders of teeth and jaws                                 '
  137                    = 'Disorders of mouth and esophagus                            '
  138-141                = 'Disorders of the upper GI                                   '
  142                    = 'Appendicitis                                                '
  143                    = 'Hernias                                                     '
  144- 148               = 'Other stomach and intestinal disorders                      '
  153-155                = 'Other GI                                                    '
  149-152                = 'Gallbladder, pancreatic, and liver disease                  '
  156-158, 160, 161      = 'Kidney Disease                                              '
  159                    = 'Urinary tract infections                                    '
  162,163                = 'Other urinary                                               '
  164-166                = 'Male genital disorders                                      '
  167                    = 'Non-malignant breast disease                                '
  168-176                = 'Female genital disorders, and contraception                 '
  177-195                = 'Complications of pregnancy and birth                        '
  196, 218               = 'Normal birth/live born                                      '
  197-200                = 'Skin disorders                                              '
  201-204                = 'Osteoarthritis and other non-traumatic joint disorders      '
  205                    = 'Back problems                                               '
  206-209, 212           = 'Other bone and musculoskeletal disease                     '
  210-211                = 'Systemic lupus and connective tissues disorders             '
  213-217                = 'Congenital anomalies                                        '
  219-224                = 'Perinatal Conditions                                        '
  225-236, 239, 240, 244 = 'Trauma-related disorders                                    '
  237, 238               = 'Complications of surgery or device                          '
  241 - 243              = 'Poisoning by medical and non-medical substances             '
  259                    = 'Residual Codes                                              '
  10, 254-258            = 'Other care and screening                                    '
  245-252                = 'Symptoms                                                    '
  253                    = 'Allergic reactions                                          '
  OTHER                  = 'Other                                                       '
  ;
run;


data RX;
 set RX;
 EVNTIDX = LINKIDX;
run;

/* Sum RX purchases for each event */
proc sort data = RX; by event DUPERSID EVNTIDX; run;
proc means data = RX noprint;
 by event DUPERSID EVNTIDX;
 var SF99X MR99X MD99X XP99X PR99X OZ99X;
 output out = RXpers sum = ;
run;

data stacked_events;
 set RXpers IP ER OP OB HH;
 where XP99X >= 0;
 count = 1;
 ind = 1;
run;

/* Read in event-condition linking file */
FILENAME h33if1 "C:\MEPS\h33if1.ssp";
proc xcopy in = h33if1 out = WORK IMPORT; run;
data clink1;
 set &syslast;
 keep DUPERSID CONDIDX EVNTIDX;
run;

FILENAME h37 "C:\MEPS\h37.ssp";
proc xcopy in = h37 out = WORK IMPORT; run;
data Conditions;
 set &syslast;
 keep DUPERSID CONDIDX CCCODEX condition;
 CCS_code = CCCODEX*1;
 condition = PUT(CCS_code, CCCFMT.);
run;

proc sort data = clink1; by DUPERSID CONDIDX; run;
proc sort data = conditions; by DUPERSID CONDIDX; run;
data cond;
 merge clink1 conditions;
 by DUPERSID CONDIDX;
run;

proc sort data = cond nodupkey; by DUPERSID EVNTIDX condition; run;
proc sort data = stacked_events; by DUPERSID EVNTIDX; run;
data event_cond;
 merge stacked_events cond;
 by DUPERSID EVNTIDX;
 if condition in ("-1","-9","") or XP99X < 0 then delete;
run;

proc sort data = FYCsub; by DUPERSID; run;
data all_events;
 merge event_cond FYCsub;
 by DUPERSID;
 count = 1;
 ind = 1;
run;

proc sort data = all_events;
 by sex DUPERSID VARSTR VARPSU PERWT99F Condition ind count;
run;

proc means data = all_events noprint;
 by sex DUPERSID VARSTR VARPSU PERWT99F Condition ind count;
 var SF99X MR99X MD99X XP99X PR99X OZ99X;
 output out = all_pers sum = ;
run;

ods output Domain = out;
proc surveymeans data = all_pers mean ;
 FORMAT sex sex.;
 stratum VARSTR;
 cluster VARPSU;
 weight PERWT99F;
 var XP99X;
 domain Condition*sex ;
run;
