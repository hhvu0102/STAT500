/* Read in the data set from a .txt file*/
  data set1;
  	infile '\\tsclient\D\Coursework\Stat 500 Fall 2020\Homework7\knee.txt' dlm=' ' firstobs=1; 
  	input patient trt $ y;
  run;

proc sort data=set1; by trt;  run;

proc means data=set1; by trt; var y; run;

proc glm data=set1;
  class patient trt;
  model y = patient trt;

  lsmeans trt / adjust=tukey; * Requests a multiple comparison adjustment;

  estimate 'N-(B+S)/2' trt -0.5 1 -0.5; *Order of trt: B N S;
  estimate 'B-S' trt 1 0 -1;

  output out=set2 r=residual p=yhat;
run;
quit;


proc univariate data=set2 normal;
  var residual;
  qqplot / normal;
  run;

  /* Plot residuals verses estimated mean */

proc sgplot data=set2;
  scatter x=yhat y=residual /   
     markerattrs=(size=12 symbol=CircleFilled color=black);
  yaxis label="Residuals" 
           labelattrs=(size=20) valueattrs=(size=15);
  xaxis label="Estimated means" 
           labelattrs=(size=20) valueattrs=(size=15);
  run;
/* dm 'odsresults; clear';
