/*  Descriptive Analysis of creative writing data */
/*  Enter the data set */

data set1;
  input subject trt y;
  datalines;
    1 1 12.0
    2 1 12.0
    3 1 12.9
    4 1 13.6
    5 1 16.6
    6 1 17.2
    7 1 17.5
    8 1 18.2
    9 1 19.1
   10 1 19.3
   11 1 19.8
   12 1 20.3
   13 1 20.5
   14 1 20.6
   15 1 21.3
   16 1 21.6
   17 1 22.1
   18 1 22.3
   19 1 22.6
   20 1 23.1
   21 1 24.0
   22 1 24.3
   23 1 26.7
   24 1 29.7
   25 2  5.0
   26 2  5.4
   27 2  6.1
   28 2 10.9
   29 2 11.8
   30 2 12.0
   31 2 12.3
   32 2 14.8
   33 2 15.0
   34 2 16.8
   35 2 17.2
   36 2 17.2
   37 2 17.4
   38 2 17.5
   39 2 18.5
   40 2 18.7
   41 2 18.7
   42 2 19.2
   43 2 19.5
   44 2 20.7
   45 2 21.2
   46 2 22.1
   47 2 24.0
  run;

/* Or, you may enter the data using the following commands:

  data set1;
  infile 'cwrite.csv' dlm=',' firstobs=2; 
  input subject trt y;
  run;
*/

/* Assign labels to the levels of the
   treatment variable  */
 
proc format; 
  value trt 1='intrinsic'
            2='extrinsic';


/* Sort the data file by the levels
   of the treatment variable  */

proc sort data=set1; by trt; run;

ods rtf file="cwrite.rtf";

proc print data=set1; run;


/* Compute summary statistics for each 
   treatment group  */

proc univariate data=set1; by trt;
  var y; 
  run;


/* Construct box plots.  The format statement
   assigns labels to the levels of the treatment 
   variable used to label the plot.   */

proc sgplot data=set1;
  hbox y / category=trt datalabel=subject nofill;
  format trt trt.;
   xaxis label="Creativity Evaluation"  valueattrs=(size=15) 
                    labelattrs=(size=20);
   yaxis label="Treatment" valueattrs=(size=15) 
                     labelattrs=(size=20);
  run;

   ods rtf close;
