module filters
(
	CLK,
	RST,
	HSync,
	VDE,
	Display,
	RGBin,
	Threshold,
	
	ProcessOut,
	DisplayOut
);

input         CLK;
input         RST;
input         HSync;
input         VDE;
input  [ 5:0] Display;
input  [23:0] RGBin;
input  [ 7:0] Threshold;

output        ProcessOut;
output [23:0] DisplayOut;


	wire [ 7:0] greyOut;
	wire        thresh1Out;
	wire [ 7:0] blurOut;
	wire        thresh2Out;
	wire        edgeOut;
	wire [23:0] mixOut;
	
	
	// Assign process output
	assign
		ProcessOut = edgeOut;
	
	// Assign display output			 
	assign DisplayOut = Display[5] ?     mixOut       :
	                    Display[4] ? {24{edgeOut}}    :
	                    Display[3] ? {24{thresh2Out}} :
	                    Display[2] ? { 3{blurOut}}    :
	                    Display[1] ? {24{thresh1Out}} :
	                    Display[0] ? { 3{greyOut}}    :
	                                     RGBin        ;
	
	
	// Convert image to greyscale
	mkGreyscale Greyscale (
		.rgb_in     (RGBin),	
		.gry_out    (greyOut)
	);
	
	// Threshold grey image
	mkThreshold Threshold1 (
		.threshold  (Threshold),
		.gry_in     (greyOut),
		.bin_out    (thresh1Out)
	);
	
	// Blur image
	mkBlur Blur (
		.CLK        (CLK),
		.RST_N      (RST),
		.hsync      (HSync),
		.vde        (VDE),
		.bin_in     (thresh1Out),
		.gry_out    (blurOut)
	);
	
	// Threshold blurred image
	mkThreshold Threshold2 (
		.threshold  (8'hFF),
		.gry_in     (blurOut),
		.bin_out    (thresh2Out)
	);
	
	// Edge detection
	mkEdge Edge (
		.CLK        (CLK),
		.RST_N      (RST),
		.hsync      (HSync),
		.vde        (VDE),
		.bin_in     (thresh2Out),
		.bin_out    (edgeOut)
	);
		
	// Mix original image with filtered image
	mkMix Mix (
		.bin_in     (edgeOut),
		.rgb_in     (RGBin),
		.rgb_out    (mixOut)
	);

	
endmodule
