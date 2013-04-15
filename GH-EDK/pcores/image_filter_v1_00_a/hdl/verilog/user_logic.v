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
// Date:              Fri Mar 22 15:42:49 2013 (by Create and Import Peripheral Wizard)
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
	ACLK,
	RGB_OUT,
	
	// AXI4-Stream Read Channel
	S_AXIS_S2MM_ACLK,
	S_AXIS_S2MM_ARESETN,
	S_AXIS_S2MM_TREADY,
	S_AXIS_S2MM_TDATA,
	S_AXIS_S2MM_TKEEP,
	S_AXIS_S2MM_TLAST,
	S_AXIS_S2MM_TVALID,
	
	// AXI4-Stream Write Channel
	M_AXIS_S2MM_ACLK,
	M_AXIS_S2MM_ARESETN,
	M_AXIS_S2MM_TVALID,
	M_AXIS_S2MM_TDATA,
	M_AXIS_S2MM_TKEEP,
	M_AXIS_S2MM_TLAST,
	M_AXIS_S2MM_TREADY,
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
// AXI4-Stream parameter
parameter C_AXI_STREAM_DATA_WIDTH        = 32;
// -- ADD USER PARAMETERS ABOVE THIS LINE ------------

// -- DO NOT EDIT BELOW THIS LINE --------------------
// -- Bus protocol parameters, do not add to or delete
parameter C_NUM_REG                      = 2;
parameter C_SLV_DWIDTH                   = 32;
// -- DO NOT EDIT ABOVE THIS LINE --------------------

// -- ADD USER PORTS BELOW THIS LINE -----------------
input                                     ACLK;
output  [23 : 0]                          RGB_OUT;

// AXI4-Stream Read Channel
output                                    S_AXIS_S2MM_ACLK;
input                                     S_AXIS_S2MM_ARESETN;
output                                    S_AXIS_S2MM_TREADY;
input   [C_AXI_STREAM_DATA_WIDTH-1 : 0]   S_AXIS_S2MM_TDATA;
input   [C_AXI_STREAM_DATA_WIDTH/8-1 : 0] S_AXIS_S2MM_TKEEP;
input                                     S_AXIS_S2MM_TLAST;
input                                     S_AXIS_S2MM_TVALID;
    
// AXI4-Stream Write Channel
output                                    M_AXIS_S2MM_ACLK;
input                                     M_AXIS_S2MM_ARESETN;
output                                    M_AXIS_S2MM_TVALID;
output  [C_AXI_STREAM_DATA_WIDTH-1 : 0]   M_AXIS_S2MM_TDATA;
output  [C_AXI_STREAM_DATA_WIDTH/8-1 : 0] M_AXIS_S2MM_TKEEP;
output                                    M_AXIS_S2MM_TLAST;
input                                     M_AXIS_S2MM_TREADY;
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
	wire       [23 : 0]                       rgbIn;
	wire                                      procOut;
	wire       [23 : 0]                       dispOut;
	wire                                      enable;
	wire       [ 5 : 0]                       filterDisplay;
	wire       [ 8 : 0]                       threshold;
	
	reg                                       valid, valid2;
	reg     [C_AXI_STREAM_DATA_WIDTH/8-1 : 0] keep, keep2;
	reg                                       last, last2;
	reg                                       ready, ready2;

	// Nets for user logic slave model s/w accessible register example
	reg        [C_SLV_DWIDTH-1 : 0]           slv_reg0;
	reg        [C_SLV_DWIDTH-1 : 0]           slv_reg1;
	wire       [1 : 0]                        slv_reg_write_sel;
	wire       [1 : 0]                        slv_reg_read_sel;
	reg        [C_SLV_DWIDTH-1 : 0]           slv_ip2bus_data;
	wire                                      slv_read_ack;
	wire                                      slv_write_ack;
	integer                                   byte_index, bit_index;

	// USER logic implementation added here
  
	// Registers
	assign
		enable        = slv_reg0[0],
		filterDisplay = slv_reg0[6:1],
		threshold     = slv_reg1[7:0];
  
	// Data inputs
	assign
		rgbIn = S_AXIS_S2MM_TDATA[23:0];
	
	// Data outputs
	assign
		M_AXIS_S2MM_TDATA = enable ? {8'b0, dispOut} : S_AXIS_S2MM_TDATA,
		RGB_OUT           = enable ? {24{procOut}} : rgbIn;
	
		
	// Tie together unmodified lines of AXIS bus
	assign
		M_AXIS_S2MM_TVALID = 0 ? valid2 : S_AXIS_S2MM_TVALID,
		M_AXIS_S2MM_TKEEP  = 0 ? keep2  : S_AXIS_S2MM_TKEEP,
		M_AXIS_S2MM_TLAST  = 0 ? last2  : S_AXIS_S2MM_TLAST,
		S_AXIS_S2MM_TREADY = 0 ? ready2 : M_AXIS_S2MM_TREADY;
	
	// Delay AXIS signals through some resisters
	always @(posedge ACLK)
		begin
			valid2  <= S_AXIS_S2MM_TVALID;
			keep2   <= S_AXIS_S2MM_TKEEP;
			last2   <= S_AXIS_S2MM_TLAST;
			ready2  <= M_AXIS_S2MM_TREADY;
			
			//valid2 <= valid;
			//keep2  <= keep;
			//last2  <= last;
			//ready2 <= ready;
		end
  
	// AXIS clock outputs
	assign
		M_AXIS_S2MM_ACLK = ACLK,
		S_AXIS_S2MM_ACLK = ACLK;
	
	

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
		slv_reg_write_sel = Bus2IP_WrCE[1:0],
		slv_reg_read_sel  = Bus2IP_RdCE[1:0],
		slv_write_ack     = Bus2IP_WrCE[0] || Bus2IP_WrCE[1],
		slv_read_ack      = Bus2IP_RdCE[0] || Bus2IP_RdCE[1];

	// implement slave model register(s)
	always @( posedge Bus2IP_Clk )
		begin

			if ( Bus2IP_Resetn == 1'b0 )
				begin
					slv_reg0 <= 0;
					slv_reg1 <= 32'd200;
				end
			else
				case ( slv_reg_write_sel )
					2'b10 :
						for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
							if ( Bus2IP_BE[byte_index] == 1 )
								slv_reg0[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
					2'b01 :
						for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
							if ( Bus2IP_BE[byte_index] == 1 )
								slv_reg1[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
					default : begin
						slv_reg0 <= slv_reg0;
						slv_reg1 <= slv_reg1;
					end
				endcase

		end // SLAVE_REG_WRITE_PROC

	// implement slave model register read mux
	always @( slv_reg_read_sel or slv_reg0 or slv_reg1 )
		begin 

			case ( slv_reg_read_sel )
				2'b10 : slv_ip2bus_data <= slv_reg0;
				2'b01 : slv_ip2bus_data <= slv_reg1;
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
	// Filters module - Pass image through filters
	// ------------------------------------------------------------

	filters Filters (
		.CLK          (ACLK),
		.RST          (Bus2IP_Resetn),
		.HSync        (S_AXIS_S2MM_TLAST),
		.VDE          (S_AXIS_S2MM_TVALID),
		.Display      (filterDisplay),
		.RGBin        (rgbIn),
		.Threshold    (threshold),
		
		.ProcessOut   (procOut),
		.DisplayOut   (dispOut)
	);

endmodule
