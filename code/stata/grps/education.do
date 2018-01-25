/* Education */
use MEPS.dta

capture confirm variable educyr
if !_rc {
	di "educyr does exist"
}
else {
	gen educyr=0
}


forvalues i = 96/98 {
capture confirm variable educyr`i'
if !_rc {
	replace educyr=educyr`i' if year==19`i'
}
else {
	di "educyr`i' does not exist"
	}
}
			   
capture confirm variable educyear
if !_rc {
	replace educyr=educyear if year<=2004
}
else {
	di "educyear does not exist"
}

gen less_than_hs = (0 <= educyr & educyr < 12)			   
gen high_school  = (educyr ==12)
gen some_college = (educyr > 12)
			   
capture confirm variable edrecode
if !_rc {
	replace less_than_hs = (0 <= edrecode & edrecode < 13) if year>=2012
	replace high_school = (edrecode == 13) if year>=2012
	replace some_college = (edrecode > 13) if year>=2012
}
else {
	di "edrecode does not exist"
}
			   
gen education = 1*less_than_hs + 2*high_school + 3*some_college
replace education=9 if agelast<18
replace education=0 if education==.
label define education 1 "Less than high school" 2 "High school" 3 "Some college" 9 "Inapplicable (age < 18)" 0 "Missing" , replace
label values education education
