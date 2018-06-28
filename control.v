`include "params.v" 
 
/*-----------------------------------*/ 
// Module	: CONTROL   
// File		: control.v  
// Description	: Description of Control Unit in Viterbi Decoder  
// Simulator	: Modelsim 4.6 / Windows 98  
// Synthesizer	: - 
// Author	: M Zalfany U (zalfany@opencores.org)  
/*-----------------------------------*/ 
// Revision Number 	: 1  
// Date of Change 	: 10th Jan 2000  
// Modifier 		: Zalfany  
// Description 		: Initial Design  
/*-----------------------------------*/ 
 
module CONTROL (Reset, CLOCK, Clock1, Clock2, ACSPage, ACSSegment, Active,  
		CompareStart, Hold, Init, TB_EN); 
 
 
input Reset, CLOCK, Active; 
 
output [`WD_FSM-1:0] ACSSegment; 
output [`WD_DEPTH-1:0] ACSPage; 
output Clock1, Clock2; 
output Hold, Init, CompareStart; 
output TB_EN; 
 
reg [`WD_FSM-1:0] ACSSegment; 
reg [`WD_DEPTH-1:0] ACSPage; 
 
reg Init,Hold; 
 
wire EVENT_1,EVENT_0; 
 
reg TB_EN; 
 
reg CompareStart; 
reg [3:0] CompareCount; 
 
reg count,Clock1, Clock2; 
 
// Clock1 and Clock2  
   always @(posedge CLOCK or negedge Reset)  
      if (~Reset) count <= 0; else count <= ~count; 
    
   always @(posedge CLOCK or negedge Reset)  
   begin  
      if (~Reset)  
        begin 
           Clock1 <= 0;  
           Clock2 <= 0; 
        end 
      else 
        begin 
          if (count) Clock1 <=~Clock1; 
          if (~count) Clock2 <= ~Clock2; 
        end 
   end 
// --- 
    
   assign EVENT_1 = (ACSSegment == 6'h3E); 
   assign EVENT_0 = (ACSSegment == 6'h3F); 
    
   always @(posedge Clock1 or negedge Reset) 
   begin 
     if (~Reset)  
        begin 
           {ACSPage,ACSSegment} <= 'hFFFFF; 
           Init <=0; 
           Hold <= 0; 
           TB_EN <= 0; 
        end      
     else if (Active)  
          begin 
             // Increase ACSSegment and Page 
             {ACSPage,ACSSegment} <= {ACSPage,ACSSegment} + 1; 
 
             // Init and Hold signal        
             if (EVENT_1) begin Init <= 0; Hold <= 1; end  
              else if (EVENT_0) begin Init <= 1; Hold <= 0; end  
                    else begin {Init,Hold} <= 0; end 
 
             // enable TB after 63 sets of survivor created 
             if ((ACSSegment == 'h3F) && (ACSPage == 'h3E)) TB_EN <= 1; 
        end 
   end 
 
// For the first K-1, no COMPARISON made. Survivor is coming from '0' branch. 
   always @(posedge Clock2 or negedge Reset)  
   begin  
     if (~Reset)  
          begin  
              CompareCount <= 0;  
              CompareStart <= 0; 
          end 
     else begin 
          if (~CompareStart && EVENT_1) CompareCount <= CompareCount + 1; 
          if (CompareCount == `CONSTRAINT-1 && EVENT_0) CompareStart <= 1; 
          end 
   end 
 
endmodule 