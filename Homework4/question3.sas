* Read in data;
* standard = 1, extra = 2;
data set1;
  input house consumption trt;
  datalines;
    1 16.8 1
	2 16.2 1
	3 16.0 1
	4 28.6 1
	5 6.6 1
	6 19.3 1
	7 11.0 1
	8 14.7 1
	9 20.2 1
	10 21.0 1
	11 15.1 2
	12 13.9 2
	13 15.9 2
	14 17.2 2
	15 15.2 2
	16 13.8 2
	17 11.3 2
	18 13.2 2
	19 18.8 2
	20 14.0 2
  run;

* (a) t-test;
proc ttest data = set1 plots(unpack shownull) = all;
	var consumption;
	class trt;
run;

* (e) ;
/* change width of CI */
proc power;
twosamplemeans
alpha = 0.05
meandiff = 1
stddev= 4.4576
npergroup = .
power = 0.975;
run;
proc power;
twosamplemeans
	CI=DIFF
	PROBWIDTH=0.95
	HALFWIDTH=0.5
	alpha = 0.05
	stddev= 4.4576
	npergroup = .;
run;

proc sort data = set1;
	by trt;
run;
proc means data = set1 noprint;
	by trt;
	var consumption;
	output out = stats_obs
		n = n
		mean = mean
		css = css;
run;

* (f) Test for homogeneous variances using proc glm;
title 'GLM results for Difference in Consumption';
proc glm data=set1 alpha=.05 ;
	class consumption; 
	model consumption = trt;
	means consumption / hovtest=bf;
    *output out=resid residual=r;
  run;

  proc univariate data = set1 normal;
	var consumption;
	by trt;
	qqplot consumption / normal (mu = est sigma = est);

run;

proc npar1way data=set1 wilcoxon;
	class trt;
	var consumption;
	exact wilcoxon / alpha=.05 maxtime=20
					 MC N=20000 Seed=7892441;
run;
