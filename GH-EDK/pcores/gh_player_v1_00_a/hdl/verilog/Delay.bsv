// FIFO delay buffer for 6-bit value
// and delay value up to 31 cycles

import Vector :: * ;

(* always_ready *)
interface Delay;
	(* enable = "vsync" *)
	method Action vsync();

	(* always_enabled *)
	method Action delay(UInt#(5) in);
	
	(* always_enabled, prefix = "" *)
	method Action in(Bit#(5) frets, Bit#(1) strum);

	method Bit#(5) frets_out();
	method Bit#(1) strum_out();
endinterface


(* synthesize *)
module mkDelay (Delay);

	PulseWire vsync_pulse <- mkPulseWire();
	
	Vector#(32, Reg#(Bit#(6))) fifo <- replicateM(mkReg(0));
	
	Wire#(Bit#(6)) inputs  <- mkWire;
	Wire#(Bit#(6)) outputs <- mkDWire(0);
	
	Wire#(UInt#(5)) dly <- mkDWire(0);
	
	Reg#(UInt#(5))  count <- mkReg(0);
	Wire#(UInt#(5)) read  <- mkWire;
	Wire#(UInt#(5)) write <- mkWire;
	
	
	rule shift(vsync_pulse);
		count <= count + 6;
	endrule
	
	rule positions;
		read  <= count;
		write <= count + (6*dly);
	endrule
	
	rule update;
		fifo[write] <= inputs;
		outputs <= fifo[read];
	endrule
	
	
	// Received VSync pulse
	method Action vsync();
		vsync_pulse.send();
	endmethod
	
	
	method Action delay(UInt#(5) in);
		dly <= in;
	endmethod
	
	method Action in(Bit#(5) frets, Bit#(1) strum);
		inputs <= {frets, strum};
	endmethod
	
	
	method Bit#(5) frets_out();
		return outputs[5:1];
	endmethod
	
	method Bit#(1) strum_out();
		return outputs[0];
	endmethod

endmodule