/* Read in the data set*/
  data set1; 
  	input trt y;
	datalines;
	1 4.8
	1 5.2
	1 5.0
	2 7.7
	2 8.2
	2 8.1
  run;

/* Sort the data file by the levels
   of the treatment variable  */
proc sort data=set1; by trt; run;

title 'Question 5';
/* Printing the data set to the output window */
proc print data=set1; run;

/* Assign labels to the levels of the
   treatment variable  */
 proc format; 
  value trt 1='treatment 1'
            2='treatment 2';
run;


/* ODS: Output Delivery System"*/
ods rtf  file="cwrite.rtf"; 

  /*  Use the MULTTEST procedure to perform a 
      permutation test using 10000 new random
      assignments of subjects to the two treatment 
      groups  */
  proc multtest data=set1 permutation nsample=20 
                 seed=36607 outsamp=pmt; 
	  class trt;  
	  contrast "treatment 1 vs treatment 2" 1 -1;
	  *coefficients in the order of trt levels;
	  test mean(y);  
	  *t test on the mean ;
	  title 'randomization test';
      run; 


/* The following code computes the differences in
   treatment group means for the 10000 permutations */

   proc means data=pmt noprint; 
     by _sample_ _class_;
	 * the names of sas created variables start with _ and end with _;
	 * sort by _sample_ first and then by _class_;
	 var y;
	 output out=stats n=n mean=mean;
     run;

   data stats1; set stats; if(_class_=1); 
     n1=n; mean1=mean;
     keep _sample_ n1 mean1; run;

  data stats2; set stats; if(_class_=2); 
     n2=n; mean2=mean;
     keep _sample_ n2 mean2; run;

  data stats3; merge stats1 stats2; by _sample_; 
  	* merge two datasets side by side matched by _sample_;
     diff = (mean1-mean2);
     run;

  title "Differences in Means for the all Permutations"; 
  proc print data=stats3(obs=20);  run;

  data stats4; set stats3;
    if(abs(diff)ge 3);
	run;

  proc sort data=stats4; by diff; run;

  title "Differences as Extreme as the Observed Difference (3)";
  proc print data=stats4; 
  run;

    data stats5; set pmt; if(_class_=1); 
	y1=y;
    keep _sample_ y1 ; run;

  data stats6; set pmt; if(_class_=2); 
	y2=y;
    keep _sample_ y2 ; run;

data stats7; merge stats5 stats6; by _sample_; 
* merge two datasets side by side matched by _sample_;
run;

title "All Permutations"; 
  proc print data=stats7(obs=60);  run;


/* Use the sgplot procedure to create a histogram of 
   differences from the 10000 permuted data sets  */
 
title "Differences for 20 Random Permutations";
proc sgplot data=stats3;
  histogram diff;
  yaxis grid label="Response" labelattrs=(size=20)
               valueattrs=(size=15);
  xaxis display=(nolabel) valueattrs=(size=15);
  run;

 ods rtf close;
