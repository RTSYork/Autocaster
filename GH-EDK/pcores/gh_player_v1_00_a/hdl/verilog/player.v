module player
(
	CLK,
	RST,
	Enable,
	HSync,
	VSync,
	PClk,
	VDE,
	RGB,
	GreenOn,
	GreenOff,
	GreenPos,
	RedOn,
	RedOff,
	RedPos,
	YellowOn,
	YellowOff,
	YellowPos,
	BlueOn,
	BlueOff,
	BluePos,
	OrangeOn,
	OrangeOff,
	OrangePos,
	SmoothValue,
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
input  [23:0] RGB;
input  [23:0] GreenOn;
input  [23:0] GreenOff;
input  [23:0] GreenPos;
input  [23:0] RedOn;
input  [23:0] RedOff;
input  [23:0] RedPos;
input  [23:0] YellowOn;
input  [23:0] YellowOff;
input  [23:0] YellowPos;
input  [23:0] BlueOn;
input  [23:0] BlueOff;
input  [23:0] BluePos;
input  [23:0] OrangeOn;
input  [23:0] OrangeOff;
input  [23:0] OrangePos;
input   [3:0] SmoothValue;
input   [3:0] StrumTime;

output  [4:0] Frets;
output        Strum;
output  [7:0] Whammy;
output        Tilt;
output  [7:0] LEDs;
output [14:0] Status;


	wire       fretG, fretR, fretY, fretB, fretO;
	wire       strumG, strumR, strumY, strumB, strumO;
	wire [7:0] whammyVal;
	wire       tiltVal;
	
	reg vClk, vSyncLast, vSyncLast2;
	reg hClk, hSyncLast, hSyncLast2;
	
	
	assign
		Frets  = (Enable == 1'b1) ? {fretO, fretB, fretY, fretR, fretG} : 5'b0,
		Strum  = (Enable == 1'b1) ? (strumG | strumR | strumY | strumB | strumO) : 1'b0,
		Whammy = (Enable == 1'b1) ? whammyVal : 8'b0,
		Tilt   = (Enable == 1'b1) ? tiltVal : 1'b0,
		LEDs   = {tiltVal, whammyVal[7], (strumG | strumR | strumY | strumB | strumO), fretO, fretB, fretY, fretR, fretG},
		Status = {tiltVal, whammyVal, (strumG | strumR | strumY | strumB | strumO), fretO, fretB, fretY, fretR, fretG};
	
	
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
	
	
	// Green Fret Controller
	mkFret # (
		.lOffset       (2),
		.rOffset       (0)
	) GreenFret (
		.CLK           (PClk),
		.RST_N         (RST),
		.vsync         (vClk),
		.hsync         (hClk),
		.vde           (VDE),
		.rgb_pixel     (RGB),
		.xPos_val      (GreenPos[10:0]),
		.yPos_val      (GreenPos[21:12]),
		.trigUp_val    (GreenOn),
		.trigDown_val  (GreenOff),
		.smoothing_val (SmoothValue),
		.strumTime_val (StrumTime),
		
		.press         (fretG),
		.strum         (strumG)
	);
	
	// Red Fret Controller
	mkFret # (
		.lOffset       (1),
		.rOffset       (0)
	) RedFret (
		.CLK           (PClk),
		.RST_N         (RST),
		.vsync         (vClk),
		.hsync         (hClk),
		.vde           (VDE),
		.rgb_pixel     (RGB),
		.xPos_val      (RedPos[10:0]),
		.yPos_val      (RedPos[21:12]),
		.trigUp_val    (RedOn),
		.trigDown_val  (RedOff),
		.smoothing_val (SmoothValue),
		.strumTime_val (StrumTime),
		
		.press         (fretR),
		.strum         (strumR)
	);
	
	// Yellow Fret Controller
	mkFret # (
		.lOffset       (1),
		.rOffset       (1)
	) YellowFret (
		.CLK           (PClk),
		.RST_N         (RST),
		.vsync         (vClk),
		.hsync         (hClk),
		.vde           (VDE),
		.rgb_pixel     (RGB),
		.xPos_val      (YellowPos[10:0]),
		.yPos_val      (YellowPos[21:12]),
		.trigUp_val    (YellowOn),
		.trigDown_val  (YellowOff),
		.smoothing_val (SmoothValue),
		.strumTime_val (StrumTime),
		
		.press         (fretY),
		.strum         (strumY)
	);
	
	// Blue Fret Controller
	mkFret # (
		.lOffset       (0),
		.rOffset       (1)
	) BlueFret (
		.CLK           (PClk),
		.RST_N         (RST),
		.vsync         (vClk),
		.hsync         (hClk),
		.vde           (VDE),
		.rgb_pixel     (RGB),
		.xPos_val      (BluePos[10:0]),
		.yPos_val      (BluePos[21:12]),
		.trigUp_val    (BlueOn),
		.trigDown_val  (BlueOff),
		.smoothing_val (SmoothValue),
		.strumTime_val (StrumTime),
		
		.press         (fretB),
		.strum         (strumB)
	);
	
	// Orange Fret Controller
	mkFret # (
		.lOffset      (0),
		.rOffset      (2)
	) OrangeFret (
		.CLK           (PClk),
		.RST_N         (RST),
		.vsync         (vClk),
		.hsync         (hClk),
		.vde           (VDE),
		.rgb_pixel     (RGB),
		.xPos_val      (OrangePos[10:0]),
		.yPos_val      (OrangePos[21:12]),
		.trigUp_val    (OrangeOn),
		.trigDown_val  (OrangeOff),
		.smoothing_val (SmoothValue),
		.strumTime_val (StrumTime),
		
		.press         (fretO),
		.strum         (strumO)
	);
	
	
endmodule
