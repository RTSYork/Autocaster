module filters
(
	CLK,
	RST,
	HSync,
	VDE,
	Display,
	RGBin,
	
	ProcessOut,
	DisplayOut
);

input         CLK;
input         RST;
input         HSync;
input         VDE;
input  [ 5:0] Display;
input  [23:0] RGBin;

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
	assign DisplayOut = Display[0] ? { 3{greyOut}}    :
	                    Display[1] ? {24{thresh1Out}} :
	                    Display[2] ? { 3{blurOut}}    :
	                    Display[3] ? {24{thresh2Out}} :
	                    Display[4] ? {24{edgeOut}}    :
	                    Display[5] ?     mixOut       :
	                                     RGBin        ;
	
	
	// Convert image to greyscale
	mkGreyscale Greyscale (
		.CLK        (CLK),
		.RST_N      (RST),
		.rgb_in     (RGBin),	
		.gry_out    (greyOut)
	);
	
	// Threshold grey image
	mkThreshold # (
		.threshold  (8'd200)
	) Threshold1 (
		.CLK        (CLK),
		.RST_N      (RST),
		.gry_in     (greyOut),
		.bin_out    (thresh1Out)
	);
	
	// Blur image
	assign
		blurOut = {8{thresh1Out}};
	
	// Threshold blurred image
	mkThreshold # (
		.threshold  (8'd255)
	) Threshold2 (
		.CLK        (CLK),
		.RST_N      (RST),
		.gry_in     (blurOur),
		.bin_out    (thresh2Out)
	);
	
	// Edge detection
	assign
		edgeOut = thresh2Out;
		
	// Mix original image with filtered image
	assign
		mixOut = {{2{edgeOut}}, RGBin[23:18], {2{edgeOut}}, RGBin[15:10], {2{edgeOut}}, RGBin[7:2]};

	
endmodule
