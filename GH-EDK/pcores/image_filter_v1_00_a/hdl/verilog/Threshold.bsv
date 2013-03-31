// Thresholds a greyscale pixel value
// Returns 0 if below threshold, 255 otherwise

(* always_ready *)
interface Threshold;
	(* always_enabled, result = "bin_out", prefix = "" *)
	method ActionValue#(Bit#(1)) filter(UInt#(8) gry_in, UInt#(8) threshold);
endinterface


(* synthesize *)
module mkThreshold (Threshold);

	// Perform thresholding
	method ActionValue#(Bit#(1)) filter(UInt#(8) gry_in, UInt#(8) threshold);
		return (gry_in < threshold) ? 0 : 1;
	endmethod

endmodule