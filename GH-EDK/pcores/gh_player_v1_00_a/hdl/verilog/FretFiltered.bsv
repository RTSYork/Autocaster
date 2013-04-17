// Guitar Hero-style game player (for filtered video)

import Vector :: * ;

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
	
	Vector#(14, Reg#(Bool)) fretValues <- replicateM(mkReg(False));
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
		
		// Update fret value (true if any of the detector pixels see a fret)
		fretPressed <= (fretValues[ 0] ||
		                fretValues[ 1] ||
		                fretValues[ 2] ||
		                fretValues[ 3] ||
		                fretValues[ 4] ||
		                fretValues[ 5] ||
		                fretValues[ 6] ||
		                fretValues[ 7] ||
		                fretValues[ 8] ||
		                fretValues[ 9] ||
		                fretValues[10] ||
		                fretValues[11] ||
		                fretValues[12] ||
		                fretValues[13]);
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
	
	
	// Triggers for a note
	rule start_pixel0(x == xPosition && y == yPosition+0 && !vsync_pulse);
		fretValues[0] <= pixelValue;
	endrule
	
	rule start_pixel1(x == xPosition && y == yPosition+1 && !vsync_pulse);
		fretValues[1] <= pixelValue;
	endrule
	
	rule start_pixel2(x == xPosition && y == yPosition+2 && !vsync_pulse);
		fretValues[2] <= pixelValue;
	endrule
	
	rule start_pixel3(x == xPosition && y == yPosition+3 && !vsync_pulse);
		fretValues[3] <= pixelValue;
	endrule
	
	rule start_pixel4(x == xPosition && y == yPosition+4 && !vsync_pulse);
		fretValues[4] <= pixelValue;
	endrule
	
	rule start_pixel5(x == xPosition && y == yPosition+5 && !vsync_pulse);
		fretValues[5] <= pixelValue;
	endrule
	
	rule start_pixel6(x == xPosition && y == yPosition+6 && !vsync_pulse);
		fretValues[6] <= pixelValue;
	endrule
	
	rule start_pixel7(x == xPosition && y == yPosition+7 && !vsync_pulse);
		fretValues[7] <= pixelValue;
	endrule
	
	rule start_pixel8(x == xPosition && y == yPosition+8 && !vsync_pulse);
		fretValues[8] <= pixelValue;
	endrule
	
	rule start_pixel9(x == xPosition && y == yPosition+9 && !vsync_pulse);
		fretValues[9] <= pixelValue;
	endrule
	
	rule start_pixel10(x == xPosition && y == yPosition+10 && !vsync_pulse);
		fretValues[10] <= pixelValue;
	endrule
	
	rule start_pixel11(x == xPosition && y == yPosition+11 && !vsync_pulse);
		fretValues[11] <= pixelValue;
	endrule
	
	rule start_pixel12(x == xPosition && y == yPosition+12 && !vsync_pulse);
		fretValues[12] <= pixelValue;
	endrule
	
	rule start_pixel13(x == xPosition && y == yPosition+13 && !vsync_pulse);
		fretValues[13] <= pixelValue;
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
