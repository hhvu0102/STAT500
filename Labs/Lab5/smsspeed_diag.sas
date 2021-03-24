
/*  Speed of text messages between teenagers and adults. */

data SMS;
infile '\\tsclient\D\Coursework\Stat 500 Fall 2020\Labs\Lab5\smsspeed.csv' dlm=',' firstobs=2;
input Age AgeGroup $ Own Control;
  run;


/* Run t-test for the difference in mean times for the text message on their own phone.
  Obtain folded-F test results, normal probability plots for diagnostics.
  Obtain Welch test (Satterthwaite) */
* ods pdf  file="diagnotisticsExample.pdf"; 
title1 'T-test for Difference in Mean Times - Own Phone';
proc ttest data=SMS plots(unpack shownull) = all; 
  * Unpack all of the plots;
  * You can delete the plots(unpack shownull) = all from the above command 
  * and get less plots in the output. Try it!
  * The SHOWNULL option displays a vertical reference line at the null hypothesis value
  * on the plot of mean difference (zero default);
  class AgeGroup;
  var Own;
run;

/* test for normality by treatment group*/
proc sort data=SMS;
	by AgeGroup;
run;
title 'Tests for Normality using UNIVARIATE';
proc univariate data=SMS normal;
  by AgeGroup;
  var Own;
  run;

/* Use the GLM procedure to perform the Brown-Forsythe
   test for homogeneous variances */
title 'GLM results for Difference in Mean Times - Own Phone';
	 proc glm data=SMS alpha=.05 ;
       class AgeGroup; 
	  model Own= AgeGroup ;
	  means AgeGroup / hovtest=bf;
      output out=resid residual=r;
  run;
  title 'Tests for Normality using pooled residuals';
proc univariate data=resid normal;
  var r;
  run;
* ods pdf close;
