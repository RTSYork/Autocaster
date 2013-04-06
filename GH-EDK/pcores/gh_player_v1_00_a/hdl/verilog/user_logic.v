//----------------------------------------------------------------------------
// user_logic.v - module
//----------------------------------------------------------------------------
//
// ***************************************************************************
// ** Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.            **
// **                                                                       **
// ** Xilinx, Inc.                                                          **
// ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
// ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
// ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
// ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
// ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
// ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
// ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
// ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
// ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
// ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
// ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
// ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
// ** FOR A PARTICULAR PURPOSE.                                             **
// **                                                                       **
// ***************************************************************************
//
//----------------------------------------------------------------------------
// Filename:          user_logic.v
// Version:           1.00.a
// Description:       User logic module.
// Date:              Wed Jan 02 17:10:03 2013 (by Create and Import Peripheral Wizard)
// Verilog Standard:  Verilog-2001
//----------------------------------------------------------------------------
// Naming Conventions:
//   active low signals:                    "*_n"
//   clock signals:                         "clk", "clk_div#", "clk_#x"
//   reset signals:                         "rst", "rst_n"
//   generics:                              "C_*"
//   user defined types:                    "*_TYPE"
//   state machine next state:              "*_ns"
//   state machine current state:           "*_cs"
//   combinatorial signals:                 "*_com"
//   pipelined or register delay signals:   "*_d#"
//   counter signals:                       "*cnt*"
//   clock enable signals:                  "*_ce"
//   internal version of output port:       "*_i"
//   device pins:                           "*_pin"
//   ports:                                 "- Names begin with Uppercase"
//   processes:                             "*_PROCESS"
//   component instantiations:              "<ENTITY_>I_<#|FUNC>"
//----------------------------------------------------------------------------

`uselib lib=unisims_ver
`uselib lib=proc_common_v3_00_a

module user_logic
(
	// -- ADD USER PORTS BELOW THIS LINE ---------------
	HSync,
	VSync,
	PClk,
	VDE,
	RGB,
	Frets,
	Strum,
	Whammy,
	Tilt,
	LEDs,
	// -- ADD USER PORTS ABOVE THIS LINE ---------------

	// -- DO NOT EDIT BELOW THIS LINE ------------------
	// -- Bus protocol ports, do not add to or delete 
	Bus2IP_Clk,                     // Bus to IP clock
	Bus2IP_Resetn,                  // Bus to IP reset
	Bus2IP_Data,                    // Bus to IP data bus
	Bus2IP_BE,                      // Bus to IP byte enables
	Bus2IP_RdCE,                    // Bus to IP read chip enable
	Bus2IP_WrCE,                    // Bus to IP write chip enable
	IP2Bus_Data,                    // IP to Bus data bus
	IP2Bus_RdAck,                   // IP to Bus read transfer acknowledgement
	IP2Bus_WrAck,                   // IP to Bus write transfer acknowledgement
	IP2Bus_Error                    // IP to Bus error response
  // -- DO NOT EDIT ABOVE THIS LINE ------------------
); // user_logic

// -- ADD USER PARAMETERS BELOW THIS LINE ------------
// --USER parameters added here 
// -- ADD USER PARAMETERS ABOVE THIS LINE ------------

// -- DO NOT EDIT BELOW THIS LINE --------------------
// -- Bus protocol parameters, do not add to or delete
parameter C_NUM_REG                      = 2;
parameter C_SLV_DWIDTH                   = 32;
// -- DO NOT EDIT ABOVE THIS LINE --------------------

// -- ADD USER PORTS BELOW THIS LINE -----------------
input         HSync;
input         VSync;
input         PClk;
input         VDE;
input  [23:0] RGB;
output [4:0]  Frets;
output        Strum;
output [7:0]  Whammy;
output        Tilt;
output [7:0]  LEDs;
// -- ADD USER PORTS ABOVE THIS LINE -----------------

