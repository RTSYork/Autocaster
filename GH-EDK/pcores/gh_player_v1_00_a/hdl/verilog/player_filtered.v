module player_filtered
(
	CLK,
	RST,
	Enable,
	HSync,
	VSync,
	PClk,
	VDE,
	Pixel,
	GreenPos,
	RedPos,
	YellowPos,
	BluePos,
	OrangePos,
	StrumTime,
	
	Frets,
	Strum,
	Whammy,
	Tilt,
	LEDs,
	Status
);

input         CLK;
input         RST;
input         Enable;
input         HSync;
input         VSync;
input         PClk;
input         VDE;
input         Pixel;
input  [23:0] GreenPos;
input  [23:0] RedPos;
input  [23:0] YellowPos;
input  [23:0] BluePos;
input  [23:0] OrangePos;
input  [ 3:0] StrumTime;

output [ 4:0] Frets;
output        Strum;
output [ 7:0] Whammy;
output        Tilt;
output [ 7:0] LEDs;
output [14:0] Status;


	wire       fretG, fretR, fretY, fretB, fretO;
	wire       strumG, strumR, strumY, strumB, strumO;
	wire [7:0] whammyVal;
	wire       tiltVal;
	
	reg vClk, vSyncLast, vSyncLast2;
	reg hClk, hSyncLast, hSyncLast2;
	
	
	assign
		Frets  = Enable ? {fretO, fretB, fretY, fretR, fretG} : 5'b0,
		Strum  = Enable ? strumOut : 1'b0,
		Whammy = Enable ? whammyVal : 8'b0,
		Tilt   = Enable ? tiltVal : 1'b0,
		LEDs   = {tiltVal, whammyVal[7], strumOut, fretO, fretB, fretY, fretR, fretG},
		Status = {tiltVal, whammyVal, strumOut, fretO, fretB, fretY, fretR, fretG};
	
	
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
	
	
	// Whammy Controller
	mkWhammy WhammyBar (
		.CLK          (CLK),
		.RST_N        (RST),
		.move_enabled (1'b1),
		
		.out          (whammyVal)
	);
	
	
	// Tilt Controller
	mkTilt Tilter (
		.CLK          (CLK),
		.RST_N        (RST),
		.move_enabled (1'b1),
		
		.out          (tiltVal)
	);
	
	
	// Strum Controller
	mkStrum Strummer (
		.CLK           (PClk),
		.RST_N         (RST),
		.vsync         (vClk),
		.strumTime_in  (StrumTime),
		.fret_g        (fretG),
		.fret_r        (fretR),
		.fret_y        (fretY),
		.fret_b        (fretB),
		.fret_o        (fretO),
		
		.strum         (strumOut)
	);
	
	
	// Green Fret Controller
	mkFretFiltered GreenFret (
		.CLK           (PClk),
		.RST_N         (RST),
		.vsync         (vClk),
		.hsync         (hClk),
		.vde           (VDE),
		.pixel_in      (Pixel),
		.xPos_in       (GreenPos[10:0]),
		.yPos_in       (GreenPos[21:12]),
		
		.press         (fretG)
	);
	
	// Red Fret Controller
	mkFretFiltered RedFret (
		.CLK           (PClk),
		.RST_N         (RST),
		.vsync         (vClk),
		.hsync         (hClk),
		.vde           (VDE),
		.pixel_in      (Pixel),
		.xPos_in       (RedPos[10:0]),
		.yPos_in       (RedPos[21:12]),
		
		.press         (fretR)
	);
	
	// Yellow Fret Controller
	mkFretFiltered YellowFret (
		.CLK           (PClk),
		.RST_N         (RST),
		.vsync         (vClk),
		.hsync         (hClk),
		.vde           (VDE),
		.pixel_in      (Pixel),
		.xPos_in       (YellowPos[10:0]),
		.yPos_in       (YellowPos[21:12]),
		
		.press         (fretY)
	);
	
	// Blue Fret Controller
	mkFretFiltered BlueFret (
		.CLK           (PClk),
		.RST_N         (RST),
		.vsync         (vClk),
		.hsync         (hClk),
		.vde           (VDE),
		.pixel_in      (Pixel),
		.xPos_in       (BluePos[10:0]),
		.yPos_in       (BluePos[21:12]),
		
		.press         (fretB)
	);
	
	// Orange Fret Controller
	mkFretFiltered OrangeFret (
		.CLK           (PClk),
		.RST_N         (RST),
		.vsync         (vClk),
		.hsync         (hClk),
		.vde           (VDE),
		.pixel_in      (Pixel),
		.xPos_in       (OrangePos[10:0]),
		.yPos_in       (OrangePos[21:12]),
		
		.press         (fretO)
	);

	
	
endmodule
