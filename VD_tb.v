`define D_PER 	 
 
/************************************************************************************/ 
`define HALF 100
`define FULL 200
`define WD_CODE 2
`define DPERIOD (`FULL*128) 
 
module VD_tb(); 
 
 
   reg CLOCK; 
   initial CLOCK = 0; 
   always #(`HALF/2) CLOCK = ~CLOCK; 
    
   reg Reset; 
   reg DRESET; 
 
   initial  
	begin	   //$dumpfile("log.vcd");$dumpvars(1,VD);$dumpon; #10000000 $finish; 
   	end 
   initial begin  
      DRESET = 1;  
      Reset = 1;  
      #200 Reset = 0;DRESET=0; 
      #300 Reset = 1;  
      DRESET = 1;  
   end 
 
   reg X; 
   wire [`WD_CODE-1:0] Code; 
   initial X = 0; 
   initial begin 
      #475 X = 1; 
      #`DPERIOD X = 1; 
      #`DPERIOD X = 1; 
      #`DPERIOD X = 1; 
      #`DPERIOD X = 1; 
      #`DPERIOD X = 0; 
      #`DPERIOD X = 0; 
      #`DPERIOD X = 0; 
      #`DPERIOD X = 1; 
      #`DPERIOD X = 0; 
      #`DPERIOD X = 1; 
      #`DPERIOD X = 0; 
      #`DPERIOD X = 1; 
      #`DPERIOD X = 1; 
      #`DPERIOD X = 0; 
 
 
      #`DPERIOD X = 0; 
      #`DPERIOD X = 0; 
      #`DPERIOD X = 1; 
      #`DPERIOD X = 1; 
      #`DPERIOD X = 1; 
       
      #`DPERIOD X = 0; 
      #`DPERIOD X = 1; 
      #`DPERIOD X = 0; 
      #`DPERIOD X = 1; 
      #`DPERIOD X = 0; 
       
      #`DPERIOD X = 0; 
      #`DPERIOD X = 0; 
      #`DPERIOD X = 1; 
      #`DPERIOD X = 0; 
      #`DPERIOD X = 0;  
       
      #`DPERIOD X = 0; 
      #`DPERIOD X = 1; 
      #`DPERIOD X = 1; 
      #`DPERIOD X = 1; 
      #`DPERIOD X = 1; 
       
      #`DPERIOD X = 1; 
      #`DPERIOD X = 0; 
      #`DPERIOD X = 1; 
      #`DPERIOD X = 1; 
      #`DPERIOD X = 0; 
       
      #`DPERIOD X = 0; 
      #`DPERIOD X = 0; 
      #`DPERIOD X = 1; 
      #`DPERIOD X = 0;  
      #`DPERIOD X = 0; 
       
      #`DPERIOD X = 0; 
      #`DPERIOD X = 1; 
      #`DPERIOD X = 0; 
      #`DPERIOD X = 0;  
      #`DPERIOD X = 0; 
       
      #`DPERIOD X = 1; 
      #`DPERIOD X = 1; 
      #`DPERIOD X = 0; 
      #`DPERIOD X = 1; 
      #`DPERIOD X = 1; 
       
      #`DPERIOD X = 0; 
      #`DPERIOD X = 0; 
      #`DPERIOD X = 1; 
      #`DPERIOD X = 1; 
      #`DPERIOD X = 1; 
       
      #`DPERIOD X = 0; 
      #`DPERIOD X = 1; 
      #`DPERIOD X = 0; 
 
    end 
 
   reg D_CLOCK; 
   initial D_CLOCK = 0;  
       
   always #(`DPERIOD/2) D_CLOCK <= ~D_CLOCK;  
     
    reg Active; 
   always @(Code or Reset) 				//  
     if (~Reset) Active <= 0; 				// a simple data input synchronizer 
     else if (Code!=0) Active <= 1;			// Active should come from synch module in 'real' application. 
 
   wire DecodeOut;
   
 top_VD inst (X, D_CLOCK, DRESET, Reset, CLOCK, Active, DecodeOut, Code);     
 
 
endmodule 