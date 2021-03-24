/* Read in the data set from a .csv file*/
  data set1; 
  	input trt time;
	datalines;
	1 9
	1 12
	1 14
	1 17
	2 18
	2 21
	2 23
	2 26
  run;

/* Sort the data file by the levels
   of the treatment variable  */
proc sort data=set1; by trt; run;

/* Printing the data set to the output window */
proc print data=set1; run;

/* Assign labels to the levels of the
   treatment variable  */
 proc format; 
  value trt 1='control'
            2='drug';
run;

/* Construct high-quality box plots.  The format statement
   assigns labels to the levels of the treatment 
   variable used to label the plot.   */

proc sgplot data=set1;
/* hbox/vbox for BOX plots, 
category = var  A box plot is created for each
value of the category variable */
  	hbox time / category=trt nofill;
  	format trt trt.;
	title 'Box plot of Running time for each trt';
/* Specifies a label and font size for the axis */
   	xaxis label="Running time"  valueattrs=(size=15) 
                    labelattrs=(size=20);
   	yaxis label="Treatment" valueattrs=(size=15) 
                     labelattrs=(size=20);
  run;

proc boxplot data=set1;
	plot time*trt;
  	format trt trt.;
	title 'Box plot of Running time for each trt';
run;

proc ttest data=set1;
	class trt;
	var time;
	title 't test';
run;

/* ODS: Output Delivery System"*/
ods rtf  file="cwrite.rtf"; 

  /*  Use the MULTTEST procedure to perform a 
      permutation test using 10000 new random
      assignments of subjects to the two treatment 
      groups  */
  proc multtest data=set1 permutation nsample=70 
                 seed=36607 outsamp=pmt; 
	  class trt;  
	  contrast "control vs drug" 1 -1;
	  *coefficients in the order of trt levels;
	  test mean(time);  
	  *t test on the mean ;
	  title 'randomization test';
      run; 


/*  The outsamp=pmt command in the previous procedure
    creates an output file that contains the data for
    all 10000 random permutations.  The following prints
    the first 50 lines of that file.  Do not try to 
    print the entire file since it contains 470000 lines 
    and it will be too large for your output window */ 

   title 'First 50 lines of the permutations file';
   proc print data=pmt(obs=50); 
   run;

/* The following code computes the differences in
   treatment group means for the 10000 permutations */

   proc means data=pmt noprint; 
     by _sample_ _class_;
	 * the names of sas created variables start with _ and end with _;
	 * sort by _sample_ first and then by _class_;
	 var time;
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

  title "Differences in Means for the First 20 Permutations "; 
  proc print data=stats3(obs=20);  run;

  data stats4; set stats3;
    if(abs(diff)ge 9);
	run;

  proc sort data=stats4; by diff; run;

  title "Differences as Extreme as the Observed Difference (9)";
  proc print data=stats4; 
  run;


/* Use the sgplot procedure to create a histogram of 
   differences from the 10000 permuted data sets  */
 
title "Differences for 70 Random Permutations";
proc sgplot data=stats3;
  histogram diff;
  yaxis grid label="Percent" labelattrs=(size=20)
               valueattrs=(size=15);
  xaxis display=(nolabel) valueattrs=(size=15);
  run;

 ods rtf close;
