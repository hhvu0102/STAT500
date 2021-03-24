
/*  This program computes a paired t test for the
    rhesus monkey experiment considered in class */

/*  First enter the data and compute the differences */

data set1;
  input patient y1 y2;
  d = y2-y1;
  label  y1 = Hours of sleep under placenbo
         y2 = Hours of sleep under drug
          d = difference (y2-y1);
cards;
1 1.3 0.6
2 1.1 1.1
3 6.2 2.5
4 3.6 2.8
5 4.9 2.9
6 1.4 3.0
7 6.6 3.2
8 4.5 4.7
9 4.3 5.5
10 6.1 6.2
run;



/* Print the data file */

proc print data=set1;
run;


/* Compute correlation between hours of sleep under 2 treatments*/

proc corr data=set1;
  var y1 y2;
  run;

/* Make a scatterplot of y1 against y2 */

 
title h=2 "Hours of sleep under placebo and drug";
proc sgplot data=set1;
  scatter x=y2 y=y1 / markerattrs=(size=12 symbol=CircleFilled color=black);
  yaxis label="Drug" values=(0 to 8 by 2) 
           labelattrs=(size=20) valueattrs=(size=15);
  xaxis label="Placenbo" values=(0 to 8 by 2)
           labelattrs=(size=20) valueattrs=(size=15);
  run;


/* Compute the t test and summary statistics for differences */

proc univariate data=set1 normal ;
  cdfplot / normal;
  qqplot / normal;
  var d;
  run;

proc power;
  onesamplemeans    /* one sample */
    power=0.95       /* specify power */
    stddev=1.789        /* specify sigma */
    mean=0.75          /* specify mean under Ha */
    ntotal=.;       /* and solve for # obs */
run;
