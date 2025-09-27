*** Name : Valeriia Yakushko ***
*** Date: September 27, 2025 ***
*** Dataset: GSS 2017 (Cycle 31 Family) ***
*** Research Question: Is being a grandparent good for Canadian elderly's wellbeing? ***

*********************************************************
*** Step 1 - Data cleaning

** Target variables

*SLM_01         /*Subjective well-being*/
*GRNDPA         /*Grandparent's status*/
*NGRDCHDC       /*Number of grandchildren*/
*SEX            /*Gender*/
*AGEC           /*Age*/
*EHG3_01B       /*Educational attainment*/
*FAMINCG2       /*Family income*/
*BRTHCAN       /*Country of birth*/ 
*WGHT_PER      /*Basic  weighting factor*/

svyset [pweight = WGHT_PER]
keep SLM_01 GRNDPA NGRDCHDC SEX AGEC EHG3_01B FAMINCG2 BRTHCAN WGHT_PER

* Subjective well-being
tab SLM_01
tab SLM_01, nol
rename SLM_01 wellbeing
sum wellbeing

*Grandparent's status
tab GRNDPA
tab GRNDPA, nol
recode GRNDPA (1=1) (2=0), gen (gp_status)
tab gp_status

*Gender
tab SEX
tab SEX, nol
rename SEX gender
tab gender

*Number of grandchildren
tab NGRDCHDC
sum NGRDCHDC if gp_status == 1 & gender ==1 
sum NGRDCHDC if gp_status == 1 & gender ==2
sum NGRDCHDC if gp_status == 1
recode NGRDCHDC (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6/15=6), gen (num_grandchildren)
sum num_grandchildren  

*Educational attainment
tab EHG3_01B
tab EHG3_01B, nol
recode EHG3_01B (1=1) (2=2) (3/5=3) (6=4) (7=5), gen (education)
tab education 

*Family income
tab FAMINCG2 
tab FAMINCG2, nol
rename FAMINCG2 income
tab income  

*Age 
tab AGEC
rename AGEC age
tab age

******************************************
*** Step 2 - Analytical sample : only Canadian-bron people, aged 45+
svyset [pweight = WGHT_PER]
keep if age >= 45
tab age
tab BRTHCAN, nol
keep if BRTHCAN == 1
tab BRTHCAN 

*******************************************
*** Step 3 Descriptive statistics 

** For grandparents ***

tab gender if gp_status == 1
sum wellbeing if gp_status == 1
sum num_grandchildren if gp_status == 1
sum age if gp_status == 1 
tabulate education if gp_status == 1 
tabulate income if gp_status == 1

** For non-grandparents ***

tabulate gender if gp_status == 0
sum wellbeing if gp_status == 0
sum age if gp_status == 0
tabulate education if gp_status == 0
tabulate income if gp_status == 0

************************************
** Step 4 - OLS regression models

** Model 1
reg wellbeing i.gp_status
eststo m1

** Model 2
reg wellbeing i.gp_status i.gender
eststo m2

** Model 3
reg wellbeing i.gp_status i.gender age i.income i.education num_grandchildren
eststo m3

esttab m1 m2 m3 using "Table-2-THREE-MODELS-09-27.rtf", ///
    b(%4.2f) not nocon ///
    starlevels(* .05 ** .01 *** .001) nodepvars noci ///
    title("OLS Predicting elderly's wellbeing") ///
    mtitles("Model 1" "Model 2" "Model 3") ///
    replace




