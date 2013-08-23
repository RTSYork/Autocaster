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
	
	Vector#(33, Reg#(Bool)) fretValues <- replicateM(mkReg(False));
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
	
	Vector#(17, Wire#(UInt#(10))) yCoords <- replicateM(mkWire);


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
		                fretValues[21] ||
		                fretValues[22] ||
		                fretValues[23] ||
		                fretValues[24]);/* ||
		                fretValues[25] ||
		                fretValues[26] ||
		                fretValues[27] ||
		                fretValues[28] ||
		                fretValues[29] ||
		                fretValues[30] ||
		                fretValues[31] ||
		                fretValues[32]);*/
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
	rule start_pixel0h(x == xCoords[0] && y == yCoords[8] && !fretPressed && !vsync_pulse);
		fretValues[0] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel1h(x == xCoords[1] && y == yCoords[8] && !fretPressed && !vsync_pulse);
		fretValues[1] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel2h(x == xCoords[2] && y == yCoords[8] && !fretPressed && !vsync_pulse);
		fretValues[2] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel3h(x == xCoords[3] && y == yCoords[8] && !fretPressed && !vsync_pulse);
		fretValues[3] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel4h(x == xCoords[4] && y == yCoords[8] && !fretPressed && !vsync_pulse);
		fretValues[4] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel5h(x == xCoords[5] && y == yCoords[8] && !fretPressed && !vsync_pulse);
		fretValues[5] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel6h(x == xCoords[6] && y == yCoords[8] && !fretPressed && !vsync_pulse);
		fretValues[6] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel7h(x == xCoords[7] && y == yCoords[8] && !fretPressed && !vsync_pulse);
		fretValues[7] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel8h(x == xCoords[8] && y == yCoords[8] && !fretPressed && !vsync_pulse);
		fretValues[8] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel9h(x == xCoords[9] && y == yCoords[8] && !fretPressed && !vsync_pulse);
		fretValues[9] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel10h(x == xCoords[10] && y == yCoords[8] && !fretPressed && !vsync_pulse);
		fretValues[10] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel11h(x == xCoords[11] && y == yCoords[8] && !fretPressed && !vsync_pulse);
		fretValues[11] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel12h(x == xCoords[12] && y == yCoords[8] && !fretPressed && !vsync_pulse);
		fretValues[12] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel13h(x == xCoords[13] && y == yCoords[8] && !fretPressed && !vsync_pulse);
		fretValues[13] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel14h(x == xCoords[14] && y == yCoords[8] && !fretPressed && !vsync_pulse);
		fretValues[14] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel15h(x == xCoords[15] && y == yCoords[8] && !fretPressed && !vsync_pulse);
		fretValues[15] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel16h(x == xCoords[16] && y == yCoords[8] && !fretPressed && !vsync_pulse);
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

	rule start_pixel5v(x == xCoords[8] && y == yCoords[5] && !fretPressed && !vsync_pulse);
		fretValues[22] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel6v(x == xCoords[8] && y == yCoords[6] && !fretPressed && !vsync_pulse);
		fretValues[23] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel7v(x == xCoords[8] && y == yCoords[7] && !fretPressed && !vsync_pulse);
		fretValues[24] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel9v(x == xCoords[8] && y == yCoords[9] && !fretPressed && !vsync_pulse);
		fretValues[25] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel10v(x == xCoords[8] && y == yCoords[10] && !fretPressed && !vsync_pulse);
		fretValues[26] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel11v(x == xCoords[8] && y == yCoords[11] && !fretPressed && !vsync_pulse);
		fretValues[27] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel12v(x == xCoords[8] && y == yCoords[12] && !fretPressed && !vsync_pulse);
		fretValues[28] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel13v(x == xCoords[8] && y == yCoords[13] && !fretPressed && !vsync_pulse);
		fretValues[29] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel14v(x == xCoords[8] && y == yCoords[14] && !fretPressed && !vsync_pulse);
		fretValues[30] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel15v(x == xCoords[8] && y == yCoords[15] && !fretPressed && !vsync_pulse);
		fretValues[31] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule

	rule start_pixel16v(x == xCoords[8] && y == yCoords[16] && !fretPressed && !vsync_pulse);
		fretValues[32] <= (red >= trigUpR && green >= trigUpG && blue >= trigUpB);
	endrule
	
	
	// Triggers for end of a note
	rule end_pixel0h(x == xCoords[0] && y == yCoords[8] && fretPressed && !vsync_pulse);
		fretValues[0] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel1h(x == xCoords[1] && y == yCoords[8] && fretPressed && !vsync_pulse);
		fretValues[1] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel2h(x == xCoords[2] && y == yCoords[8] && fretPressed && !vsync_pulse);
		fretValues[2] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel3h(x == xCoords[3] && y == yCoords[8] && fretPressed && !vsync_pulse);
		fretValues[3] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel4h(x == xCoords[4] && y == yCoords[8] && fretPressed && !vsync_pulse);
		fretValues[4] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel5h(x == xCoords[5] && y == yCoords[8] && fretPressed && !vsync_pulse);
		fretValues[5] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel6h(x == xCoords[6] && y == yCoords[8] && fretPressed && !vsync_pulse);
		fretValues[6] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel7h(x == xCoords[7] && y == yCoords[8] && fretPressed && !vsync_pulse);
		fretValues[7] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel8h(x == xCoords[8] && y == yCoords[8] && fretPressed && !vsync_pulse);
		fretValues[8] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel9h(x == xCoords[9] && y == yCoords[8] && fretPressed && !vsync_pulse);
		fretValues[9] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel10h(x == xCoords[10] && y == yCoords[8] && fretPressed && !vsync_pulse);
		fretValues[10] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel11h(x == xCoords[11] && y == yCoords[8] && fretPressed && !vsync_pulse);
		fretValues[11] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel12h(x == xCoords[12] && y == yCoords[8] && fretPressed && !vsync_pulse);
		fretValues[12] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel13h(x == xCoords[13] && y == yCoords[8] && fretPressed && !vsync_pulse);
		fretValues[13] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel14h(x == xCoords[14] && y == yCoords[8] && fretPressed && !vsync_pulse);
		fretValues[14] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel15h(x == xCoords[15] && y == yCoords[8] && fretPressed && !vsync_pulse);
		fretValues[15] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel16h(x == xCoords[16] && y == yCoords[8] && fretPressed && !vsync_pulse);
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

	rule end_pixel5v(x == xCoords[8] && y == yCoords[5] && fretPressed && !vsync_pulse);
		fretValues[22] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel6v(x == xCoords[8] && y == yCoords[6] && fretPressed && !vsync_pulse);
		fretValues[23] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel7v(x == xCoords[8] && y == yCoords[7] && fretPressed && !vsync_pulse);
		fretValues[24] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel9v(x == xCoords[8] && y == yCoords[9] && fretPressed && !vsync_pulse);
		fretValues[25] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel10v(x == xCoords[8] && y == yCoords[10] && fretPressed && !vsync_pulse);
		fretValues[26] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel11v(x == xCoords[8] && y == yCoords[11] && fretPressed && !vsync_pulse);
		fretValues[27] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel12v(x == xCoords[8] && y == yCoords[12] && fretPressed && !vsync_pulse);
		fretValues[28] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel13v(x == xCoords[8] && y == yCoords[13] && fretPressed && !vsync_pulse);
		fretValues[29] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel14v(x == xCoords[8] && y == yCoords[14] && fretPressed && !vsync_pulse);
		fretValues[30] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel15v(x == xCoords[8] && y == yCoords[15] && fretPressed && !vsync_pulse);
		fretValues[31] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
	endrule

	rule end_pixel16v(x == xCoords[8] && y == yCoords[16] && fretPressed && !vsync_pulse);
		fretValues[32] <= (red >= trigDownR || green >= trigDownG || blue >= trigDownB);
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
		yCoords[ 0] <= val - 8;
		yCoords[ 1] <= val - 7;
		yCoords[ 2] <= val - 6;
		yCoords[ 3] <= val - 5;
		yCoords[ 4] <= val - 4;
		yCoords[ 5] <= val - 3;
		yCoords[ 6] <= val - 2;
		yCoords[ 7] <= val - 1;
		yCoords[ 8] <= val;
		yCoords[ 9] <= val + 1;
		yCoords[10] <= val + 2;
		yCoords[11] <= val + 3;
		yCoords[12] <= val + 4;
		yCoords[13] <= val + 5;
		yCoords[14] <= val + 6;
		yCoords[15] <= val + 7;
		yCoords[16] <= val + 8;
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
