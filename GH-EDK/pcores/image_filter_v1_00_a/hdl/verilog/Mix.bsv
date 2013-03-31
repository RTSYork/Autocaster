// Mixes a binary pixel value into an RGB image
// using function (bin | (rgb >> 2))

(* always_ready *)
interface Mix;
	(* always_enabled, result = "rgb_out", prefix = "" *)
	method ActionValue#(Bit#(24)) filter(Bool bin_in, Bit#(24) rgb_in);
endinterface


(* synthesize *)
module mkMix (Mix);

	Wire#(Bit#( 8)) red   <- mkUnsafeDWire(0);
	Wire#(Bit#( 8)) green <- mkUnsafeDWire(0);
	Wire#(Bit#( 8)) blue  <- mkUnsafeDWire(0);

	// Convert pixel
	method ActionValue#(Bit#(24)) filter(Bool bin_in, Bit#(24) rgb_in);
		red   <= bin_in ? 255 : zeroExtend(rgb_in[23:18]);
		green <= bin_in ? 255 : zeroExtend(rgb_in[15:10]);
		blue  <= bin_in ? 255 : zeroExtend(rgb_in[ 7: 2]);
		
		return {red, green, blue};
	endmethod

endmodule
