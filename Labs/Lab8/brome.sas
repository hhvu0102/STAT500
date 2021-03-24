data brome;
  infile 'brome.txt' firstobs=2;
  input freeway stream trt $ y;
run;  
proc glm;
  class freeway stream trt;
  model y = freeway stream trt;
  
  lsmeans trt / stderr ;
  
  estimate 'uncut - rest' trt -1 -1 3 -1 / divisor = 3;
  contrast 'uncut - rest' trt -1 -1 3 -1;
  
  title 'Analysis of Latin Square';
  
run;

proc glm;
  class freeway stream trt;
  model y = freeway trt;
  
  lsmeans trt/ stderr;
  
  title 'RCBD Analysis after dropping stream';
  
run;
