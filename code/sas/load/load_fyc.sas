ods graphics off;

/* Read in dataset and initialize year */
FILENAME &FYC. "&PUFdir.\&FYC..ssp";
proc xcopy in = &FYC. out = WORK IMPORT;
run;

data MEPS;
	SET &FYC.;
	ARRAY OLDVAR(5) VARPSU&yy. VARSTR&yy. WTDPER&yy. AGE2X AGE1X;
	year = &year.;
	ind = 1;
	count = 1;

	if year <= 2001 then do;
		VARPSU = VARPSU&yy.;
		VARSTR = VARSTR&yy.;
	end;

	if year <= 1998 then do;
		PERWT&yy.F = WTDPER&yy.;
	end;

	/* Create AGELAST variable */
	if year = 1996 then do;
	  AGE42X = AGE2X;
	  AGE31X = AGE1X;
	end;

	if AGE&yy.X >= 0 then AGELAST = AGE&yy.x;
	else if AGE42X >= 0 then AGELAST = AGE42X;
	else if AGE31X >= 0 then AGELAST = AGE31X;
run;

proc format;
	value ind 1 = "Total";
run;
