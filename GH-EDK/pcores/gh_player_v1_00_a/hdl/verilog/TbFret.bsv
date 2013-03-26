import Fret::*;

(* synthesize *)
module mkTbFret();
	Fret fret <- mkFret(8, 5, 'h808080, 'h808080 );
	Reg#(Bit#(16)) state <- mkReg(0);
	Reg#(Bit#(1)) state2 <- mkReg(0);
	Reg#(Bit#(16)) x <- mkReg(0);
	Reg#(Bit#(16)) y <- mkReg(0);
	
	rule init(state == 0);
		fret.rgb('h808080);
	endrule
	
	rule vsync(state < 3 && y == 9);
		fret.vsync();
		fret.hsync();
		fret.pclk();
		//fret.rgb('h818181);
		y <= 0;
		x <= 0;
		
		state <= state + 1;
	endrule
	
	rule hsync(state < 3 && x == 16 && y < 9);
		fret.hsync();
		fret.pclk();
		//fret.rgb('h818181);
		x <= 0;
		y <= y + 1;
	endrule
	
	rule pclk(state < 3 && x < 16 && y < 9);
		if (state2 == 1) begin
			fret.pclk();
			x <= x + 1;
			$display("%d, %d - %d", x, y, fret.press());
			state2 <= 0;
		end else begin
			state2 <= 1;
		end
		
		//fret.rgb('h818181);
		
	endrule
	
	rule fin(state == 3);
		$finish(0);
	endrule
	

endmodule
