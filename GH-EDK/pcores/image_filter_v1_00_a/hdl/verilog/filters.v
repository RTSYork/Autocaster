module filters
(
	CLK,
	RST,
	HSync,
	Enable,
	RGBin,
	
	RGBout
);

input         CLK;
input         RST;
input         HSync;
input         Enable;
input  [23:0] RGBin;

output [23:0] RGBout;


	wire [ 7:0] grey1;
	wire [ 7:0] grey2;


	// Assign RGB output
	assign
		RGBout = {grey2, grey2, grey2};
	
	
	// Convert pixel to greyscale
	mkGreyscale Greyscale (
		.CLK        (CLK),
		.RST_N      (RST),
		.rgb_in     (RGBin),
		
		.gry_out    (grey1)
	);
	
	// Threshold grey pixel
	mkThreshold # (
		.threshold  (8'd172)
	) Threshold (
		.CLK        (CLK),
		.RST_N      (RST),
		.gry_in     (grey1),
		
		.gry_out    (grey2)
	);

	
endmodule
