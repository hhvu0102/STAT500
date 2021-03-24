/* Problem 6 */
* Permutation test using 25000 new random assignments;

* Read in data;
data systolich;
	infile "\\tsclient\D\Coursework\Stat 500 Fall 2020\Homework2\systolich.txt";
	input patient trt y;
run;
proc multtest data = systolich
		permutation
		nsample = 25000
		seed = 13 
		pvals
		outsamp = pmt;
	class trt;
	contrast "gold vs new" 1 -1;
	test mean(y);
run; 
* Compute t-values for the permutations and create a histogram;
proc means data = pmt noprint;
	by _sample_ _class_;
	var y;
	output out = stats 
		n = n 
		mean = mean 
		css = css;
run;
data stats1; 
	set stats; 
	if(_class_ = 1);
	n1 = n;
	mean1 = mean;
	css1 = css;
	keep _sample_ n1 mean1 css1;
run;
data stats2; 
	set stats; 
	if(_class_ = 2);
	n2 = n;
	mean2 = mean;
	css2 = css;
	keep _sample_ n2 mean2 css2;
run;
data stats3;
	merge stats1 stats2;
	by _sample_;
	t = (mean1-mean2)/sqrt(((css1+css2)/(n1+n2-2))*((1/n1)+(1/n2)));
	diff = mean1-mean2;
run;
title 't-values for 25000 Random Permutations';
proc sgplot data = stats3; 
	histogram t;
	density t / type = normal (mu=0 sigma=1);
	density t / type = kernel;
	yaxis grid label = "Percent"
		labelattrs = (size=20)
		valueattrs = (size=15);
	xaxis display = (nolabel) 
		valueattrs = (size=15);
run;
title 'sample mean difference for 25000 Random Permutations';
proc sgplot data = stats3; 
	histogram diff;
	yaxis grid label = "Percent"
		labelattrs = (size=20)
		valueattrs = (size=15);
	xaxis display = (nolabel) 
		valueattrs = (size=15);
run;
* Count t-values, differences as extreme as the those for the observed data;
data stats3;
	set stats3;
	if(t le -1.967)
		then extreme_t = "yes";
		else extreme_t = "no";
	if(diff le -8.8667) 
		then extreme_diff = "yes";
		else extreme_diff = "no";
run;
proc freq data = stats3;
	table extreme_t extreme_diff;
run;
