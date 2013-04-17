// Blurs an RGB pixel in an image up to 1280px wide
// using function {2{p[x,y], p[x-1,y], p[x-2,y], p[x, y-1]}}

import Vector :: * ;

(* always_ready *)
interface Blur;
	(* always_enabled, prefix = "" *)
	method Action filter(Bit#(1) bin_in);
	
	(* always_enabled *)
	method Bit#(8) gry_out();
	
	(* enable = "hsync" *)
	method Action hsync();
	(* enable = "vde" *)
	method Action vde();
endinterface


(* synthesize *)
module mkBlur (Blur);

	Vector#(1280, Reg#(Bit#(1))) lastRow <- replicateM(mkReg(0));
	//Reg#(Bit#(1280)) lastRow <- mkReg(0);
	Reg#(Bit#(2))    lastPxl <- mkReg(0);
	Wire#(Bit#(1))   currPxl <- mkWire;
	
	Wire#(Bit#(4)) blurred <- mkDWire(0);
	
	Reg#(UInt#(11)) x <- mkReg(0);
	
	Reg#(Bool) ready <- mkReg(False);
	
	
	PulseWire hsync_pulse <- mkPulseWire();
	PulseWire vde_pulse <- mkPulseWire();
	
	
	// Latch onto new line on first HSync pulse
	rule latch(hsync_pulse && !ready);
		ready <= True;
	endrule
	
	
	// Calculate blur
	rule blur_pixel(ready);
		blurred <= {lastRow[x], lastPxl, currPxl};
		
		lastPxl    <= {currPxl, lastPxl[1]};
		lastRow[x] <= currPxl;
	endrule
	
	
	// New line on HSync
	rule new_line(hsync_pulse && x != 0 && ready);
		x <= 0;
	endrule
	
	// New pixel each clock when VDE is high
	rule new_pixel(!hsync_pulse && ready);
		x <= x + 1;
	endrule
	
	
	// Get current pixel
	method Action filter(Bit#(1) bin_in);
		currPxl <= bin_in;
	endmethod
	
	// Ouput
	method Bit#(8) gry_out();
		return {blurred, blurred};
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
