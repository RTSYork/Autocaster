// Guitar Hero-style game player

import Vector :: * ;

(* always_ready *)
interface Screen;
	(* enable = "vsync" *)
	method Action vsync();
	(* enable = "hsync" *)
	method Action hsync();
	(* enable = "vde" *)
	method Action vde();
	
	(* always_enabled *)
	method Action rgb(Bit#(24) pixel);
	(* always_enabled *)
	
	method Bool detected();
endinterface


(* synthesize *)
module mkScreen # (
		parameter UInt#(2) numPos,
		parameter UInt#(11) xPos1,
		parameter UInt#(10) yPos1,
		parameter Bit#(24) pixel1,
		parameter UInt#(11) xPos2,
		parameter UInt#(10) yPos2,
		parameter Bit#(24) pixel2,
		parameter UInt#(11) xPos3,
		parameter UInt#(10) yPos3,
		parameter Bit#(24) pixel3
	) (Screen);
	
	Vector#(3, Reg#(Bool)) pointDetected <- replicateM(mkReg(False));
	Reg#(Bool) currentDetected <- mkReg(False);
	Reg#(Bool) lastDetected <- mkReg(False);
	
	Wire#(UInt#(8)) red   <- mkWire;
	Wire#(UInt#(8)) green <- mkWire;
	Wire#(UInt#(8)) blue  <- mkWire;
	
	PulseWire hsync_pulse <- mkPulseWire();
	PulseWire vsync_pulse <- mkPulseWire();
	PulseWire vde_pulse <- mkPulseWire();
	
	Reg#(UInt#(11)) x <- mkReg(0);
	Reg#(UInt#(10)) y <- mkReg(0);


	// New frame on each VSync pulse
	rule new_frame(vsync_pulse);
		x <= 0;
		y <= 0;
		
		// Update fret value
		lastDetected <= currentDetected;
		currentDetected <= ((pointDetected[0]) &&
		                    (pointDetected[1]) &&
		                    (pointDetected[2]));
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
	
	
	// Detect points on screen
	rule point1(x == xPos1 && y == yPos1 && !vsync_pulse && numPos > 0);
		UInt#(8) r = unpack(pixel1[23:16]);
		UInt#(8) g = unpack(pixel1[15:8]);
		UInt#(8) b = unpack(pixel1[7:0]);

		Bool rMatch = (r > red) ? ((r - red) < 8) : ((red - r) < 8);
		Bool gMatch = (g > green) ? ((g - green) < 8) : ((green - g) < 8);
		Bool bMatch = (b > blue) ? ((b - blue) < 8) : ((blue - b) < 8);

		pointDetected[0] <= rMatch && gMatch && bMatch;
	endrule

	rule point2(x == xPos2 && y == yPos2 && !vsync_pulse && numPos > 1);
		UInt#(8) r = unpack(pixel2[23:16]);
		UInt#(8) g = unpack(pixel2[15:8]);
		UInt#(8) b = unpack(pixel2[7:0]);

		Bool rMatch = (r > red) ? ((r - red) < 8) : ((red - r) < 8);
		Bool gMatch = (g > green) ? ((g - green) < 8) : ((green - g) < 8);
		Bool bMatch = (b > blue) ? ((b - blue) < 8) : ((blue - b) < 8);

		pointDetected[1] <= rMatch && gMatch && bMatch;
	endrule

	rule point3(x == xPos3 && y == yPos3 && !vsync_pulse && numPos > 2);
		UInt#(8) r = unpack(pixel3[23:16]);
		UInt#(8) g = unpack(pixel3[15:8]);
		UInt#(8) b = unpack(pixel3[7:0]);

		Bool rMatch = (r > red) ? ((r - red) < 8) : ((red - r) < 8);
		Bool gMatch = (g > green) ? ((g - green) < 8) : ((green - g) < 8);
		Bool bMatch = (b > blue) ? ((b - blue) < 8) : ((blue - b) < 8);

		pointDetected[2] <= rMatch && gMatch && bMatch;
	endrule


	rule noPoint1(numPos < 1);
		pointDetected[0] <= True;
	endrule

	rule noPoint2(numPos < 2);
		pointDetected[1] <= True;
	endrule

	rule noPoint3(numPos < 3);
		pointDetected[2] <= True;
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
	
	
	// Output fret pressed value
	method Bool detected();
		return currentDetected && lastDetected;
	endmethod

endmodule
