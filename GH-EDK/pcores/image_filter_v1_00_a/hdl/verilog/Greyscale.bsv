// Converts an RGB pixel to greyscale value
// using function (((R + G + B) / 2) - 127)

(* always_ready *)
interface Greyscale;
	(* always_enabled, result = "gry_out", prefix = "" *)
	method ActionValue#(Bit#(8)) filter(Bit#(24) rgb_in);
endinterface


(* synthesize *)
module mkGreyscale (Greyscale);

	Wire#(UInt#(8)) red   <- mkUnsafeDWire(0);
	Wire#(UInt#(8)) green <- mkUnsafeDWire(0);
	Wire#(UInt#(8)) blue  <- mkUnsafeDWire(0);
	Wire#(UInt#(9)) sum   <- mkUnsafeDWire(0);
	Wire#(UInt#(8)) grey  <- mkUnsafeDWire(0); 

	// Convert pixel
	method ActionValue#(Bit#(8)) filter(Bit#(24) rgb_in);
		red   <= unpack(rgb_in[23:16]);
		green <= unpack(rgb_in[15: 8]);
		blue  <= unpack(rgb_in[ 7: 0]);
		
		sum   <= (zeroExtend(green) + zeroExtend(blue)) >> 1;
		grey  <= truncate((sum + zeroExtend(red)) >> 1);
		
		return pack(grey);
	endmethod

endmodule
