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


	wire endGame, player1, player2, player3, player4, songLibrary, mainMenu, pause1, pause2;

	reg vClk, vSyncLast, vSyncLast2;
	reg hClk, hSyncLast, hSyncLast2;
	
	assign
		Status = Enable ? {24'b0, (pause1 | pause2), mainMenu, songLibrary, player4, player3, player2, player1, endGame} : 32'b0;
	

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
		.xPos1     (11'd84),
		.yPos1     (10'd605),
		.pixel1    (24'h3A7500),
		.xPos2     (11'd366),
		.yPos2     (10'd605),
		.pixel2    (24'hD5D500),
		.xPos3     (0),
		.yPos3     (0),
		.pixel3    (0)
	) RB3End (
		.CLK       (PClk),
		.RST_N     (RST),
		.vsync     (vClk),
		.hsync     (hClk),
		.vde       (VDE),
		.rgb_pixel (RGB),
		
		.detected  (endGame)
	);

	// RB3 - Player 1
	mkScreen # (
		.numPos    (2'd1),
		.xPos1     (11'd205),
		.yPos1     (10'd705),
		.pixel1    (24'h978f0d),
		.xPos2     (0),
		.yPos2     (0),
		.pixel2    (0),
		.xPos3     (0),
		.yPos3     (0),
		.pixel3    (0)
	) RB3P1 (
		.CLK       (PClk),
		.RST_N     (RST),
		.vsync     (vClk),
		.hsync     (hClk),
		.vde       (VDE),
		.rgb_pixel (RGB),
		
		.detected  (player1)
	);

	// RB3 - Player 2
	mkScreen # (
		.numPos    (2'd1),
		.xPos1     (11'd496),
		.yPos1     (10'd705),
		.pixel1    (24'h978f0d),
		.xPos2     (0),
		.yPos2     (0),
		.pixel2    (0),
		.xPos3     (0),
		.yPos3     (0),
		.pixel3    (0)
	) RB3P2 (
		.CLK       (PClk),
		.RST_N     (RST),
		.vsync     (vClk),
		.hsync     (hClk),
		.vde       (VDE),
		.rgb_pixel (RGB),
		
		.detected  (player2)
	);

	// RB3 - Player 3
	mkScreen # (
		.numPos    (2'd1),
		.xPos1     (11'd787),
		.yPos1     (10'd705),
		.pixel1    (24'h968d0b),
		.xPos2     (0),
		.yPos2     (0),
		.pixel2    (0),
		.xPos3     (0),
		.yPos3     (0),
		.pixel3    (0)
	) RB3P3 (
		.CLK       (PClk),
		.RST_N     (RST),
		.vsync     (vClk),
		.hsync     (hClk),
		.vde       (VDE),
		.rgb_pixel (RGB),
		
		.detected  (player3)
	);

	// RB3 - Player 4
	mkScreen # (
		.numPos    (2'd1),
		.xPos1     (11'd1076),
		.yPos1     (10'd705),
		.pixel1    (24'h978e0c),
		.xPos2     (0),
		.yPos2     (0),
		.pixel2    (0),
		.xPos3     (0),
		.yPos3     (0),
		.pixel3    (0)
	) RB3P4 (
		.CLK       (PClk),
		.RST_N     (RST),
		.vsync     (vClk),
		.hsync     (hClk),
		.vde       (VDE),
		.rgb_pixel (RGB),
		
		.detected  (player4)
	);

	// RB3 - Library
	mkScreen # (
		.numPos    (2'd3),
		.xPos1     (11'd910),
		.yPos1     (10'd24),
		.pixel1    (24'h4b4b4b),
		.xPos2     (11'd1076),
		.yPos2     (10'd24),
		.pixel2    (24'h737373),
		.xPos3     (11'd1214),
		.yPos3     (10'd24),
		.pixel3    (24'h494649)
	) RB3Lib (
		.CLK       (PClk),
		.RST_N     (RST),
		.vsync     (vClk),
		.hsync     (hClk),
		.vde       (VDE),
		.rgb_pixel (RGB),
		
		.detected  (songLibrary)
	);

	// RB3 - Main menu
	mkScreen # (
		.numPos    (2'd3),
		.xPos1     (11'd117),
		.yPos1     (10'd239),
		.pixel1    (24'h292b00),
		.xPos2     (11'd121),
		.yPos2     (10'd276),
		.pixel2    (24'hfbfbfb),
		.xPos3     (11'd89),
		.yPos3     (10'd299),
		.pixel3    (24'hfbfbfb)
	) RB3Menu (
		.CLK       (PClk),
		.RST_N     (RST),
		.vsync     (vClk),
		.hsync     (hClk),
		.vde       (VDE),
		.rgb_pixel (RGB),
		
		.detected  (mainMenu)
	);

	// RB3 - Pause menu
	mkScreen # (
		.numPos    (2'd3),
		.xPos1     (11'd628),
		.yPos1     (10'd441),
		.pixel1    (24'hf0f0f0),
		.xPos2     (11'd640),
		.yPos2     (10'd470),
		.pixel2    (24'hf0f0f0),
		.xPos3     (11'd700),
		.yPos3     (10'd469),
		.pixel3    (24'hf0f0f0)
	) RB3Pause1 (
		.CLK       (PClk),
		.RST_N     (RST),
		.vsync     (vClk),
		.hsync     (hClk),
		.vde       (VDE),
		.rgb_pixel (RGB),
		
		.detected  (pause1)
	);
	mkScreen # (
		.numPos    (2'd3),
		.xPos1     (11'd626),
		.yPos1     (10'd526),
		.pixel1    (24'hf0f0f0),
		.xPos2     (11'd597),
		.yPos2     (10'd583),
		.pixel2    (24'hf0f0f0),
		.xPos3     (11'd639),
		.yPos3     (10'd582),
		.pixel3    (24'hf0f0f0)
	) RB3Pause2 (
		.CLK       (PClk),
		.RST_N     (RST),
		.vsync     (vClk),
		.hsync     (hClk),
		.vde       (VDE),
		.rgb_pixel (RGB),
		
		.detected  (pause2)
	);
	
endmodule
