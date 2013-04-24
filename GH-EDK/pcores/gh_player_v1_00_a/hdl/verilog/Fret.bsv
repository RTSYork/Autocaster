// Guitar Hero-style game player

import Vector :: * ;

(* always_ready *)
interface Fret;
	(* enable = "vsync" *)
	method Action vsync();
	(* enable = "hsync" *)
	method Action hsync();
	(* enable = "vde" *)
	method Action vde();
	
	(* always_enabled *)
	method Action rgb(Bit#(24) pixel);
	(* always_enabled *)
	method Action xPos(UInt#(11) val);
	(* always_enabled *)
	method Action yPos(UInt#(10) val);
	(* always_enabled *)
	method Action trigUp(Bit#(24) val);
	(* always_enabled *)
	method Action trigDown(Bit#(24) val);
	
	method Bool press();
endinterface


(* synthesize *)
module mkFret #(parameter UInt#(2) lOffset,
                parameter UInt#(2) rOffset) (Fret);
	
	Vector#(7, Reg#(Bool)) fretValues <- replicateM(mkReg(False));
	Reg#(Bool) fretPressed <- mkReg(False);
	Reg#(Bool) fretPressedDly <- mkReg(False);
	
	Wire#(UInt#(8)) red   <- mkWire;
	Wire#(UInt#(8)) green <- mkWire;
	Wire#(UInt#(8)) blue  <- mkWire;
	
	PulseWire hsync_pulse <- mkPulseWire();
	PulseWire vsync_pulse <- mkPulseWire();
	PulseWire vde_pulse <- mkPulseWire();
	
	Reg#(UInt#(11)) x <- mkReg(0);
	Reg#(UInt#(10)) y <- mkReg(0);
	
	Wire#(UInt#(8)) trigUpR   <- mkWire;
	Wire#(UInt#(8)) trigUpG   <- mkWire;
	Wire#(UInt#(8)) trigUpB   <- mkWire;
	Wire#(UInt#(8)) trigDownR <- mkWire;
	Wire#(UInt#(8)) trigDownG <- mkWire;
	Wire#(UInt#(8)) trigDownB <- mkWire;
	
	Wire#(UInt#(11)) xPos1 <- mkWire;
	Wire#(UInt#(11)) xPos2 <- mkWire;
	Wire#(UInt#(11)) xPos3 <- mkWire;
	Wire#(UInt#(11)) xPos4 <- mkWire;
	Wire#(UInt#(11)) xPos5 <- mkWire;
	Wire#(UInt#(11)) xPos6 <- mkWire;
	Wire#(UInt#(11)) xPos7 <- mkWire;
	
	Wire#(UInt#(10)) yPos1 <- mkWire;
	Wire#(UInt#(10)) yPos2 <- mkWire;
	Wire#(UInt#(10)) yPos3 <- mkWire;


	// New frame on each VSync pulse
	rule new_frame(vsync_pulse);
		x <= 0;
		y <= 0;
		
		// Update fret value
		fretPressed <= (fretValues[ 0] ||
		                fretValues[ 1] ||
		                fretValues[ 2] ||
		                fretValues[ 3] ||
		                fretValues[ 4] ||
		                fretValues[ 5] ||
		                fretValues[ 6]);
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
	
	
	// Slight low-pass filter for release (1 frame)
	rule fret_on(fretPressed && !fretPressedDly);
		fretPressedDly <= True;
	endrule
	
	rule fret_off(!fretPressed && fretPressedDly && vsync_pulse);
		fretPressedDly <= False;
	endrule
	
	
	// Triggers for start of a note
	rule start_pixel1(x == xPos1 && y == yPos1 && !fretPressed && !vsync_pulse);
		fretValues[0] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule
	
	rule start_pixel2(x == xPos2 && y == yPos1 && !fretPressed && !vsync_pulse);
		fretValues[1] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule
	
	rule start_pixel3(x == xPos3 && y == yPos2 && !fretPressed && !vsync_pulse);
		fretValues[2] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule
	
	rule start_pixel4(x == xPos4 && y == yPos2 && !fretPressed && !vsync_pulse);
		fretValues[3] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule
	
	rule start_pixel5(x == xPos5 && y == yPos2 && !fretPressed && !vsync_pulse);
		fretValues[4] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule
	
	rule start_pixel6(x == xPos6 && y == yPos3 && !fretPressed && !vsync_pulse);
		fretValues[5] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule
	
	rule start_pixel7(x == xPos7 && y == yPos3 && !fretPressed && !vsync_pulse);
		fretValues[6] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule
	
	
	// Triggers for end of a note
	rule end_pixel1(x == xPos1 && y == yPos1 && fretPressed && !vsync_pulse);
		fretValues[0] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule
	
	rule end_pixel2(x == xPos2 && y == yPos1 && fretPressed && !vsync_pulse);
		fretValues[1] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule
	
	rule end_pixel3(x == xPos3 && y == yPos2 && fretPressed && !vsync_pulse);
		fretValues[2] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule
	
	rule end_pixel4(x == xPos4 && y == yPos2 && fretPressed && !vsync_pulse);
		fretValues[3] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule
	
	rule end_pixel5(x == xPos5 && y == yPos2 && fretPressed && !vsync_pulse);
		fretValues[4] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule
	
	rule end_pixel6(x == xPos6 && y == yPos3 && fretPressed && !vsync_pulse);
		fretValues[5] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule
	
	rule end_pixel7(x == xPos7 && y == yPos3 && fretPressed && !vsync_pulse);
		fretValues[6] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
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
	method Action rgb(Bit#(24) pixel);
		red   <= unpack(pixel[23:16]);
		green <= unpack(pixel[15:8]);
		blue  <= unpack(pixel[7:0]);
	endmethod
	
	// Get X position
	method Action xPos(UInt#(11) val);
		xPos1 <= val - 5;
		xPos2 <= val - 3;
		xPos3 <= val - 1;
		xPos4 <= val + 1;
		xPos5 <= val + 3;
		xPos6 <= val + 5;
		xPos7 <= val + 7;
	endmethod
	
	// Get Y position
	method Action yPos(UInt#(10) val);
		yPos1 <= val + zeroExtend(lOffset) - 1;
		yPos2 <= val;
		yPos3 <= val + zeroExtend(rOffset) - 1;
	endmethod
	
	// Get Up threshold
	method Action trigUp(Bit#(24) val);
		trigUpR <= unpack(val[23:16]);
		trigUpG <= unpack(val[15:8]);
		trigUpB <= unpack(val[7:0]);
	endmethod
	
	// Get Down threshold
	method Action trigDown(Bit#(24) val);
		trigDownR <= unpack(val[23:16]);
		trigDownG <= unpack(val[15:8]);
		trigDownB <= unpack(val[7:0]);
	endmethod
	
	
	// Output fret pressed value
	method Bool press();
		return fretPressedDly;
	endmethod

endmodule
