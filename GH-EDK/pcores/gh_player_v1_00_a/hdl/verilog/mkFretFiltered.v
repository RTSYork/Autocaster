//
// Generated by Bluespec Compiler, version 2012.01.A (build 26572, 2012-01-17)
//
// On Wed Apr 17 11:30:47 BST 2013
//
// Method conflict info:
// Method: vsync
// Conflict-free: hsync, vde, pixel, xPos, yPos, press
// Conflicts: vsync
//
// Method: hsync
// Conflict-free: vsync, vde, pixel, xPos, yPos, press
// Conflicts: hsync
//
// Method: vde
// Conflict-free: vsync, hsync, pixel, xPos, yPos, press
// Conflicts: vde
//
// Method: pixel
// Conflict-free: vsync, hsync, vde, xPos, yPos, press
// Conflicts: pixel
//
// Method: xPos
// Conflict-free: vsync, hsync, vde, pixel, yPos, press
// Conflicts: xPos
//
// Method: yPos
// Conflict-free: vsync, hsync, vde, pixel, xPos, press
// Conflicts: yPos
//
// Method: press
// Conflict-free: vsync, hsync, vde, pixel, xPos, yPos, press
//
//
// Ports:
// Name                         I/O  size props
// press                          O     1 reg
// CLK                            I     1 clock
// RST_N                          I     1 reset
// pixel_in                       I     1 reg
// xPos_in                        I    11
// yPos_in                        I    10
// vsync                          I     1
// hsync                          I     1
// vde                            I     1
//
// No combinational paths from inputs to outputs
//
//

`ifdef BSV_ASSIGNMENT_DELAY
`else
`define BSV_ASSIGNMENT_DELAY
`endif

