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
module mkFret (Fret);
	
	Vector#(22, Reg#(Bool)) fretValues <- replicateM(mkReg(False));
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
	
	Vector#(17, Wire#(UInt#(11))) xCoords <- replicateM(mkWire);
	
	Vector#(6, Wire#(UInt#(10))) yCoords <- replicateM(mkWire);


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
		                fretValues[ 6] ||
		                fretValues[ 7] ||
		                fretValues[ 8] ||
		                fretValues[ 9] ||
		                fretValues[10] ||
		                fretValues[11] ||
		                fretValues[12] ||
		                fretValues[13] ||
		                fretValues[14] ||
		                fretValues[15] ||
		                fretValues[16] ||
		                fretValues[17] ||
		                fretValues[18] ||
		                fretValues[19] ||
		                fretValues[20] ||
		                fretValues[21]);
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
	rule start_pixel0h(x == xCoords[0] && y == yCoords[5] && !fretPressed && !vsync_pulse);
		fretValues[0] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel1h(x == xCoords[1] && y == yCoords[5] && !fretPressed && !vsync_pulse);
		fretValues[1] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel2h(x == xCoords[2] && y == yCoords[5] && !fretPressed && !vsync_pulse);
		fretValues[2] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel3h(x == xCoords[3] && y == yCoords[5] && !fretPressed && !vsync_pulse);
		fretValues[3] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel4h(x == xCoords[4] && y == yCoords[5] && !fretPressed && !vsync_pulse);
		fretValues[4] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel5h(x == xCoords[5] && y == yCoords[5] && !fretPressed && !vsync_pulse);
		fretValues[5] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel6h(x == xCoords[6] && y == yCoords[5] && !fretPressed && !vsync_pulse);
		fretValues[6] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel7h(x == xCoords[7] && y == yCoords[5] && !fretPressed && !vsync_pulse);
		fretValues[7] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel8h(x == xCoords[8] && y == yCoords[5] && !fretPressed && !vsync_pulse);
		fretValues[8] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel9h(x == xCoords[9] && y == yCoords[5] && !fretPressed && !vsync_pulse);
		fretValues[9] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel10h(x == xCoords[10] && y == yCoords[5] && !fretPressed && !vsync_pulse);
		fretValues[10] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel11h(x == xCoords[11] && y == yCoords[5] && !fretPressed && !vsync_pulse);
		fretValues[11] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel12h(x == xCoords[12] && y == yCoords[5] && !fretPressed && !vsync_pulse);
		fretValues[12] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel13h(x == xCoords[13] && y == yCoords[5] && !fretPressed && !vsync_pulse);
		fretValues[13] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel14h(x == xCoords[14] && y == yCoords[5] && !fretPressed && !vsync_pulse);
		fretValues[14] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel15h(x == xCoords[15] && y == yCoords[5] && !fretPressed && !vsync_pulse);
		fretValues[15] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel16h(x == xCoords[16] && y == yCoords[5] && !fretPressed && !vsync_pulse);
		fretValues[16] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule


	rule start_pixel0v(x == xCoords[8] && y == yCoords[0] && !fretPressed && !vsync_pulse);
		fretValues[17] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel1v(x == xCoords[8] && y == yCoords[1] && !fretPressed && !vsync_pulse);
		fretValues[18] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel2v(x == xCoords[8] && y == yCoords[2] && !fretPressed && !vsync_pulse);
		fretValues[19] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel3v(x == xCoords[8] && y == yCoords[3] && !fretPressed && !vsync_pulse);
		fretValues[20] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel4v(x == xCoords[8] && y == yCoords[4] && !fretPressed && !vsync_pulse);
		fretValues[21] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule
	
	
	// Triggers for end of a note
	rule end_pixel0h(x == xCoords[0] && y == yCoords[5] && fretPressed && !vsync_pulse);
		fretValues[0] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel1h(x == xCoords[1] && y == yCoords[5] && fretPressed && !vsync_pulse);
		fretValues[1] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel2h(x == xCoords[2] && y == yCoords[5] && fretPressed && !vsync_pulse);
		fretValues[2] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel3h(x == xCoords[3] && y == yCoords[5] && fretPressed && !vsync_pulse);
		fretValues[3] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel4h(x == xCoords[4] && y == yCoords[5] && fretPressed && !vsync_pulse);
		fretValues[4] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel5h(x == xCoords[5] && y == yCoords[5] && fretPressed && !vsync_pulse);
		fretValues[5] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel6h(x == xCoords[6] && y == yCoords[5] && fretPressed && !vsync_pulse);
		fretValues[6] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel7h(x == xCoords[7] && y == yCoords[5] && fretPressed && !vsync_pulse);
		fretValues[7] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel8h(x == xCoords[8] && y == yCoords[5] && fretPressed && !vsync_pulse);
		fretValues[8] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel9h(x == xCoords[9] && y == yCoords[5] && fretPressed && !vsync_pulse);
		fretValues[9] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel10h(x == xCoords[10] && y == yCoords[5] && fretPressed && !vsync_pulse);
		fretValues[10] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel11h(x == xCoords[11] && y == yCoords[5] && fretPressed && !vsync_pulse);
		fretValues[11] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel12h(x == xCoords[12] && y == yCoords[5] && fretPressed && !vsync_pulse);
		fretValues[12] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel13h(x == xCoords[13] && y == yCoords[5] && fretPressed && !vsync_pulse);
		fretValues[13] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel14h(x == xCoords[14] && y == yCoords[5] && fretPressed && !vsync_pulse);
		fretValues[14] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel15h(x == xCoords[15] && y == yCoords[5] && fretPressed && !vsync_pulse);
		fretValues[15] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel16h(x == xCoords[16] && y == yCoords[5] && fretPressed && !vsync_pulse);
		fretValues[16] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule


	rule end_pixel0v(x == xCoords[8] && y == yCoords[0] && fretPressed && !vsync_pulse);
		fretValues[17] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel1v(x == xCoords[8] && y == yCoords[1] && fretPressed && !vsync_pulse);
		fretValues[18] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel2v(x == xCoords[8] && y == yCoords[2] && fretPressed && !vsync_pulse);
		fretValues[19] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel3v(x == xCoords[8] && y == yCoords[3] && fretPressed && !vsync_pulse);
		fretValues[20] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel4v(x == xCoords[8] && y == yCoords[4] && fretPressed && !vsync_pulse);
		fretValues[21] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
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
		xCoords[ 0] <= val - 8;
		xCoords[ 1] <= val - 7;
		xCoords[ 2] <= val - 6;
		xCoords[ 3] <= val - 5;
		xCoords[ 4] <= val - 4;
		xCoords[ 5] <= val - 3;
		xCoords[ 6] <= val - 2;
		xCoords[ 7] <= val - 1;
		xCoords[ 8] <= val;
		xCoords[ 9] <= val + 1;
		xCoords[10] <= val + 2;
		xCoords[11] <= val + 3;
		xCoords[12] <= val + 4;
		xCoords[13] <= val + 5;
		xCoords[14] <= val + 6;
		xCoords[15] <= val + 7;
		xCoords[16] <= val + 8;
	endmethod
	
	// Get Y position
	method Action yPos(UInt#(10) val);
		yCoords[ 0] <= val - 5;
		yCoords[ 1] <= val - 4;
		yCoords[ 2] <= val - 3;
		yCoords[ 3] <= val - 2;
		yCoords[ 4] <= val - 1;
		yCoords[ 5] <= val;
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
