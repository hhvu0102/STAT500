/* Read in the data set from a .csv file*/
  data set1;
  	infile '\\tsclient\D\Coursework\Stat 500 Fall 2020\Homework1\farming.csv' dlm=',' firstobs=2; 
  	input Field Yield Variety $;
  run;

/* Sort the data file by variety  */
proc sort data=set1; by Variety; run;

/* Printing the data set to the output window */
proc print data=set1; run;

/* Compute summary statistics for each 
   treatment group  */
proc univariate data=set1; by Variety;
  var Yield; 
  run;

proc sgplot data=set1;
/* hbox/vbox for BOX plots, 
category = Variety  A box plot is created for each
value of the Variety variable */
  	hbox Yield / category=Variety nofill;
	title 'Box plot of Yield for each Variety';
/* Specifies a label and font size for the axis */
   	xaxis label="Yield"  valueattrs=(size=15) 
                    labelattrs=(size=20);
   	yaxis label="Variety" valueattrs=(size=15) 
                     labelattrs=(size=20);
  run;

  proc multtest data=set1 permutation nsample=10000 
                 seed=36607 outsamp=pmt; 
	  class Variety;  
	  contrast "A vs B" 1 -1;
	  *coefficients in the order of variety;
	  test mean(Yield);  
	  *t test on the mean ;
	  title 'Randomization test';
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
   variety means for the 10000 permutations */

   proc means data=pmt noprint; 
     by _sample_ _class_;
	 * the names of sas created variables start with _ and end with _;
	 * sort by _sample_ first and then by _class_;
	 var Yield;
	 output out=stats n=n mean=mean;
     run;

   data stats1; set stats; if(_class_='A'); 
     n1=n; mean1=mean;
     keep _sample_ n1 mean1; run;

  data stats2; set stats; if(_class_='B'); 
     n2=n; mean2=mean;
     keep _sample_ n2 mean2; run;

  data stats3; merge stats1 stats2; by _sample_; 
  	* merge two datasets side by side matched by _sample_;
     diff = (mean1-mean2);
     run;

  title "Differences in Means for the First 20 Permutations "; 
  proc print data=stats3(obs=20);  run;

  data stats4; set stats3;
    if(abs(diff)ge 11.2222);
	run;

  proc sort data=stats4; by diff; run;

  title "Differences as Extreme as the Observed Difference (11.2222)";
  proc print data=stats4; 
  run;


/* Use the sgplot procedure to create a histogram of 
   differences from the 10000 permuted data sets  */
 
title "Differences for 10000 Random Permutations";
proc sgplot data=stats3;
  histogram diff;
  yaxis grid label="Yield" labelattrs=(size=20)
               valueattrs=(size=15);
  xaxis display=(nolabel) valueattrs=(size=15);
  run;
