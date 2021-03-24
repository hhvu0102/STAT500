
/*  Speed of text messages between teenagers and adults. */

data SMS;
infile '\\tsclient\D\Coursework\Stat 500 Fall 2020\Labs\Lab3\smsspeed.csv' dlm=',' firstobs=2;
input Age AgeGroup $ Own Control;
  run;


/* Run t-test for the difference in mean times for the text message on their own phone. 
   Obtain plots for diagnostics.*/

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


/* Run t-test for the difference in mean times for the text message on the control phone. 
   Obtain plots for diagnostics.*/
title1 'T-test for Difference in Mean Times - Control Phone';
proc ttest data=SMS plots(unpack shownull) = all;
  class AgeGroup;
  var Control;
run;
