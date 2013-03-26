import Whammy::*;

(* synthesize *)
module mkTbWhammy();
	Whammy whammy <- mkWhammy();
	Reg#(Bit#(16)) state <- mkReg(0);
	
	rule init(state == 0);
		whammy.move(True);
		state <= 1;
	endrule
	
	rule clock(state > 0 && state < 65000);
		$display(whammy.out());
		state <= state + 1;
	endrule
	
	rule fin(state == 65000);
		$finish(0);
	endrule
	
endmodule
