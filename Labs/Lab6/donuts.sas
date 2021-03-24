
/* This code is posted as donuts.sas */

/*  Input the data for the doughnut experiment on pages 218-219
    in Snedecor and Cochran.  The outcome for each
    each batch of donuts is on a separate line.   */

data donut;
	input oil y;
	label y = (oil absorbed -150) grams;
	datalines;
	1 14
	1 22
	1 18
	1 27
	1 6
	1 45
	2 28
	2 41
	2 47
	2 32
	2 35
	2 27
	3 25
	3 43
	3 28
	3 21
	3 13
	3 26
	4 5
	4 16
	4 -1
	4 14
	4 20
	4 18
run;


proc print data=donut;
  title " ";  run;

/* Make dot plot of the responses */

ods rtf  file="donuts.rtf";

title "Donut Oil Absorption";
proc sgplot data=donut;
  scatter x=oil y=y / markerattrs=(size=15 symbol=diamond color=black);
  yaxis label="Oil Absorbed - 150 grams" values=(-5 to 50 by 5)
           labelattrs=(size=15) valueattrs=(size=15);
  xaxis label="Type of Oil"  labelattrs=(size=20)
               values=(1 to 4 by 1)  valueattrs=(size=15)
               offsetmin=0.10 offsetmax=0.10;
run;


/*  Run the MEANS procedure in SAS to compute sample
    means and variances for each type  */

proc sort data=donut; by oil;

proc means data=donut n mean std var stderr min max;
  by oil;
  var y;
run;


/*  Run the GLM procedure in SAS to compute the ANOVA table
     compute overall ANOVA table and nothing more */
proc glm data=donut;
  class oil;
  model y = oil;
run;

ods rtf close;

