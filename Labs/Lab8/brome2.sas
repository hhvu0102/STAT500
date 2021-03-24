
data brome;
  infile 'brome3.txt' firstobs=2;
  input square row col trt $ abdn;

proc print;
       
proc glm;
  class square row col trt;
  model abdn =  square row(square) col(square) trt;
  
  title 'Correct analysis of multiple separate latin squares';
  
run;
     
proc glm;
  class  row col trt;
  model abdn =  row col trt;
  
  title 'Incorrect analysis of multiple separate latin squares';
  
run;
          
