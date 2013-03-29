// Guitar Hero-style game player

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
	(* always_enabled *)
	method Action smoothing(UInt#(4) val);
	(* always_enabled *)
	method Action strumTime(UInt#(4) val);
	
	method Bool press();
	method Bool strum();
endinterface


(* synthesize *)
module mkFret #(parameter UInt#(2) lOffset,
                parameter UInt#(2) rOffset) (Fret);
	
	
	Reg#(Bool) fretValue1 <- mkReg(False);
	Reg#(Bool) fretValue2 <- mkReg(False);
	Reg#(Bool) fretValue3 <- mkReg(False);
	Reg#(Bool) fretPressed <- mkReg(False);
	
	Reg#(Bool) fretPressedDly <- mkReg(False);
	Reg#(UInt#(4)) pressDelay <- mkReg(0);
	Reg#(UInt#(4)) smoothVal <- mkReg(0);
	
	Reg#(UInt#(4)) strumCount <- mkReg(0);
	Reg#(Bool) strumOutput <- mkReg(False);
	Reg#(UInt#(4)) strumTimeVal <- mkReg(0);
	
	Reg#(UInt#(8)) red <- mkReg(0);
	Reg#(UInt#(8)) green <- mkReg(0);
	Reg#(UInt#(8)) blue <- mkReg(0);
	
	PulseWire hsync_pulse <- mkPulseWire();
	PulseWire vsync_pulse <- mkPulseWire();
	PulseWire vde_pulse <- mkPulseWire();
	
	Reg#(UInt#(11)) x <- mkReg(0);
	Reg#(UInt#(10)) y <- mkReg(0);
	
	Reg#(UInt#(8)) trigUpR <- mkReg(0);
	Reg#(UInt#(8)) trigUpG <- mkReg(0);
	Reg#(UInt#(8)) trigUpB <- mkReg(0);
	Reg#(UInt#(8)) trigDownR <- mkReg(0);
	Reg#(UInt#(8)) trigDownG <- mkReg(0);
	Reg#(UInt#(8)) trigDownB <- mkReg(0);
	
	Reg#(UInt#(11)) xPos1 <- mkReg(0);
	Reg#(UInt#(11)) xPos2 <- mkReg(0);
	Reg#(UInt#(11)) xPos3 <- mkReg(0);
	
	Reg#(UInt#(10)) yPos1 <- mkReg(0);
	Reg#(UInt#(10)) yPos2 <- mkReg(0);
	Reg#(UInt#(10)) yPos3 <- mkReg(0);


	// New frame on each VSync pulse
	rule new_frame(vsync_pulse);
		x <= 0;
		y <= 0;
		
		// Update fret value (needs at least two in agreement)
		fretPressed <= (fretValue1 && fretValue2) ||
		               (fretValue1 && fretValue3) ||
		               (fretValue2 && fretValue3);
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
	
	
	rule fret_delay_inc(!fretPressed && fretPressedDly && pressDelay != smoothVal && vsync_pulse);
		pressDelay <= pressDelay + 1;
	endrule
	
	rule fret_delay_done(!fretPressed && fretPressedDly && pressDelay == smoothVal && vsync_pulse);
		fretPressedDly <= False;
		pressDelay <= 0;
	endrule
	
	rule fret_on(fretPressed);
		fretPressedDly <= True;
	endrule
	
	
	// Set strum on for max 3 frames, 1 frame after fret pressed
	rule strum_on(vsync_pulse && fretPressedDly && strumCount < strumTimeVal);
		strumOutput <= True;
		strumCount <= strumCount + 1;
	endrule
	
	rule strum_off(vsync_pulse && fretPressedDly && strumCount == strumTimeVal);
		strumOutput <= False;
		strumCount <= (strumTimeVal + 1);
	endrule
	
	rule strum_reset(vsync_pulse && !fretPressedDly && strumCount != 0);
		strumOutput <= False;
		strumCount <= 0;
	endrule
	
	
	// Triggers for start of a note
	rule start_pixel1(x == xPos1 && y == yPos1 && !fretPressed && !vsync_pulse);
		fretValue1 <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule
	
	rule start_pixel2(x == xPos2 && y == yPos2 && !fretPressed && !vsync_pulse);
		fretValue2 <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule
	
	rule start_pixel3(x == xPos3 && y == yPos3 && !fretPressed && !vsync_pulse);
		fretValue3 <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule
	
	
	// Triggers for end of a note
	rule end_pixel1(x == xPos1 && y == yPos1 && fretPressed && !vsync_pulse);
		fretValue1 <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule
	
	rule end_pixel2(x == xPos2 && y == yPos2 && fretPressed && !vsync_pulse);
		fretValue2 <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule
	
	rule end_pixel3(x == xPos3 && y == yPos3 && fretPressed && !vsync_pulse);
		fretValue3 <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
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
		xPos1 <= val - 15;
		xPos2 <= val + 1;
		xPos3 <= val + 17;
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
	
	// Get Smoothing Value
	method Action smoothing(UInt#(4) val);
		smoothVal <= val;
	endmethod
	
	// Get Strum Time
	method Action strumTime(UInt#(4) val);
		strumTimeVal <= val;
	endmethod
	
	
	// Output fret pressed value
	method Bool press();
		return fretPressedDly;
	endmethod

	// Output strum value
	method Bool strum();
		return strumOutput;
	endmethod

endmodule
