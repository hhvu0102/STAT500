/*  Effects of different hypersentive treatments. */

data systolich;
infile '\\tsclient\D\Coursework\Stat 500 Fall 2020\Homework2\systolich.txt' dlm=' ' firstobs=1;
input patient trt y;
run;

/* Run t-test for the difference in mean blood pressure levels for the drugs. 
   Obtain plots for diagnostics.*/

title1 'T-test for Difference in Blood Pressure Levels';
proc ttest data=systolich plots(unpack shownull) = all; 
  * Unpack all of the plots;
  * You can delete the plots(unpack shownull) = all from the above command 
  * and get less plots in the output. Try it!
  * The SHOWNULL option displays a vertical reference line at the null hypothesis value
  * on the plot of mean difference (zero default);
  class trt;
  var y;
run;
