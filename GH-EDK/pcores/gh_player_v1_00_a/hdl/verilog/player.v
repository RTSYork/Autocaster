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
	DelayValue,
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
input   [4:0] DelayValue;
input   [3:0] StrumTime;

output  [4:0] Frets;
output        Strum;
output  [7:0] Whammy;
output        Tilt;
output  [7:0] LEDs;
output [14:0] Status;


	wire       fretG, fretR, fretY, fretB, fretO;
	wire [7:0] whammyVal;
	wire       tiltVal;
	wire [4:0] fretsVal, fretsDly;
	wire       strumVal, strumDly;
	
	reg vClk, vSyncLast, vSyncLast2;
	reg hClk, hSyncLast, hSyncLast2;
	
	assign
		fretsVal  = {fretO, fretB, fretY, fretR, fretG};
	
	assign
		Frets  = Enable ? fretsDly : 5'b0,
		Strum  = Enable ? strumDly : 1'b0,
		Whammy = Enable ? whammyVal : 8'b0,
		Tilt   = Enable ? tiltVal : 1'b0,
		LEDs   = {tiltVal, whammyVal[7], strumDly, fretsDly},
		Status = {tiltVal, whammyVal, strumDly, fretsDly};
	
	
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
	
	
	// Delay
	mkDelay Delay (
		.CLK          (PClk),
		.RST_N        (RST),
		.vsync        (vClk),
		.delay_in     (DelayValue),
		.frets        (fretsVal),
		.strum        (strumVal),
		
		.frets_out    (fretsDly),
		.strum_out    (strumDly)
	);
	
	
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
		
		.strum         (strumVal)
	);
	
	
	// Green Fret Controller
	mkFret GreenFret (
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
		
		.press         (fretG)
	);
	
	// Red Fret Controller
	mkFret RedFret (
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
		
		.press         (fretR)
	);
	
	// Yellow Fret Controller
	mkFret YellowFret (
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
		
		.press         (fretY)
	);
	
	// Blue Fret Controller
	mkFret BlueFret (
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
		
		.press         (fretB)
	);
	
	// Orange Fret Controller
	mkFret OrangeFret (
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
		
		.press         (fretO)
	);
	
	
endmodule
