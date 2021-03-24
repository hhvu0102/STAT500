/* Read in the data set from a .txt file*/
  data set1;
  	infile '\\tsclient\D\Coursework\Stat 500 Fall 2020\Homework7\millet.txt' dlm=' ' firstobs=2; 
  	input row col spacing yield;
  run;

  proc sort data=set1; by trt;  run;


  title 'Latin Square Design';

proc glm;
  class row col spacing;
  model yield = row col spacing;
  
  *lsmeans trt / stderr ; *Produces the standard error;
  lsmeans spacing / adjust=tukey; *Requests a multiple comparison adjustment;

  *estimate 'uncut - rest' trt -1 -1 3 -1 / divisor = 3;
  *contrast 'uncut - rest' trt -1 -1 3 -1;
  
run;

proc glm;
  class row col spacing;
  model yield = col spacing;
  
  lsmeans spacing / stderr;
  
  title 'RCBD Analysis after dropping row';
  
run;

proc glm;
  class row col spacing;
  model yield = row spacing;
  
  lsmeans spacing / stderr;
  
  title 'RCBD Analysis after dropping col';
  
run;
