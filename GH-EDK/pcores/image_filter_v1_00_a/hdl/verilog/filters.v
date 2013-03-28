module filters
(
	CLK,
	RST,
	HSync,
	Enables,
	RGBin,
	
	RGBout
);

input         CLK;
input         RST;
input         HSync;
input  [ 5:0] Enables;
input  [23:0] RGBin;

output [23:0] RGBout;


	wire [ 7:0] f1Out;
	wire [ 7:0] f2In;
	wire [ 7:0] f2Out;
	wire [ 7:0] f3In;
	wire [ 7:0] f3Out;
	wire [ 7:0] f4In;
	wire [ 7:0] f4Out;
	wire [ 7:0] f5In;
	wire [ 7:0] f5Out;
	wire [ 7:0] greyOut;


	// Assign RGB output
	assign
		RGBout = {greyOut, greyOut, greyOut};
	
	// Filter connections
	assign
		f2In    = Enables[0] ? f1Out : RGBin[7:0],
		f3In    = Enables[1] ? f2Out : f1Out,
		f4In    = Enables[2] ? f3Out : f2Out,
		f5In    = Enables[3] ? f4Out : f3Out,
		greyOut = Enables[4] ? f5Out : f4Out;
	
	// Convert image to greyscale
	mkGreyscale Greyscale (
		.CLK        (CLK),
		.RST_N      (RST),
		.rgb_in     (RGBin),
		
		.gry_out    (f1Out)
	);
	
	// Threshold grey image
	mkThreshold # (
		.threshold  (8'd172)
	) Threshold1 (
		.CLK        (CLK),
		.RST_N      (RST),
		.gry_in     (f2In),
		
		.gry_out    (f2Out)
	);
	
	// Blur image
	assign
		f3Out = f3In;
	
	// Threshold blurred image
	mkThreshold # (
		.threshold  (8'd255)
	) Threshold2 (
		.CLK        (CLK),
		.RST_N      (RST),
		.gry_in     (f4In),
		
		.gry_out    (f4Out)
	);
	
	// Edge detection
	assign
		f5Out = f5In;

	
endmodule
