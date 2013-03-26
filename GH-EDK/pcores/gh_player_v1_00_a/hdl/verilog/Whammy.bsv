// Counts from 0 to 2^24 and back repeatedly
// Outputs most significant 8 bits of counter
// Takes ~0.34s for complete cycle on 100MHz clock

(* always_ready *)
interface Whammy;
	(* always_enabled *)
	method Action move(Bool enabled);

	method Bit#(8) out();
endinterface


(* synthesize *)
module mkWhammy (Whammy);
	
	Reg#(Bool) moving <- mkReg(False);
	Reg#(Bool) down <- mkReg(False);
	Reg#(UInt#(24)) value <- mkReg(0);
	
	
	rule top (value == 'hFFFFFF);
		down <= True;
		value <= value - 1;
	endrule
	
	rule bottom (value == 0);
		down <= False;
		value <= value + 1;
	endrule
	
	rule count(value > 0 && value < 'hFFFFFF && moving);
		if (down)
			value <= value - 1;
		else
			value <= value + 1;
	endrule
	
	
	method Action move(Bool enabled);
		moving <= enabled;
	endmethod
	
	method Bit#(8) out();
		return pack(value)[23:16];
	endmethod

endmodule
