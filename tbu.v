`include "params.v" 
 
/*-----------------------------------*/ 
// Module	: TBU 
// File		: tbu.v  
// Description	: Description of TBU Unit in Viterbi Decoder  
// Simulator	: Modelsim 4.6 / Windows 98  
// Synthesizer	: - 
// Author	: M Zalfany U (zalfany@opencores.org)  
/*-----------------------------------*/ 
// Revision Number 	: 1  
// Date of Change 	: 10th Jan 2000  
// Modifier 		: Zalfany  
// Description 		: Initial Design  
/*-----------------------------------*/ 
 
  module TBU (Reset, Clock1, Clock2, TB_EN, Init, Hold, InitState,  
  	      DecodedData, DataTB, AddressTB); 
 
input Reset, Clock1, Clock2, Init, Hold; 
input [`WD_STATE-1:0] InitState; 
input TB_EN; 
 
input [`WD_RAM_DATA-1:0] DataTB; 
output [`WD_RAM_ADDRESS-`WD_FSM-1:0] AddressTB; 
 
output DecodedData; 
 
wire [`WD_STATE-1:0] OutStateTB; 
 
   TRACEUNIT tb (Reset, Clock1, Clock2, TB_EN, InitState, Init, Hold,  
   		 DataTB, AddressTB, OutStateTB); 
    
   assign DecodedData = OutStateTB [`WD_STATE-1]; 
 
endmodule 
 
/*-----------------------------------*/ 
  module TRACEUNIT (Reset, Clock1, Clock2, Enable, InitState, Init, Hold,  
  		    Survivor, AddressTB, OutState); 
/*-----------------------------------*/ 
 
input Reset, Clock1, Clock2, Enable; 
input [`WD_STATE-1:0] InitState; 
input Init, Hold; 
input [`WD_RAM_DATA-1:0] Survivor; 
 
output [`WD_STATE-1:0] OutState; 
 
output [`WD_RAM_ADDRESS-`WD_FSM-1:0] AddressTB; 
 
reg [`WD_STATE-1:0] CurrentState; 
reg [`WD_STATE-1:0] NextState; 
reg [`WD_STATE-1:0] OutState; 
 
//wire SurvivorBit; 
reg SurvivorBit; 
    always @(negedge Clock1 or negedge Reset) 
    begin 
       if (~Reset) begin 
          CurrentState <=0; OutState <=0; 
       end 
       else if (Enable) 
         begin  
            if (Init) CurrentState <= InitState; 
               else CurrentState <= NextState; 
           
            if (Hold) OutState <= NextState; 
         end 
    end 
 
    assign AddressTB = CurrentState [`WD_STATE-1:`WD_STATE-5]; 
 
    always @(negedge Clock2 or negedge Reset) 
    begin 
      if (~Reset) NextState <= 0; 
       else  
         if (Enable) NextState <= {CurrentState [`WD_STATE-2:0],SurvivorBit}; 
    end 
     
//    assign SurvivorBit =  
//          (Clock1 && Clock2 && ~Init) ? Survivor[CurrentState[2:0]]:'bz; 
always @(CurrentState or Clock1 or Clock2 or Init or Survivor)     
	begin  
	case(CurrentState[2:0]) 
	    3'b000: SurvivorBit <= (Clock1 && Clock2 && ~Init) ? Survivor[0]:'bz; 
		    
	    3'b001: SurvivorBit <= (Clock1 && Clock2 && ~Init) ? Survivor[1]:'bz; 
 
	    3'b010: SurvivorBit <= (Clock1 && Clock2 && ~Init) ? Survivor[2]:'bz; 
 
	    3'b011: SurvivorBit <= (Clock1 && Clock2 && ~Init) ? Survivor[3]:'bz; 
 
	    3'b100: SurvivorBit <= (Clock1 && Clock2 && ~Init) ? Survivor[4]:'bz; 
		    
	    3'b101: SurvivorBit <= (Clock1 && Clock2 && ~Init) ? Survivor[5]:'bz; 
 
	    3'b110: SurvivorBit <= (Clock1 && Clock2 && ~Init) ? Survivor[6]:'bz; 
 
	    3'b111: SurvivorBit <= (Clock1 && Clock2 && ~Init) ? Survivor[7]:'bz; 
 
 
    endcase	 
end 
    endmodule 