module mkFretFiltered(CLK,
		      RST_N,

		      vsync,

		      hsync,

		      vde,

		      pixel_in,

		      xPos_in,

		      yPos_in,

		      press);
  input  CLK;
  input  RST_N;

  // action method vsync
  input  vsync;

  // action method hsync
  input  hsync;

  // action method vde
  input  vde;

  // action method pixel
  input  pixel_in;

  // action method xPos
  input  [10 : 0] xPos_in;

  // action method yPos
  input  [9 : 0] yPos_in;

  // value method press
  output press;

  // signals for module outputs
  wire press;

  // register fretPressed
  reg fretPressed;
  wire fretPressed$D_IN, fretPressed$EN;

  // register fretValues
  reg fretValues;
  wire fretValues$D_IN, fretValues$EN;

  // register fretValues_1
  reg fretValues_1;
  wire fretValues_1$D_IN, fretValues_1$EN;

  // register fretValues_2
  reg fretValues_2;
  wire fretValues_2$D_IN, fretValues_2$EN;

  // register fretValues_3
  reg fretValues_3;
  wire fretValues_3$D_IN, fretValues_3$EN;

  // register fretValues_4
  reg fretValues_4;
  wire fretValues_4$D_IN, fretValues_4$EN;

  // register fretValues_5
  reg fretValues_5;
  wire fretValues_5$D_IN, fretValues_5$EN;

  // register fretValues_6
  reg fretValues_6;
  wire fretValues_6$D_IN, fretValues_6$EN;

  // register fretValues_7
  reg fretValues_7;
  wire fretValues_7$D_IN, fretValues_7$EN;

  // register x
  reg [10 : 0] x;
  wire [10 : 0] x$D_IN;
  wire x$EN;

  // register y
  reg [9 : 0] y;
  wire [9 : 0] y$D_IN;
  wire y$EN;

  // rule scheduling signals
  wire WILL_FIRE_RL_new_line, WILL_FIRE_RL_new_pixel;

  // inputs to muxes for submodule ports
  wire [10 : 0] MUX_x$write_1__VAL_1;
  wire [9 : 0] MUX_y$write_1__VAL_1;
  wire MUX_x$write_1__SEL_2;

  // remaining internal signals
  wire fretValues_OR_fretValues_1_OR_fretValues_2_OR__ETC___d14,
       x_0_EQ_xPosition_wget__6_7_AND_y_4_EQ_yPositio_ETC___d47,
       x_0_EQ_xPosition_wget__6_7_AND_y_4_EQ_yPositio_ETC___d52,
       x_0_EQ_xPosition_wget__6_7_AND_y_4_EQ_yPositio_ETC___d57,
       x_0_EQ_xPosition_wget__6_7_AND_y_4_EQ_yPositio_ETC___d62,
       x_0_EQ_xPosition_wget__6_7_AND_y_4_EQ_yPositio_ETC___d67,
       x_0_EQ_xPosition_wget__6_7_AND_y_4_EQ_yPositio_ETC___d72,
       x_0_EQ_xPosition_wget__6_7_AND_y_4_EQ_yPositio_ETC___d77,
       x_0_EQ_xPosition_wget__6___d37;

  // value method press
  assign press = fretPressed ;

  // rule RL_new_line
  assign WILL_FIRE_RL_new_line = hsync && !vsync && x != 11'd0 ;

  // rule RL_new_pixel
  assign WILL_FIRE_RL_new_pixel = vde && !hsync && !vsync ;

  // inputs to muxes for submodule ports
  assign MUX_x$write_1__SEL_2 = WILL_FIRE_RL_new_line || vsync ;
  assign MUX_x$write_1__VAL_1 = x + 11'd1 ;
  assign MUX_y$write_1__VAL_1 = y + 10'd1 ;

  // register fretPressed
  assign fretPressed$D_IN =
	     fretValues_OR_fretValues_1_OR_fretValues_2_OR__ETC___d14 ||
	     fretValues_7 ;
  assign fretPressed$EN = vsync ;

  // register fretValues
  assign fretValues$D_IN = pixel_in ;
  assign fretValues$EN =
	     x_0_EQ_xPosition_wget__6___d37 && y == yPos_in && !vsync ;

  // register fretValues_1
  assign fretValues_1$D_IN = pixel_in ;
  assign fretValues_1$EN =
	     x_0_EQ_xPosition_wget__6_7_AND_y_4_EQ_yPositio_ETC___d47 ;

  // register fretValues_2
  assign fretValues_2$D_IN = pixel_in ;
  assign fretValues_2$EN =
	     x_0_EQ_xPosition_wget__6_7_AND_y_4_EQ_yPositio_ETC___d52 ;

  // register fretValues_3
  assign fretValues_3$D_IN = pixel_in ;
  assign fretValues_3$EN =
	     x_0_EQ_xPosition_wget__6_7_AND_y_4_EQ_yPositio_ETC___d57 ;

  // register fretValues_4
  assign fretValues_4$D_IN = pixel_in ;
  assign fretValues_4$EN =
	     x_0_EQ_xPosition_wget__6_7_AND_y_4_EQ_yPositio_ETC___d62 ;

  // register fretValues_5
  assign fretValues_5$D_IN = pixel_in ;
  assign fretValues_5$EN =
	     x_0_EQ_xPosition_wget__6_7_AND_y_4_EQ_yPositio_ETC___d67 ;

  // register fretValues_6
  assign fretValues_6$D_IN = pixel_in ;
  assign fretValues_6$EN =
	     x_0_EQ_xPosition_wget__6_7_AND_y_4_EQ_yPositio_ETC___d72 ;

  // register fretValues_7
  assign fretValues_7$D_IN = pixel_in ;
  assign fretValues_7$EN =
	     x_0_EQ_xPosition_wget__6_7_AND_y_4_EQ_yPositio_ETC___d77 ;

  // register x
  assign x$D_IN = WILL_FIRE_RL_new_pixel ? MUX_x$write_1__VAL_1 : 11'd0 ;
  assign x$EN = WILL_FIRE_RL_new_pixel || WILL_FIRE_RL_new_line || vsync ;

  // register y
  assign y$D_IN = WILL_FIRE_RL_new_line ? MUX_y$write_1__VAL_1 : 10'd0 ;
  assign y$EN = MUX_x$write_1__SEL_2 ;

  // remaining internal signals
  assign fretValues_OR_fretValues_1_OR_fretValues_2_OR__ETC___d14 =
	     fretValues || fretValues_1 || fretValues_2 || fretValues_3 ||
	     fretValues_4 ||
	     fretValues_5 ||
	     fretValues_6 ;
  assign x_0_EQ_xPosition_wget__6_7_AND_y_4_EQ_yPositio_ETC___d47 =
	     x_0_EQ_xPosition_wget__6___d37 && y == yPos_in + 10'd1 &&
	     !vsync ;
  assign x_0_EQ_xPosition_wget__6_7_AND_y_4_EQ_yPositio_ETC___d52 =
	     x_0_EQ_xPosition_wget__6___d37 && y == yPos_in + 10'd2 &&
	     !vsync ;
  assign x_0_EQ_xPosition_wget__6_7_AND_y_4_EQ_yPositio_ETC___d57 =
	     x_0_EQ_xPosition_wget__6___d37 && y == yPos_in + 10'd3 &&
	     !vsync ;
  assign x_0_EQ_xPosition_wget__6_7_AND_y_4_EQ_yPositio_ETC___d62 =
	     x_0_EQ_xPosition_wget__6___d37 && y == yPos_in + 10'd4 &&
	     !vsync ;
  assign x_0_EQ_xPosition_wget__6_7_AND_y_4_EQ_yPositio_ETC___d67 =
	     x_0_EQ_xPosition_wget__6___d37 && y == yPos_in + 10'd5 &&
	     !vsync ;
  assign x_0_EQ_xPosition_wget__6_7_AND_y_4_EQ_yPositio_ETC___d72 =
	     x_0_EQ_xPosition_wget__6___d37 && y == yPos_in + 10'd6 &&
	     !vsync ;
  assign x_0_EQ_xPosition_wget__6_7_AND_y_4_EQ_yPositio_ETC___d77 =
	     x_0_EQ_xPosition_wget__6___d37 && y == yPos_in + 10'd7 &&
	     !vsync ;
  assign x_0_EQ_xPosition_wget__6___d37 = x == xPos_in ;

  // handling of inlined registers

  always@(posedge CLK)
  begin
    if (!RST_N)
      begin
        fretPressed <= `BSV_ASSIGNMENT_DELAY 1'd0;
	fretValues <= `BSV_ASSIGNMENT_DELAY 1'd0;
	fretValues_1 <= `BSV_ASSIGNMENT_DELAY 1'd0;
	fretValues_2 <= `BSV_ASSIGNMENT_DELAY 1'd0;
	fretValues_3 <= `BSV_ASSIGNMENT_DELAY 1'd0;
	fretValues_4 <= `BSV_ASSIGNMENT_DELAY 1'd0;
	fretValues_5 <= `BSV_ASSIGNMENT_DELAY 1'd0;
	fretValues_6 <= `BSV_ASSIGNMENT_DELAY 1'd0;
	fretValues_7 <= `BSV_ASSIGNMENT_DELAY 1'd0;
	x <= `BSV_ASSIGNMENT_DELAY 11'd0;
	y <= `BSV_ASSIGNMENT_DELAY 10'd0;
      end
    else
      begin
        if (fretPressed$EN)
	  fretPressed <= `BSV_ASSIGNMENT_DELAY fretPressed$D_IN;
	if (fretValues$EN)
	  fretValues <= `BSV_ASSIGNMENT_DELAY fretValues$D_IN;
	if (fretValues_1$EN)
	  fretValues_1 <= `BSV_ASSIGNMENT_DELAY fretValues_1$D_IN;
	if (fretValues_2$EN)
	  fretValues_2 <= `BSV_ASSIGNMENT_DELAY fretValues_2$D_IN;
	if (fretValues_3$EN)
	  fretValues_3 <= `BSV_ASSIGNMENT_DELAY fretValues_3$D_IN;
	if (fretValues_4$EN)
	  fretValues_4 <= `BSV_ASSIGNMENT_DELAY fretValues_4$D_IN;
	if (fretValues_5$EN)
	  fretValues_5 <= `BSV_ASSIGNMENT_DELAY fretValues_5$D_IN;
	if (fretValues_6$EN)
	  fretValues_6 <= `BSV_ASSIGNMENT_DELAY fretValues_6$D_IN;
	if (fretValues_7$EN)
	  fretValues_7 <= `BSV_ASSIGNMENT_DELAY fretValues_7$D_IN;
	if (x$EN) x <= `BSV_ASSIGNMENT_DELAY x$D_IN;
	if (y$EN) y <= `BSV_ASSIGNMENT_DELAY y$D_IN;
      end
  end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    fretPressed = 1'h0;
    fretValues = 1'h0;
    fretValues_1 = 1'h0;
    fretValues_2 = 1'h0;
    fretValues_3 = 1'h0;
    fretValues_4 = 1'h0;
    fretValues_5 = 1'h0;
    fretValues_6 = 1'h0;
    fretValues_7 = 1'h0;
    x = 11'h2AA;
    y = 10'h2AA;
  end
  `endif // BSV_NO_INITIAL_BLOCKS
  // synopsys translate_on
endmodule  // mkFretFiltered