// -- DO NOT EDIT BELOW THIS LINE --------------------
// -- Bus protocol ports, do not add to or delete
input                                     Bus2IP_Clk;
input                                     Bus2IP_Resetn;
input      [C_SLV_DWIDTH-1 : 0]           Bus2IP_Data;
input      [C_SLV_DWIDTH/8-1 : 0]         Bus2IP_BE;
input      [C_NUM_REG-1 : 0]              Bus2IP_RdCE;
input      [C_NUM_REG-1 : 0]              Bus2IP_WrCE;
output     [C_SLV_DWIDTH-1 : 0]           IP2Bus_Data;
output                                    IP2Bus_RdAck;
output                                    IP2Bus_WrAck;
output                                    IP2Bus_Error;
// -- DO NOT EDIT ABOVE THIS LINE --------------------

//----------------------------------------------------------------------------
// Implementation
//----------------------------------------------------------------------------

	// --USER nets declarations added here, as needed for user logic
	wire                                      playerEnable;
	wire                                      playerType;
	wire       [14 : 0]                       status;
	wire       [23 : 0]                       greenOn;
	wire       [23 : 0]                       greenOff;
	wire       [23 : 0]                       greenPos;
	wire       [23 : 0]                       redOn;
	wire       [23 : 0]                       redOff;
	wire       [23 : 0]                       redPos;
	wire       [23 : 0]                       yellowOn;
	wire       [23 : 0]                       yellowOff;
	wire       [23 : 0]                       yellowPos;
	wire       [23 : 0]                       blueOn;
	wire       [23 : 0]                       blueOff;
	wire       [23 : 0]                       bluePos;
	wire       [23 : 0]                       orangeOn;
	wire       [23 : 0]                       orangeOff;
	wire       [23 : 0]                       orangePos;
	wire       [ 3 : 0]                       delayValue;
	wire       [ 3 : 0]                       strumTime;
	
	wire                                      player1Enable;
	wire                                      player2Enable;
	wire       [14 : 0]                       status1;
	wire       [14 : 0]                       status2;
	wire       [ 4 : 0]                       frets1;
	wire       [ 4 : 0]                       frets2;
	wire                                      strum1;
	wire                                      strum2;
	wire       [ 7 : 0]                       whammy1;
	wire       [ 7 : 0]                       whammy2;
	wire                                      tilt1;
	wire                                      tilt2;
	wire       [ 7 : 0]                       leds1;
	wire       [ 7 : 0]                       leds2;
	
	

	// Nets for user logic slave model s/w accessible register example
	reg        [C_SLV_DWIDTH-1 : 0]           slv_reg0;
	reg        [C_SLV_DWIDTH-1 : 0]           slv_reg1;
	reg        [C_SLV_DWIDTH-1 : 0]           slv_reg2;
	reg        [C_SLV_DWIDTH-1 : 0]           slv_reg3;
	reg        [C_SLV_DWIDTH-1 : 0]           slv_reg4;
	reg        [C_SLV_DWIDTH-1 : 0]           slv_reg5;
	reg        [C_SLV_DWIDTH-1 : 0]           slv_reg6;
	reg        [C_SLV_DWIDTH-1 : 0]           slv_reg7;
	reg        [C_SLV_DWIDTH-1 : 0]           slv_reg8;
	reg        [C_SLV_DWIDTH-1 : 0]           slv_reg9;
	reg        [C_SLV_DWIDTH-1 : 0]           slv_reg10;
	reg        [C_SLV_DWIDTH-1 : 0]           slv_reg11;
	reg        [C_SLV_DWIDTH-1 : 0]           slv_reg12;
	reg        [C_SLV_DWIDTH-1 : 0]           slv_reg13;
	reg        [C_SLV_DWIDTH-1 : 0]           slv_reg14;
	reg        [C_SLV_DWIDTH-1 : 0]           slv_reg15;
	reg        [C_SLV_DWIDTH-1 : 0]           slv_reg16;
	wire       [C_NUM_REG-1 : 0]              slv_reg_write_sel;
	wire       [C_NUM_REG-1 : 0]              slv_reg_read_sel;
	reg        [C_SLV_DWIDTH-1 : 0]           slv_ip2bus_data;
	wire                                      slv_read_ack;
	wire                                      slv_write_ack;
	integer                                   byte_index, bit_index;

	// USER logic implementation added here

	// Register assignments
	assign
		playerEnable = slv_reg0[0],
		playerType   = slv_reg0[1],
		delayValue   = slv_reg0[6:2],
		strumTime    = slv_reg0[10:7],
		greenOn      = slv_reg2[24:0],
		greenOff     = slv_reg3[24:0],
		greenPos     = slv_reg4[24:0],
		redOn        = slv_reg5[24:0],
		redOff       = slv_reg6[24:0],
		redPos       = slv_reg7[24:0],
		yellowOn     = slv_reg8[24:0],
		yellowOff    = slv_reg9[24:0],
		yellowPos    = slv_reg10[24:0],
		blueOn       = slv_reg11[24:0],
		blueOff      = slv_reg12[24:0],
		bluePos      = slv_reg13[24:0],
		orangeOn     = slv_reg14[24:0],
		orangeOff    = slv_reg15[24:0],
		orangePos    = slv_reg16[24:0];
		
	// Player enable assignments
	assign
		player1Enable = playerType ? 1'b0 : playerEnable,
		player2Enable = playerType ? playerEnable : 1'b0;
	
	// Player output assignments
	assign
		Frets  = playerType ? frets2  : frets1,
		Strum  = playerType ? strum2  : strum1,
		Whammy = playerType ? whammy2 : whammy1,
		Tilt   = playerType ? tilt2   : tilt1,
		LEDs   = playerType ? leds2   : leds1,
		status = playerType ? status2 : status1;
		

	// ------------------------------------------------------
	// Example code to read/write user logic slave model s/w accessible registers
	// 
	// Note:
	// The example code presented here is to show you one way of reading/writing
	// software accessible registers implemented in the user logic slave model.
	// Each bit of the Bus2IP_WrCE/Bus2IP_RdCE signals is configured to correspond
	// to one software accessible register by the top level template. For example,
	// if you have four 32 bit software accessible registers in the user logic,
	// you are basically operating on the following memory mapped registers:
	// 
	//    Bus2IP_WrCE/Bus2IP_RdCE   Memory Mapped Register
	//                     "1000"   C_BASEADDR + 0x0
	//                     "0100"   C_BASEADDR + 0x4
	//                     "0010"   C_BASEADDR + 0x8
	//                     "0001"   C_BASEADDR + 0xC
	// 
	// ------------------------------------------------------

	assign
		slv_reg_write_sel = Bus2IP_WrCE,
		slv_reg_read_sel  = Bus2IP_RdCE,
		slv_write_ack     = (Bus2IP_WrCE == 0) ? 1'b0 : 1'b1,
		slv_read_ack      = (Bus2IP_RdCE == 0) ? 1'b0 : 1'b1;

	// implement slave model register(s)
	always @( posedge Bus2IP_Clk )
		begin

			if ( Bus2IP_Resetn == 1'b0 )
				begin
					slv_reg0  <= 32'b000000000000000000000_0100_00101_0_0; // Strum time 4, Delay value 5, Old type, Output off
					slv_reg1  <= 32'b0;
					slv_reg2  <= 32'h00_055907;  // Green
					slv_reg3  <= 32'h00_28590A;
					slv_reg4  <= 32'h00_259_1D6;
					slv_reg5  <= 32'h00_682123;  // Red
					slv_reg6  <= 32'h00_470C1E;
					slv_reg7  <= 32'h00_255_22C;
					slv_reg8  <= 32'h00_7C6D0F;  // Yellow
					slv_reg9  <= 32'h00_7A6D11;
					slv_reg10 <= 32'h00_253_280;
					slv_reg11 <= 32'h00_113399;  // Blue
					slv_reg12 <= 32'h00_2D3066;
					slv_reg13 <= 32'h00_255_2D4;
					slv_reg14 <= 32'h00_7F3A0F;  // Orange
					slv_reg15 <= 32'h00_7A3D07;
					slv_reg16 <= 32'h00_259_32A;
				end
			else
				case ( slv_reg_write_sel )
					17'b10000000000000000 :
						for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
							if ( Bus2IP_BE[byte_index] == 1 )
								slv_reg0[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
					17'b01000000000000000 :
						for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
							if ( Bus2IP_BE[byte_index] == 1 )
								slv_reg1[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
					17'b00100000000000000 :
						for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
							if ( Bus2IP_BE[byte_index] == 1 )
								slv_reg2[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
					17'b00010000000000000 :
						for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
							if ( Bus2IP_BE[byte_index] == 1 )
								slv_reg3[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
					17'b00001000000000000 :
						for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
							if ( Bus2IP_BE[byte_index] == 1 )
								slv_reg4[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
					17'b00000100000000000 :
						for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
							if ( Bus2IP_BE[byte_index] == 1 )
								slv_reg5[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
					17'b00000010000000000 :
						for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
							if ( Bus2IP_BE[byte_index] == 1 )
								slv_reg6[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
					17'b00000001000000000 :
						for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
							if ( Bus2IP_BE[byte_index] == 1 )
								slv_reg7[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
					17'b00000000100000000 :
						for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
							if ( Bus2IP_BE[byte_index] == 1 )
								slv_reg8[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
					17'b00000000010000000 :
						for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
							if ( Bus2IP_BE[byte_index] == 1 )
								slv_reg9[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
					17'b00000000001000000 :
						for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
							if ( Bus2IP_BE[byte_index] == 1 )
								slv_reg10[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
					17'b00000000000100000 :
						for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
							if ( Bus2IP_BE[byte_index] == 1 )
								slv_reg11[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
					17'b00000000000010000 :
						for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
							if ( Bus2IP_BE[byte_index] == 1 )
								slv_reg12[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
					17'b00000000000001000 :
						for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
							if ( Bus2IP_BE[byte_index] == 1 )
								slv_reg13[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
					17'b00000000000000100 :
						for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
							if ( Bus2IP_BE[byte_index] == 1 )
								slv_reg14[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
					17'b00000000000000010 :
						for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
							if ( Bus2IP_BE[byte_index] == 1 )
								slv_reg15[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
					17'b00000000000000001 :
						for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
							if ( Bus2IP_BE[byte_index] == 1 )
								slv_reg16[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
					default : begin
						slv_reg0 <= slv_reg0;
						slv_reg1 <= {17'b0, status};
						slv_reg2 <= slv_reg2;
						slv_reg3 <= slv_reg3;
						slv_reg4 <= slv_reg4;
						slv_reg5 <= slv_reg5;
						slv_reg6 <= slv_reg6;
						slv_reg7 <= slv_reg7;
						slv_reg8 <= slv_reg8;
						slv_reg9 <= slv_reg9;
						slv_reg10 <= slv_reg10;
						slv_reg11 <= slv_reg11;
						slv_reg12 <= slv_reg12;
						slv_reg13 <= slv_reg13;
						slv_reg14 <= slv_reg14;
						slv_reg15 <= slv_reg15;
						slv_reg16 <= slv_reg16;
					end
				endcase

		end // SLAVE_REG_WRITE_PROC

	// implement slave model register read mux
	always @( slv_reg_read_sel or slv_reg0 or slv_reg1 or slv_reg2 or slv_reg3 or slv_reg4 or slv_reg5 or slv_reg6
	                           or slv_reg7 or slv_reg8 or slv_reg9 or slv_reg10 or slv_reg11
	                           or slv_reg12 or slv_reg13 or slv_reg14 or slv_reg15 or slv_reg16 )
		begin 

			case ( slv_reg_read_sel )
				17'b10000000000000000 : slv_ip2bus_data <= slv_reg0;
				17'b01000000000000000 : slv_ip2bus_data <= {9'b0, status};
				17'b00100000000000000 : slv_ip2bus_data <= slv_reg2;
				17'b00010000000000000 : slv_ip2bus_data <= slv_reg3;
				17'b00001000000000000 : slv_ip2bus_data <= slv_reg4;
				17'b00000100000000000 : slv_ip2bus_data <= slv_reg5;
				17'b00000010000000000 : slv_ip2bus_data <= slv_reg6;
				17'b00000001000000000 : slv_ip2bus_data <= slv_reg7;
				17'b00000000100000000 : slv_ip2bus_data <= slv_reg8;
				17'b00000000010000000 : slv_ip2bus_data <= slv_reg9;
				17'b00000000001000000 : slv_ip2bus_data <= slv_reg10;
				17'b00000000000100000 : slv_ip2bus_data <= slv_reg11;
				17'b00000000000010000 : slv_ip2bus_data <= slv_reg12;
				17'b00000000000001000 : slv_ip2bus_data <= slv_reg13;
				17'b00000000000000100 : slv_ip2bus_data <= slv_reg14;
				17'b00000000000000010 : slv_ip2bus_data <= slv_reg15;
				17'b00000000000000001 : slv_ip2bus_data <= slv_reg16;
				default : slv_ip2bus_data <= 0;
			endcase

		end // SLAVE_REG_READ_PROC

	// ------------------------------------------------------------
	// Example code to drive IP to Bus signals
	// ------------------------------------------------------------

	assign IP2Bus_Data = (slv_read_ack == 1'b1) ? slv_ip2bus_data :  0 ;
	assign IP2Bus_WrAck = slv_write_ack;
	assign IP2Bus_RdAck = slv_read_ack;
	assign IP2Bus_Error = 0;

	
	// ------------------------------------------------------------
	// Player modules
	// ------------------------------------------------------------
  
	player player_old (
		.CLK         (Bus2IP_Clk),
		.RST         (Bus2IP_Resetn),
		.Enable      (player1Enable),
		.HSync       (HSync),
		.VSync       (VSync),
		.PClk        (PClk),
		.VDE         (VDE),
		.RGB         (RGB),
		.GreenOn     (greenOn),
		.GreenOff    (greenOff),
		.GreenPos    (greenPos),
		.RedOn       (redOn),
		.RedOff      (redOff),
		.RedPos      (redPos),
		.YellowOn    (yellowOn),
		.YellowOff   (yellowOff),
		.YellowPos   (yellowPos),
		.BlueOn      (blueOn),
		.BlueOff     (blueOff),
		.BluePos     (bluePos),
		.OrangeOn    (orangeOn),
		.OrangeOff   (orangeOff),
		.OrangePos   (orangePos),
		.DelayValue  (delayValue),
		.StrumTime   (strumTime),
		
		.Frets       (frets1),
		.Strum       (strum1),
		.Whammy      (whammy1),
		.Tilt        (tilt1),
		.LEDs        (leds1),
		.Status      (status1)
	);
	
	player_filtered player_new (
		.CLK         (Bus2IP_Clk),
		.RST         (Bus2IP_Resetn),
		.Enable      (player2Enable),
		.HSync       (HSync),
		.VSync       (VSync),
		.PClk        (PClk),
		.VDE         (VDE),
		.Pixel       (RGB[0]),
		.GreenPos    (greenPos),
		.RedPos      (redPos),
		.YellowPos   (yellowPos),
		.BluePos     (bluePos),
		.OrangePos   (orangePos),
		.StrumTime   (strumTime),
		
		.Frets       (frets2),
		.Strum       (strum2),
		.Whammy      (whammy2),
		.Tilt        (tilt2),
		.LEDs        (leds2),
		.Status      (status2)
	);
  
endmodule
