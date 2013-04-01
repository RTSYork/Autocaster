// Guitar Hero-style game player

(* always_ready *)
interface Strum;
	(* enable = "vsync" *)
	method Action vsync();
	
	(* always_enabled *)
	method Action fret(Bit#(1) g, Bit#(1) r, Bit#(1) y, Bit#(1) b, Bit#(1) o);
	(* always_enabled *)
	method Action strumTime(UInt#(4) in);
	
	method Bool strum();
endinterface


(* synthesize *)
module mkStrum (Strum);
	
	Reg#(Bit#(5)) frets <- mkReg(0);
	Reg#(Bool) fretPressed <- mkReg(False);
	
	Reg#(UInt#(4)) strumCount <- mkReg(0);
	Reg#(Bool) strumOutput <- mkReg(False);
	Wire#(UInt#(4)) strumTimeVal <- mkWire;
	
	PulseWire vsync_pulse <- mkPulseWire();


	// New frame on each VSync pulse
	rule new_frame(vsync_pulse);
		fretPressed <= !(frets == 0);
	endrule
	
	
	// Set strum on for max 'strumTimeVal' frames, 1 frame after fret pressed
	rule strum_on(vsync_pulse && fretPressed && strumCount < strumTimeVal);
		strumOutput <= True;
		strumCount <= strumCount + 1;
	endrule
	
	rule strum_off(vsync_pulse && fretPressed && strumCount == strumTimeVal);
		strumOutput <= False;
		strumCount <= (strumTimeVal + 1);
	endrule
	
	rule strum_reset(vsync_pulse && !fretPressed && strumCount != 0);
		strumOutput <= False;
		strumCount <= 0;
	endrule
	
	
	// Received VSync pulse
	method Action vsync();
		vsync_pulse.send();
	endmethod
	
	
	// Get fret values
	method Action fret(Bit#(1) g, Bit#(1) r, Bit#(1) y, Bit#(1) b, Bit#(1) o);
		frets <= {g, r, y, b, o};
	endmethod
	
	
	// Get Strum Time
	method Action strumTime(UInt#(4) in);
		strumTimeVal <= in;
	endmethod
	

	// Output strum value
	method Bool strum();
		return strumOutput;
	endmethod

endmodule
