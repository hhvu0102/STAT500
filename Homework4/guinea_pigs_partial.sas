/***********************************************
Problem 1:
analysis of the guinea pig survival times
from exercise 2.11 on pp. 52-53 of the Sleuth
**********************************************/

* Read in data;
data pigs_surv;
	infile "\\tsclient\D\Coursework\Stat 500 Fall 2020\Homework4\guinea_pigs.txt";
  	input pig time treatment $;
run;

* (a) t-test;
proc ttest data = pigs_surv sides = L;
	var time;
	class treatment;
run;

* (a) permutation test: First compute summary statistics for observed data;
proc sort data = pigs_surv;
	by treatment;
run;
proc means data = pigs_surv noprint;
	by treatment;
	var time;
	output out = stats_obs
		n = n
		mean = mean
		css = css;
run;

* permutation test: Generate 20,000 randomly selected permutaions;
proc multtest data = pigs_surv
				permutation
				nsample = 20000
                seed = 13
				pvals
				outsamp = pmt;
  	class treatment;
  	contrast "Bacilli - Control" 1 -1;
    test mean(time / lower);
run;

* permutation test: Computes the t-statistics for the permutations;
proc means data = pmt noprint;
	by _sample_ _class_;
	var time;
	output out = stats
		n = n
		mean = mean
		css = css;
run;
data stats_bacilli;
	set stats;
	if(_class_ = "Bacilli");
    	n1 = n;
		mean1 = mean;
		css1 = css;
	keep _sample_ n1 mean1 css1;
run;
data stats_control;
	set stats;
	if(_class_ = "Control");
    	n2 = n;
		mean2 = mean;
		css2 = css;
	keep _sample_ n2 mean2 css2;
run;
data stats_overall;
	merge stats_bacilli stats_control;
	by _sample_;
	t = (mean1-mean2)/sqrt(((css1+css2)/(n1+n2-2))*((1/n1)+(1/n2)));
run;

* permutation test: Count t-values, differences as extreme as the those for the observed data;
data stats_overall;
	set stats_overall;
	if(t le -3.14)
		then extreme_t = "yes";
		else extreme_t = "no";
run;
proc freq data = stats_overall;
	table extreme_t;
run;
* (b) Wilcoxon rank-sum test;
proc npar1way data=pigs_surv wilcoxon;
	class treatment;
	var time;
	exact wilcoxon / alpha=.05 maxtime=20
					 MC N=20000 Seed=7892441;
run;
* (c) box plots;
proc boxplot;
	plot time*treatment;
	title 'Boxplots for each group';
run;

* (d) Test for homogeneous variances using proc glm;
title 'GLM results for Difference in Survival Time';
proc glm data=pigs_surv alpha=.05 ;
	class treatment; 
	model time = treatment;
	means treatment / hovtest=bf;
    *output out=resid residual=r;
  run;
* (f) Test for normality in each group;
proc univariate data = pigs_surv normal;
	var time;
	by treatment;
	qqplot time / normal (mu = est sigma = est);

run;

