// Guitar Hero-style game player (for filtered video)

(* always_ready *)
interface FretFiltered;
	(* enable = "vsync" *)
	method Action vsync();
	(* enable = "hsync" *)
	method Action hsync();
	(* enable = "vde" *)
	method Action vde();
	
	(* always_enabled *)
	method Action pixel(Bool in);
	(* always_enabled *)
	method Action xPos(UInt#(11) in);
	(* always_enabled *)
	method Action yPos(UInt#(10) in);
	
	method Bool press();
endinterface


(* synthesize *)
module mkFretFiltered (FretFiltered);
	
	Reg#(Bool) fretValue1  <- mkReg(False);
	Reg#(Bool) fretValue2  <- mkReg(False);
	Reg#(Bool) fretValue3  <- mkReg(False);
	Reg#(Bool) fretPressed <- mkReg(False);
	
	Wire#(Bool) pixelValue <- mkWire;
	
	PulseWire hsync_pulse <- mkPulseWire();
	PulseWire vsync_pulse <- mkPulseWire();
	PulseWire vde_pulse   <- mkPulseWire();
	
	Reg#(UInt#(11)) x <- mkReg(0);
	Reg#(UInt#(10)) y <- mkReg(0);
	
	Wire#(UInt#(11)) xPosition <- mkWire;
	Wire#(UInt#(10)) yPosition <- mkWire;


	// New frame on each VSync pulse
	rule new_frame(vsync_pulse);
		x <= 0;
		y <= 0;
		
		// Update fret value (needs at least two in agreement)
		fretPressed <= False;
	endrule
	
	// New line on each HSync pulse
	rule new_line(hsync_pulse && !vsync_pulse && x != 0);
		y <= y + 1;
		x <= 0;
	endrule
	
	// New pixel each clock when VDE is high
	rule new_pixel(vde_pulse && !hsync_pulse && !vsync_pulse);
		x <= x + 1;
	endrule
	
	
	// Received VSync pulse
	method Action vsync();
		vsync_pulse.send();
	endmethod
	
	// Received HSync pulse
	method Action hsync();
		hsync_pulse.send();
	endmethod
	
	// Video Data Enable signal
	method Action vde();
		vde_pulse.send();
	endmethod
	
	
	// Get RGB pixel values
	method Action pixel(Bool in);
		pixelValue <= in;
	endmethod
	
	// Get X position
	method Action xPos(UInt#(11) in);
		xPosition <= in;
	endmethod
	
	// Get Y position
	method Action yPos(UInt#(10) in);
		yPosition <= in;
	endmethod
	
	
	// Output fret pressed value
	method Bool press();
		return fretPressed;
	endmethod

endmodule
