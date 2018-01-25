/* Employment Status */
use MEPS.dta

capture confirm variable empst31
if !_rc {
	di "empst31 does exist"
}
else {
	gen empst31=0
}
capture confirm variable empst42
if !_rc {
	di "empst42 does exist"
}
else {
	gen empst42=0
}
capture confirm variable empst53
if !_rc {
	di "empst53 does exist"
}
else {
	gen empst53=0
}

capture confirm variable empst1
if !_rc {
	replace empst31=empst1 if year==1996
}
else {
di "empst1 does not exist"
}
capture confirm variable empst2
if !_rc {
	replace empst42=empst2 if year==1996
}
else {
di "empst2 does not exist"
}
capture confirm variable empst96
if !_rc {
	replace empst53=empst96 if year==1996
}
else {
di "empst96 does not exist"
}

gen employ_last=empst53 if empst53>=0
replace employ_last=empst42 if employ_last==. & empst42>0
replace employ_last=empst31 if employ_last==. & empst31>0

gen employed = 1*(employ_last = 1) + 2*(employ_last > 1)
replace employed=. if employ_last==.
replace employed=9 if employed<1 and agelast<16
replace employed=0 if employed==.
label define employed 1 "Employed" 2 "Not employed" 9 "Inapplicable (age < 16)" 0 "Missing", replace
label values employed employed
