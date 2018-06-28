module top_VD (X, D_CLOCK, DRESET, Reset, CLOCK, Active, DecodeOut, Code);

input X,D_CLOCK,DRESET;
output [1:0] Code;
input Reset, CLOCK, Active;
output DecodeOut;

	reg [24:0]clkd;
	always@(posedge CLOCK)
	begin
	if(Reset==1'b0)
	clkd=25'd0;
	else
	clkd=clkd+1;
	end
	
   VITERBIDECODER vd (Reset, CLOCK, Active, Code, DecodeOut);
   //VITERBIDECODER vd (Reset, clkd[0], Active, Code, DecodeOut);
   
    reg [31:0]dclkd;
	always@(posedge D_CLOCK)
	begin
	if(DRESET==1'b0)
	dclkd=32'd0;
	else
	dclkd=dclkd+1;
	end
	
   viterbi_encode9 enc(X,Code,D_CLOCK,DRESET);
   //viterbi_encode9 enc(X,Code,dclkd[0],DRESET); 

   
endmodule
