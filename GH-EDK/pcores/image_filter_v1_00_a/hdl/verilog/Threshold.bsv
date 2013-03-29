// Thresholds a greyscale pixel value
// Returns 0 if below threshold, 255 otherwise

(* always_ready *)
interface Threshold;
	(* always_enabled, prefix = "" *)
	method Action filter(UInt#(8) gry_in);
	
	method Bit#(8) gry_out();
	method Bit#(1) bin_out();
endinterface


(* synthesize *)
module mkThreshold #(parameter UInt#(8) threshold) (Threshold);

	Wire#(Bool) belowThreshold <- mkDWire(False);

	// Perform thresholding
	method Action filter(UInt#(8) gry_in);
		belowThreshold <= (gry_in < threshold);
	endmethod
	
	method Bit#(8) gry_out();
		return belowThreshold ? 0 : 255;
	endmethod
	
	method Bit#(1) bin_out();
		return belowThreshold ? 0 : 1;
	endmethod

endmodule
