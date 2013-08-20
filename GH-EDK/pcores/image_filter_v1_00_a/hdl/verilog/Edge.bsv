// Performs edge detection on a greyscale image
// using function (p[x,y-1] & ~p[x,y])

import Vector :: * ;

(* always_ready *)
interface Edge;
	(* always_enabled, prefix = "" *)
	method Action filter(Bit#(1) bin_in);
	
	(* always_enabled *)
	method Bit#(1) bin_out();
	
	(* enable = "hsync" *)
	method Action hsync();
	(* enable = "vde" *)
	method Action vde();
endinterface


(* synthesize *)
module mkEdge (Edge);

	//Vector#(1280, Reg#(Bit#(1))) lastRow <- replicateM(mkReg(0));
	Reg#(Bit#(640)) lastRow <- mkReg(0);
	Wire#(Bit#(1))  currPxl <- mkWire;
	
	Wire#(Bit#(1)) filtered <- mkDWire(0);
	
	Reg#(UInt#(11)) x <- mkReg(0);
	
	Reg#(Bool) ready   <- mkReg(False);
	Reg#(Bool) working <- mkReg(False);
	
	
	PulseWire hsync_pulse <- mkPulseWire();
	PulseWire vde_pulse <- mkPulseWire();
	
	
	// Latch onto new line on first HSync pulse
	rule latch(hsync_pulse && !ready);
		ready <= True;
	endrule
	
	// New line on HSync
	rule new_line(hsync_pulse && x != 0 && ready);
		x <= 0;
	endrule
	
	// New pixel each clock when VDE is high
	rule new_pixel(vde_pulse && !hsync_pulse && ready);
		x <= x + 1;
	endrule
	
	// Calculate edge filter
	rule filter_pixel(vde_pulse && ready && working);
		filtered <= lastRow[x-320] & ~currPxl;

		lastRow[x-320] <= currPxl;
	endrule

	// Bypass filter outside sub-frame
	rule no_filter(ready && !working);
		filtered <= currPxl;
	endrule


	// Set sub-frame to work on
	rule start_subframe(x == 320);
		working <= True;
	endrule

	rule stop_subframe(x == 960);
		working <= False;
	endrule
	
	
	// Get current pixel
	method Action filter(Bit#(1) bin_in);
		currPxl <= bin_in;
	endmethod
	
	// Ouput
	method Bit#(1) bin_out();
		return filtered;
	endmethod
	
	
	// Received HSync pulse
	method Action hsync();
		hsync_pulse.send();
	endmethod
	
	// Video Data Enable signal
	method Action vde();
		vde_pulse.send();
	endmethod

endmodule
