module player_filtered
(
	CLK,
	RST,
	Enable,
	HSync,
	VSync,
	PClk,
	VDE,
	RGB,
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
input  [23:0] RGB;
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
		Strum  = Enable ? (strumG | strumR | strumY | strumB | strumO) : 1'b0,
		Whammy = Enable ? whammyVal : 8'b0,
		Tilt   = Enable ? tiltVal : 1'b0,
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
	
	

	
	
endmodule
