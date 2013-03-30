// Thresholds a greyscale pixel value
// Returns 0 if below threshold, 255 otherwise

(* always_ready *)
interface Threshold;
	(* always_enabled, result = "bin_out", prefix = "" *)
	method ActionValue#(Bit#(1)) filter(UInt#(8) gry_in);
endinterface


(* synthesize *)
module mkThreshold #(parameter UInt#(8) threshold) (Threshold);

	// Perform thresholding
	method ActionValue#(Bit#(1)) filter(UInt#(8) gry_in);
		return (gry_in < threshold) ? 0 : 1;
	endmethod

endmodule