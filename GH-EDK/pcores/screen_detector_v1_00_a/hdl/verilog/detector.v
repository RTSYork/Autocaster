module detector
(
	CLK,
	RST,
	Enable,
	HSync,
	VSync,
	PClk,
	VDE,
	RGB,
	
	Status
);

input         CLK;
input         RST;
input         Enable;
input         HSync;
input         VSync;
input         PClk;
input         VDE;
input  [23:0] RGB;

output [32:0] Status;


	wire status0;

	reg vClk, vSyncLast, vSyncLast2;
	reg hClk, hSyncLast, hSyncLast2;
	
	assign
		Status = Enable ? {31'b0, status0} : 32'b0;
	

	always @(posedge PClk)
	begin
		vSyncLast <= VSync;
		vSyncLast2 <= vSyncLast;
		
		if (vSyncLast && !vSyncLast2) begin
			vClk <= 1'b1;
		end else begin
			vClk <= 1'b0;
		end
	end
	
	always @(posedge PClk)
	begin
		hSyncLast <= HSync;
		hSyncLast2 <= hSyncLast;
		
		if (hSyncLast && !hSyncLast2) begin
			hClk <= 1'b1;
		end else begin
			hClk <= 1'b0;
		end
	end
	
	
	// RB3 - End of song
	mkScreen # (
		.numPos    (2'd2),
		.xPos1     (11'd83),
		.yPos1     (10'd605),
		.pixel1    (24'h38_73_00),
		.xPos2     (11'd366),
		.yPos2     (10'd605),
		.pixel2    (24'hD5_D5_0),
		.xPos3     (),
		.yPos3     (),
		.pixel3    ()
	) RB3End (
		.CLK       (PClk),
		.RST_N     (RST),
		.vsync     (vClk),
		.hsync     (hClk),
		.vde       (VDE),
		.rgb_pixel (RGB),
		
		.detected  (status0)
	);
	
endmodule
