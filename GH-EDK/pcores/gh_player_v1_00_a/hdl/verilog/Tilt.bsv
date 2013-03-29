// Pulse wave generator with ~5.9% duty cycle
// Outputs a ~0.34s pulse every ~5.37s on 100MHz clock

(* always_ready *)
interface Tilt;
	(* always_enabled *)
	method Action move(Bool enabled);

	method Bool out();
endinterface


(* synthesize *)
module mkTilt (Tilt);
	
	Reg#(Bool) moving <- mkReg(False);
	Reg#(Bool) high <- mkReg(False);
	Reg#(UInt#(29)) lowValue <- mkReg(0);
	Reg#(UInt#(25)) highValue <- mkReg(0);
	
	
	rule lowCount (moving && !high && lowValue < 'h1FFFFFFF);
		lowValue <= lowValue + 1;
	endrule
	
	rule highCount (moving && high && highValue < 'h1FFFFFF);
		highValue <= highValue + 1;
	endrule
	
	rule lowTop (moving && !high && lowValue == 'h1FFFFFFF);
		lowValue <= 0;
		high <= True;
	endrule
	
	rule highTop (moving && high && highValue == 'h1FFFFFF);
		highValue <= 0;
		high <= False;
	endrule
	
	
	method Action move(Bool enabled);
		moving <= enabled;
	endmethod
	
	method Bool out();
		return high;
	endmethod

endmodule
