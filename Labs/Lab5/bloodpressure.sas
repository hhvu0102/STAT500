/*  Descriptive analysis and model-based inference for blood pressure experimental data.*/
/*  Enter the data set */

data set1;
  input subject systolic trt $;
  datalines;
    1 143 Low
	2 136 Low
	3 126 Low
	4 165 Low
	5 145 Low
	6 135 Low
	7 143 Low
	8 157 Low
	9 132 Low
	10 149 Low
	11 161 High
	12 161 High
	13 179 High
	14 176 High
	15 162 High
	16 155 High
	17 172 High
	18 156 High
	19 146 High
	20 162 High
  run;
title1 'T-test for Difference in Blood Presssure';
proc ttest data=set1 plots(unpack shownull) = all; 
  * Unpack all of the plots;
  * You can delete the plots(unpack shownull) = all from the above command 
  * and get less plots in the output. Try it!
  * The SHOWNULL option displays a vertical reference line at the null hypothesis value
  * on the plot of mean difference (zero default);
  class trt;
  var systolic;
run;
  proc npar1way wilcoxon correct=yes data=set1;
      class trt;
      var systolic;
      exact wilcoxon;
   run;

