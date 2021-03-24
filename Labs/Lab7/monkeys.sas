
/*  This program computes a paired t test for the
    rhesus monkey experiment considered in class */

/*  First enter the data and compute the differences */

data set1;
  input monkey y1 y2;
  d = y1-y2;
  label  y1 = CP level for severed nerves
         y2 = CP level for intact nerves
          d = difference (y1-y2);
cards;
 1 11.5 16.3
 2  3.6  4.8
 3 12.5 10.9
 4  6.3 14.2
 5 15.2 16.3
 6  8.1  9.9
 7 16.6 29.2
 8 13.2 22.4
run;

ods rtf  file="monkeys.rtf"; 
  ods graphics on;

/* Print the data file */

proc print data=set1;
run;


/* Compute correlation between CP levels 
   for severed and intact nerves */

proc corr data=set1;
  var y1 y2;
  run;

/* Make a scatterplot of y1 against y2 */

 
title h=2 "CP Levels for Severed and Intact Nerves";
proc sgplot data=set1;
  scatter x=y2 y=y1 / markerattrs=(size=12 symbol=CircleFilled color=black);
  yaxis label="Severed Nerves" values=(0 to 20 by 5) 
           labelattrs=(size=20) valueattrs=(size=15);
  xaxis label="Intact Nerves" values=(0 to 30 by 5)
           labelattrs=(size=20) valueattrs=(size=15);
  run;


/* Compute the t test and summary statistics for differences */

proc univariate data=set1 normal ;
  cdfplot / normal;
  qqplot / normal;
  var d;
  run;

ods graphics off;  
   ods rtf close;
