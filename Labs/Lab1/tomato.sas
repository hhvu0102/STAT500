* the DATA step: convert your data into a form that’s usable by SAS;
data tomato;
	* infile 'tomato.txt' firstobs = 2;
	* on a pc: use the full path;
	infile '\\tsclient\D\Coursework\Stat 500 Fall 2020\Labs\Lab1\tomato.txt';
 	* the input line lists the variables to be read from one line of your data;
 	* tell SAS that trt is a character varialbe by putting $ after the vatiable name on the input line;
	input group $ yield;
run;

* PROC steps ask SAS to run a particular analysis;
* For example, proc ttest runs t-test for two sample comparison;
proc ttest;
	class group; /* specify the class variables */
	var yield;
	title 't-test of tomato yield';
run;

proc sort;
	by group;  /* sort the data by group before doing the boxplot */
proc boxplot;
	plot yield*group;
	title 'Boxplots for each group';
run;
