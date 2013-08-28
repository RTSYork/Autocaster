/******************************************************************************
*
* (c) Copyright 2012 Xilinx, Inc. All rights reserved.
*
* This file contains confidential and proprietary information of Xilinx, Inc.
* and is protected under U.S. and international copyright and other
* intellectual property laws.
*
* DISCLAIMER
* This disclaimer is not a license and does not grant any rights to the
* materials distributed herewith. Except as otherwise provided in a valid
* license issued to you by Xilinx, and to the maximum extent permitted by
* applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL
* FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS,
* IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
* MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE;
* and (2) Xilinx shall not be liable (whether in contract or tort, including
* negligence, or under any other theory of liability) for any loss or damage
* of any kind or nature related to, arising under or in connection with these
* materials, including for any direct, or any indirect, special, incidental,
* or consequential loss or damage (including loss of data, profits, goodwill,
* or any type of loss or damage suffered as a result of any action brought by
* a third party) even if such damage or loss was reasonably foreseeable or
* Xilinx had been advised of the possibility of the same.
*
* CRITICAL APPLICATIONS
* Xilinx products are not designed or intended to be fail-safe, or for use in
* any application requiring fail-safe performance, such as life-support or
* safety devices or systems, Class III medical devices, nuclear facilities,
* applications related to the deployment of airbags, or any other applications
* that could lead to death, personal injury, or severe property or
* environmental damage (individually and collectively, "Critical
* Applications"). Customer assumes the sole risk and liability of any use of
* Xilinx products in Critical Applications, subject only to applicable laws
* and regulations governing limitations on product liability.
*
* THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE
* AT ALL TIMES.
*
******************************************************************************/
/*****************************************************************************/
/**
 *
 * @file xaxivdma_example_intr.c
 *
 * This example demonstrates how to use the AXI Video DMA with other video IPs
 * to do video frame transfers. This example does not work by itself. It needs
 * two other Video IPs, one for writing video frames to the memory and one for
 * reading video frames from the memory.
 *
 * To see the debug print, you need a Uart16550 or uartlite in your system,
 * and please set "-DDEBUG" in your compiler options. You need to rebuild your
 * software executable.
 *
 * @note
 * The values of DDR_BASE_ADDR and DDR_HIGH_ADDR should be as per the HW system.
 *
 * <pre>
 * MODIFICATION HISTORY:
 *
 * Ver   Who  Date     Changes
 * ----- ---- -------- -------------------------------------------------------
 * 1.00a jz   07/26/10 First release
 * 1.01a jz   09/26/10 Updated callback function signature
 * 2.00a jz   12/10/10 Added support for direct register access mode, v3 core
 * 2.01a rvp  01/22/11 Renamed the example file to be consistent
 * 		       Added support to the example to use SCU GIC interrupt
 *		       controller for ARM, some functions in this example have
 *		       changed.
 *       rkv  03/28/11 Updated to support for frame store register.
 * 3.00a srt  08/26/11 Added support for Flush on Frame Sync Feature.
 * 4.00a srt  03/06/12 Modified interrupt support for Zynq.
 *
 * </pre>
 *
 * ***************************************************************************
 */
#include <stdio.h>

#include "xaxivdma.h"
#include "xparameters.h"
#include "xil_exception.h"

#include "xintc.h"

#include "vdma.h"

#include "xuartlite.h"
#include "xuartlite_l.h"

#include "../ethernet.h"

/******************** Constant Definitions **********************************/

/*
 * Device related constants. These need to defined as per the HW system.
 */
#define DMA_DEVICE_ID		XPAR_AXIVDMA_0_DEVICE_ID

#define INTC_DEVICE_ID		XPAR_INTC_0_DEVICE_ID
#define WRITE_INTR_ID		XPAR_INTC_0_AXIVDMA_0_S2MM_INTROUT_VEC_ID
#define READ_INTR_ID		XPAR_INTC_0_AXIVDMA_0_MM2S_INTROUT_VEC_ID

#define DDR_BASE_ADDR		XPAR_S6DDR_0_S0_AXI_BASEADDR
#define DDR_HIGH_ADDR		XPAR_S6DDR_0_S0_AXI_HIGHADDR

/* Memory space for the frame buffers
 *
 * This example only needs one set of frame buffers, because one video IP is
 * to write to the frame buffers, and the other video IP is to read from the
 * frame buffers.
 *
 * For 16 frames of 1080p, it needs 0x07E90000 memory for frame buffers
 */
#define MEM_BASE_ADDR		(DDR_BASE_ADDR + 0x01000000)
#define MEM_HIGH_ADDR		DDR_HIGH_ADDR
#define MEM_SPACE		(MEM_HIGH_ADDR - MEM_BASE_ADDR)

/* Read channel and write channel start from the same place
 *
 * One video IP write to the memory region, the other video IP read from it
 */
#define READ_ADDRESS_BASE	MEM_BASE_ADDR
#define WRITE_ADDRESS_BASE	MEM_BASE_ADDR

/* Frame size related constants
 */
#define FRAME_HORIZONTAL_LEN  1280   /* 1280 pixels, each pixel 4 bytes */
#define FRAME_VERTICAL_LEN    720    /* 720 pixels */

/* Number of frames to work on, this is to set the frame count threshold
 *
 * We multiply 15 to the num stores is to increase the intervals between
 * interrupts. If you are using fsync, then it is not necessary.
 */
#define NUMBER_OF_READ_FRAMES	2
#define NUMBER_OF_WRITE_FRAMES	2

/* Number of frames to transfer
 *
 * This is used to monitor the progress of the test, test purpose only
 */
#define NUM_TEST_FRAME_SETS	10

/* Delay timer counter
 *
 * WARNING: If you are using fsync, please increase the delay counter value
 * to be 255. Because with fsync, the inter-frame delay is long. If you do not
 * care about inactivity of the hardware, set this counter to be 0, which
 * disables delay interrupt.
 */
#define DELAY_TIMER_COUNTER	10

/* For video buffer for UART output */
#define VBUFFER_BASE_ADDR		MEM_BASE_ADDR + (FRAME_HORIZONTAL_LEN * FRAME_VERTICAL_LEN * 4 * NUMBER_OF_READ_FRAMES)
#define LASTFRAME_START_ADDR	MEM_BASE_ADDR + (FRAME_HORIZONTAL_LEN * FRAME_VERTICAL_LEN * 4 * (NUMBER_OF_READ_FRAMES-1))
#define VBUFFER_X				420//433
#define VBUFFER_Y				320//560
#define VBUFFER_WIDTH			440//414
#define VBUFFER_HEIGHT			360//50
#define VBUFFER_FRAMES			120

#define NO_INTERRUPT_MASK 0x00
#define ETH_INTERRUPT_MASK 0x01
#define UART_INTERRUPT_MASK 0x02

#define STREAM_DELAY 0

/*
 * Device instance definitions
 */
XAxiVdma AxiVdma;

static XIntc Intc;	/* Instance of the Interrupt Controller */

/* Data address
 *
 * Read and write sub-frame use the same settings
 */
static u32 ReadFrameAddr;
static u32 WriteFrameAddr;

/* DMA channel setup
 */
static XAxiVdma_DmaSetup ReadCfg;
static XAxiVdma_DmaSetup WriteCfg;

/* Transfer statics
 */
static int ReadDone;
static int ReadError;
static int WriteDone;
static int WriteError;


static int vBufferCounter;
static int vBufferX;
static int vBufferY;
static u32 *frmptr;
static u32 *vbufptr;

static u8 interruptMask;

static u16 streamDelay;
static u8 interlaced;


/******************* Function Prototypes ************************************/



static int ReadSetup(XAxiVdma *InstancePtr);
static int WriteSetup(XAxiVdma * InstancePtr);
static int StartTransfer(XAxiVdma *InstancePtr);

static int SetupIntrSystem(XAxiVdma *AxiVdmaPtr, u16 ReadIntrId,
				u16 WriteIntrId);

static void DisableIntrSystem(u16 ReadIntrId, u16 WriteIntrId);

/* Interrupt call back functions
 */
static void ReadCallBack(void *CallbackRef, u32 Mask);
static void ReadErrorCallBack(void *CallbackRef, u32 Mask);
static void WriteCallBack(void *CallbackRef, u32 Mask);
static void WriteErrorCallBack(void *CallbackRef, u32 Mask);


/*****************************************************************************/
/**
*
* Main function
*
* This function is the main entry point of the example on DMA core. It sets up
* DMA engine to be ready to receive and send frames, and start the transfers.
* It waits for the transfer of the specified number of frame sets, and check
* for transfer errors.
*
* @return
*		- XST_SUCCESS if example finishes successfully
*		- XST_FAILURE if example fails.
*
* @note		None.
*
******************************************************************************/
int vdma_setup(XIntc controller)
{
	Intc = controller;

	int Status;
	XAxiVdma_Config *Config;
	XAxiVdma_FrameCounter FrameCfg;


	WriteDone = 0;
	ReadDone = 0;
	WriteError = 0;
	ReadError = 0;

	ReadFrameAddr = READ_ADDRESS_BASE;
	WriteFrameAddr = WRITE_ADDRESS_BASE;

	xil_printf("\r\n--- Entering vdma_setup() --- \r\n");

	/* The information of the XAxiVdma_Config comes from hardware build.
	 * The user IP should pass this information to the AXI DMA core.
	 */
	Config = XAxiVdma_LookupConfig(DMA_DEVICE_ID);
	if (!Config) {
		xil_printf(
		    "No video DMA found for ID %d\r\n", DMA_DEVICE_ID);

		return XST_FAILURE;
	}

	/* Initialize DMA engine */
	Status = XAxiVdma_CfgInitialize(&AxiVdma, Config, Config->BaseAddress);
	if (Status != XST_SUCCESS) {

		xil_printf(
		    "Configuration Initialization failed %d\r\n", Status);

		return XST_FAILURE;
	}

	Status = XAxiVdma_SetFrmStore(&AxiVdma, NUMBER_OF_READ_FRAMES,
							XAXIVDMA_READ);
	if (Status != XST_SUCCESS) {

		xil_printf(
		    "Setting Frame Store Number Failed in Read Channel"
		    					" %d\r\n", Status);

		return XST_FAILURE;
	}

	Status = XAxiVdma_SetFrmStore(&AxiVdma, NUMBER_OF_WRITE_FRAMES,
							XAXIVDMA_WRITE);
	if (Status != XST_SUCCESS) {

		xil_printf(
		    "Setting Frame Store Number Failed in Write Channel"
		    					" %d\r\n", Status);

		return XST_FAILURE;
	}

	/* Setup frame counter and delay counter for both channels
	 *
	 * This is to monitor the progress of the test only
	 *
	 * WARNING: In free-run mode, interrupts may overwhelm the system.
	 * In that case, it is better to disable interrupts.
	 */
	FrameCfg.ReadFrameCount = NUMBER_OF_READ_FRAMES;
	FrameCfg.WriteFrameCount = NUMBER_OF_WRITE_FRAMES;
	FrameCfg.ReadDelayTimerCount = DELAY_TIMER_COUNTER;
	FrameCfg.WriteDelayTimerCount = DELAY_TIMER_COUNTER;

	Status = XAxiVdma_SetFrameCounter(&AxiVdma, &FrameCfg);
	if (Status != XST_SUCCESS) {
		xil_printf(
		    	"Set frame counter failed %d\r\n", Status);

		if(Status == XST_VDMA_MISMATCH_ERROR)
			xil_printf("DMA Mismatch Error\r\n");

		return XST_FAILURE;
	}

	/*
	 * Setup your video IP that writes to the memory
	 */


	/* Setup the write channel
	 */
	Status = WriteSetup(&AxiVdma);
	if (Status != XST_SUCCESS) {
		xil_printf(
		    	"Write channel setup failed %d\r\n", Status);
		if(Status == XST_VDMA_MISMATCH_ERROR)
			xil_printf("DMA Mismatch Error\r\n");

		return XST_FAILURE;
	}


	/*
	 * Setup your video IP that reads from the memory
	 */

	/* Setup the read channel
	 */
	Status = ReadSetup(&AxiVdma);
	if (Status != XST_SUCCESS) {
		xil_printf(
		    	"Read channel setup failed %d\r\n", Status);
		if(Status == XST_VDMA_MISMATCH_ERROR)
			xil_printf("DMA Mismatch Error\r\n");

		return XST_FAILURE;
	}


	Status = SetupIntrSystem(&AxiVdma, READ_INTR_ID, WRITE_INTR_ID);
	if (Status != XST_SUCCESS) {

		xil_printf(
		    "Setup interrupt system failed %d\r\n", Status);

		return XST_FAILURE;
	}


	/* Register callback functions
	 */
//	XAxiVdma_SetCallBack(&AxiVdma, XAXIVDMA_HANDLER_GENERAL, ReadCallBack,
//	    (void *)&AxiVdma, XAXIVDMA_READ);
//
//	XAxiVdma_SetCallBack(&AxiVdma, XAXIVDMA_HANDLER_ERROR,
//	    ReadErrorCallBack, (void *)&AxiVdma, XAXIVDMA_READ);

	XAxiVdma_SetCallBack(&AxiVdma, XAXIVDMA_HANDLER_GENERAL,
	    WriteCallBack, (void *)&AxiVdma, XAXIVDMA_WRITE);

	XAxiVdma_SetCallBack(&AxiVdma, XAXIVDMA_HANDLER_ERROR,
	    WriteErrorCallBack, (void *)&AxiVdma, XAXIVDMA_WRITE);

	/* Enable your video IP interrupts if needed
	 */

	/* Start the DMA engine to transfer
	 */
	Status = StartTransfer(&AxiVdma);
	if (Status != XST_SUCCESS) {
		if(Status == XST_VDMA_MISMATCH_ERROR)
			xil_printf("DMA Mismatch Error\r\n");
		return XST_FAILURE;
	}


	/* Enable DMA read and write channel interrupts
	 *
	 * If interrupts overwhelms the system, please do not enable interrupt
	 */
//	XAxiVdma_IntrEnable(&AxiVdma, XAXIVDMA_IXR_FRMCNT_MASK, XAXIVDMA_WRITE);
//	XAxiVdma_IntrEnable(&AxiVdma, XAXIVDMA_IXR_FRMCNT_MASK, XAXIVDMA_READ);



	/* Every set of frame buffer finish causes a completion interrupt
	 */
//	while ((WriteDone < NUM_TEST_FRAME_SETS) && !ReadError &&
//	      (ReadDone < NUM_TEST_FRAME_SETS) && !WriteError) {
// 		/* NOP */
//	}


//	if (ReadError || WriteError) {
//		xil_printf("Test has transfer error %d/%d\r\n",
//		    ReadError, WriteError);
//
//		Status = XST_FAILURE;
//	}
//	else {
//		xil_printf("Test passed\r\n");
//	}

	xil_printf("\r\n--- Exiting vdma_setup() --- \r\n");

//	DisableIntrSystem(READ_INTR_ID, WRITE_INTR_ID);

	if (Status != XST_SUCCESS) {
		if(Status == XST_VDMA_MISMATCH_ERROR)
			xil_printf("DMA Mismatch Error\r\n");
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}


/*****************************************************************************/
/**
*
* This function sets up the read channel
*
* @param	InstancePtr is the instance pointer to the DMA engine.
*
* @return	XST_SUCCESS if the setup is successful, XST_FAILURE otherwise.
*
* @note		None.
*
******************************************************************************/
static int ReadSetup(XAxiVdma *InstancePtr)
{
	xil_printf("\r\nRead setup...");
	int Index;
	u32 Addr;
	int Status;

	ReadCfg.VertSizeInput = FRAME_VERTICAL_LEN;
	ReadCfg.HoriSizeInput = FRAME_HORIZONTAL_LEN * sizeof(u32);

	ReadCfg.Stride = FRAME_HORIZONTAL_LEN * sizeof(u32);
	ReadCfg.FrameDelay = 0;  /* This example does not test frame delay */

	ReadCfg.EnableCircularBuf = 1;
	ReadCfg.EnableSync = 0;  /* No Gen-Lock */

	ReadCfg.PointNum = 0;    /* No Gen-Lock */
	ReadCfg.EnableFrameCounter = 0; /* Endless transfers */

	ReadCfg.FixedFrameStoreAddr = 0; /* We are not doing parking */

	Status = XAxiVdma_DmaConfig(InstancePtr, XAXIVDMA_READ, &ReadCfg);
	if (Status != XST_SUCCESS) {
		xil_printf(
		    "Read channel config failed %d\r\n", Status);

		return XST_FAILURE;
	}

	/* Initialize buffer addresses
	 *
	 * These addresses are physical addresses
	 */
	Addr = READ_ADDRESS_BASE;
	for(Index = 0; Index < NUMBER_OF_READ_FRAMES; Index++) {
		ReadCfg.FrameStoreStartAddr[Index] = Addr;

		Addr += FRAME_HORIZONTAL_LEN * FRAME_VERTICAL_LEN * sizeof(u32);
	}

	/* Set the buffer addresses for transfer in the DMA engine
	 * The buffer addresses are physical addresses
	 */
	Status = XAxiVdma_DmaSetBufferAddr(InstancePtr, XAXIVDMA_READ,
			ReadCfg.FrameStoreStartAddr);
	if (Status != XST_SUCCESS) {
		xil_printf(
		    "Read channel set buffer address failed %d\r\n", Status);

		return XST_FAILURE;
	}

	xil_printf("done");
	return XST_SUCCESS;
}

/*****************************************************************************/
/**
*
* This function sets up the write channel
*
* @param	InstancePtr is the instance pointer to the DMA engine.
*
* @return	XST_SUCCESS if the setup is successful, XST_FAILURE otherwise.
*
* @note		None.
*
******************************************************************************/
static int WriteSetup(XAxiVdma * InstancePtr)
{
	xil_printf("\r\nWrite setup...");
	int Index;
	u32 Addr;
	int Status;

	WriteCfg.VertSizeInput = FRAME_VERTICAL_LEN;
	WriteCfg.HoriSizeInput = FRAME_HORIZONTAL_LEN * sizeof(u32);

	WriteCfg.Stride = FRAME_HORIZONTAL_LEN * sizeof(u32);
	WriteCfg.FrameDelay = 0;  /* This example does not test frame delay */

	WriteCfg.EnableCircularBuf = 1;
	WriteCfg.EnableSync = 0;  /* No Gen-Lock */

	WriteCfg.PointNum = 0;    /* No Gen-Lock */
	WriteCfg.EnableFrameCounter = 0; /* Endless transfers */

	WriteCfg.FixedFrameStoreAddr = 0; /* We are not doing parking */

	Status = XAxiVdma_DmaConfig(InstancePtr, XAXIVDMA_WRITE, &WriteCfg);
	if (Status != XST_SUCCESS) {
		xil_printf(
		    "Write channel config failed %d\r\n", Status);

		return XST_FAILURE;
	}

	/* Initialize buffer addresses
	 *
	 * Use physical addresses
	 */

	Addr = WRITE_ADDRESS_BASE;
	for(Index = 0; Index < NUMBER_OF_WRITE_FRAMES; Index++) {
		WriteCfg.FrameStoreStartAddr[Index] = Addr;

		Addr += FRAME_HORIZONTAL_LEN * FRAME_VERTICAL_LEN * sizeof(u32);

	}


	/* Set the buffer addresses for transfer in the DMA engine
	 */
	Status = XAxiVdma_DmaSetBufferAddr(InstancePtr, XAXIVDMA_WRITE,
	        WriteCfg.FrameStoreStartAddr);
	if (Status != XST_SUCCESS) {
		xil_printf(
		    "Write channel set buffer address failed %d\r\n", Status);

		return XST_FAILURE;
	}

	/* Clear data buffer
	 */
	memset((void *)WriteFrameAddr, 0,
	    FRAME_HORIZONTAL_LEN * FRAME_VERTICAL_LEN * NUMBER_OF_WRITE_FRAMES);


	/* Initialise data buffer to blue */
	register int i;
	register u32 *vbufptr = (u32 *)READ_ADDRESS_BASE;
	for (i = 0; i < NUMBER_OF_READ_FRAMES * FRAME_HORIZONTAL_LEN * FRAME_VERTICAL_LEN ; i++) {
		vbufptr[i] = 0x0000FF;
	}

	/* Initialise data buffer with nice pattern */
//	register int i;
//	register u32 x;
//	register u32 y;
//	int frame_size = FRAME_HORIZONTAL_LEN * FRAME_VERTICAL_LEN;
//	register u32 *vbufptr = (u32 *)READ_ADDRESS_BASE;
//	for (i = 0; i < NUMBER_OF_READ_FRAMES ; i++) {
//		for (x = 0; x < FRAME_HORIZONTAL_LEN; x++) {
//			for (y = 0; y < FRAME_VERTICAL_LEN; y++) {
//				vbufptr[(i * frame_size) + y * FRAME_HORIZONTAL_LEN + x] = (x/5 * 0x000001) + (y/3 * 0x00FF00);
//			}
//		}
//	}

	xil_printf("done");
	return XST_SUCCESS;
}

/*****************************************************************************/
/**
*
* This function starts the DMA transfers. Since the DMA engine is operating
* in circular buffer mode, video frames will be transferred continuously.
*
* @param	InstancePtr points to the DMA engine instance
*
* @return	XST_SUCCESS if both read and write start succesfully
*		XST_FAILURE if one or both directions cannot be started
*
* @note		None.
*
******************************************************************************/
static int StartTransfer(XAxiVdma *InstancePtr)
{
	xil_printf("\r\nStarting transfer...");

	int Status = XST_SUCCESS;

	Status = XAxiVdma_DmaStart(InstancePtr, XAXIVDMA_WRITE);
	if (Status != XST_SUCCESS) {
		xil_printf(
		    "Start Write transfer failed %d\r\n", Status);

		return XST_FAILURE;
	}

	Status = XAxiVdma_DmaStart(InstancePtr, XAXIVDMA_READ);
	if (Status != XST_SUCCESS) {
		xil_printf(
		    "Start read transfer failed %d\r\n", Status);

		return XST_FAILURE;
	}

	xil_printf("done");
	return XST_SUCCESS;
}

int StopParking(int output)
{
	if (output)
		xil_printf("\r\nStopping parking...");

	int Status = XST_SUCCESS;

	//Status = XAxiVdma_DmaStart(&AxiVdma, XAXIVDMA_WRITE);

	XAxiVdma_StopParking(&AxiVdma, XAXIVDMA_WRITE);
	XAxiVdma_StopParking(&AxiVdma, XAXIVDMA_READ);

	if (Status != XST_SUCCESS) {
		xil_printf(
		    "Start Write transfer failed %d\r\n", Status);

		return XST_FAILURE;
	}

	if (output)
		xil_printf("done");
	return XST_SUCCESS;
}

int StartParking(int writeFrame, int readFrame, int output)
{
	if (output)
		xil_printf("\r\nStarting parking...");

	int Status = XST_SUCCESS;

	//XAxiVdma_DmaStop(&AxiVdma, XAXIVDMA_WRITE);

	Status = XAxiVdma_StartParking(&AxiVdma, writeFrame, XAXIVDMA_WRITE); // Park write on frame 2 (to stop writing to frame 0)
	Status &= XAxiVdma_StartParking(&AxiVdma, readFrame, XAXIVDMA_READ); // Park read on frame 0 (output should be frozen)

	if (Status != XST_SUCCESS) {
		xil_printf(
			"Start Write transfer failed %d\r\n", Status);

		return XST_FAILURE;
	}

	if (output)
		xil_printf("done");
	return Status;
}

void EnableVDMAEthIntr(void) {
	streamDelay = 0;
	interlaced = 0;

	frmptr = (u32 *)(MEM_BASE_ADDR  +
	              	 (VBUFFER_X * sizeof(u32)) +
	              	 (VBUFFER_Y * FRAME_HORIZONTAL_LEN * sizeof(u32)) +
	              	 (FRAME_HORIZONTAL_LEN * FRAME_VERTICAL_LEN * sizeof(u32)));

	interruptMask |= ETH_INTERRUPT_MASK;
	XAxiVdma_IntrEnable(&AxiVdma, XAXIVDMA_IXR_FRMCNT_MASK, XAXIVDMA_WRITE);
}

void DisableVDMAEthIntr(void) {
	interruptMask &= ~ETH_INTERRUPT_MASK;

	if (interruptMask == NO_INTERRUPT_MASK)
		XAxiVdma_IntrDisable(&AxiVdma, XAXIVDMA_IXR_FRMCNT_MASK, XAXIVDMA_WRITE);
}

void EnableVDMAUARTIntr(void) {
	StartParking(0, 0, 0);

	vBufferCounter = 0;

	frmptr = (u32 *)(MEM_BASE_ADDR  +
	              	 (VBUFFER_X * sizeof(u32)) +
	                 (VBUFFER_Y * FRAME_HORIZONTAL_LEN * sizeof(u32)));


	interruptMask |= UART_INTERRUPT_MASK;
	XAxiVdma_IntrEnable(&AxiVdma, XAXIVDMA_IXR_FRMCNT_MASK, XAXIVDMA_WRITE);
}

/*****************************************************************************/
/*
*
* This function setups the interrupt system so interrupts can occur for the
* DMA.  This function assumes INTC component exists in the hardware system.
*
* @param	AxiDmaPtr is a pointer to the instance of the DMA engine
* @param	ReadIntrId is the read channel Interrupt ID.
* @param	WriteIntrId is the write channel Interrupt ID.
*
* @return	XST_SUCCESS if successful, otherwise XST_FAILURE.
*
* @note		None.
*
******************************************************************************/
static int SetupIntrSystem(XAxiVdma *AxiVdmaPtr, u16 ReadIntrId,
				u16 WriteIntrId)
{
	xil_printf("\r\nEnabling interrupts...");
	int Status;

	XIntc *IntcInstancePtr = &Intc;


	/* Initialize the interrupt controller and connect the ISRs */
//	Status = XIntc_Initialize(IntcInstancePtr, INTC_DEVICE_ID);
//	if (Status != XST_SUCCESS) {
//
//		xil_printf( "Failed init intc\r\n");
//		return XST_FAILURE;
//	}

//	Status = XIntc_Connect(IntcInstancePtr, ReadIntrId,
//	         (XInterruptHandler)XAxiVdma_ReadIntrHandler, AxiVdmaPtr);
//	if (Status != XST_SUCCESS) {
//
//		xil_printf(
//		    "Failed read channel connect intc %d\r\n", Status);
//		return XST_FAILURE;
//	}

	Status = XIntc_Connect(IntcInstancePtr, WriteIntrId,
	         (XInterruptHandler)XAxiVdma_WriteIntrHandler, AxiVdmaPtr);
	if (Status != XST_SUCCESS) {

		xil_printf(
		    "Failed write channel connect intc %d\r\n", Status);
		return XST_FAILURE;
	}

	/* Start the interrupt controller */
	Status = XIntc_Start(IntcInstancePtr, XIN_REAL_MODE);
	if (Status != XST_SUCCESS) {

		xil_printf( "Failed to start intc\r\n");
		return XST_FAILURE;
	}

	/* Enable interrupts from the hardware */
//	XIntc_Enable(IntcInstancePtr, ReadIntrId);
	XIntc_Enable(IntcInstancePtr, WriteIntrId);

	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			(Xil_ExceptionHandler)XIntc_InterruptHandler,
			(void *)IntcInstancePtr);

	Xil_ExceptionEnable();

	xil_printf("done");
	return XST_SUCCESS;
}

/*****************************************************************************/
/**
*
* This function disables the interrupts
*
* @param	ReadIntrId is interrupt ID associated w/ DMA read channel
* @param	WriteIntrId is interrupt ID associated w/ DMA write channel
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
static void DisableIntrSystem(u16 ReadIntrId, u16 WriteIntrId)
{
	xil_printf("\r\nDisabling interrupts...");
	XIntc *IntcInstancePtr = &Intc;

	/* Disconnect the interrupts for the DMA TX and RX channels */
	XIntc_Disconnect(IntcInstancePtr, ReadIntrId);
	XIntc_Disconnect(IntcInstancePtr, WriteIntrId);
	xil_printf("done");
}

/*****************************************************************************/
/*
 * Call back function for read channel
 *
 * This callback only clears the interrupts and updates the transfer status.
 *
 * @param	CallbackRef is the call back reference pointer
 * @param	Mask is the interrupt mask passed in from the driver
 *
 * @return	None
*
******************************************************************************/
static void ReadCallBack(void *CallbackRef, u32 Mask)
{
	if (Mask & XAXIVDMA_IXR_FRMCNT_MASK) {
		ReadDone += 1;
	}
//	xil_printf("r.");
}

/*****************************************************************************/
/*
 * Call back function for read channel error interrupt
 *
 * @param	CallbackRef is the call back reference pointer
 * @param	Mask is the interrupt mask passed in from the driver
 *
 * @return	None
*
******************************************************************************/
static void ReadErrorCallBack(void *CallbackRef, u32 Mask)
{
	if (Mask & XAXIVDMA_IXR_ERROR_MASK) {
		ReadError += 1;
	}
//	xil_printf("r!");
}

/*****************************************************************************/
/*
 * Call back function for write channel
 *
 * This callback only clears the interrupts and updates the transfer status.
 *
 * @param	CallbackRef is the call back reference pointer
 * @param	Mask is the interrupt mask passed in from the driver
 *
 * @return	None
*
******************************************************************************/
static void WriteCallBack(void *CallbackRef, u32 Mask)
{
	if (interruptMask & UART_INTERRUPT_MASK) {
		// Add 1 frame on to counteract buffer at start
		if (vBufferCounter < (VBUFFER_FRAMES+1)) {
			vbufptr = (u32 *)(VBUFFER_BASE_ADDR + (vBufferCounter * VBUFFER_HEIGHT * VBUFFER_WIDTH * sizeof(u32)));
			for (vBufferY = 0; vBufferY < VBUFFER_HEIGHT; vBufferY++) {
				for (vBufferX = 0; vBufferX < VBUFFER_WIDTH; vBufferX++) {
					vbufptr[vBufferX + (vBufferY * VBUFFER_WIDTH)] = frmptr[vBufferX + (vBufferY * FRAME_HORIZONTAL_LEN)];
				}
			}

			vBufferCounter++;
		}
		else {
			interruptMask &= ~UART_INTERRUPT_MASK;

			if (interruptMask == NO_INTERRUPT_MASK)
				XAxiVdma_IntrDisable(&AxiVdma, XAXIVDMA_IXR_FRMCNT_MASK, XAXIVDMA_WRITE);

			StopParking(0);

			// Output over UART
			register int i;
			u8 r, g, b;
			register u32 *vbufptr = (u32 *)(VBUFFER_BASE_ADDR);
			// Skip the first frame, as it may be from earlier in time (due to buffer)
			for (i = VBUFFER_WIDTH * VBUFFER_HEIGHT; i < VBUFFER_WIDTH * VBUFFER_HEIGHT * (VBUFFER_FRAMES+1); i+= VBUFFER_WIDTH / 2) {
				//u32 pixel = vbufptr[i];
				//b = (u8)pixel;
				//g = (u8)(pixel >> 8);
				//r = (u8)(pixel >> 16);
				//XUartLite_SendByte(XPAR_UARTLITE_1_BASEADDR, r);
				//XUartLite_SendByte(XPAR_UARTLITE_1_BASEADDR, g);
				//XUartLite_SendByte(XPAR_UARTLITE_1_BASEADDR, b);
				ethernetSendPayload(VBUFFER_WIDTH * 2, (u8*)(vbufptr + i));
			}
		}
	}

	if (interruptMask & ETH_INTERRUPT_MASK) {
		if (streamDelay == 0) {
			streamDelay = STREAM_DELAY;
			u8 *PayloadPtr;
			static u16 x;
			static u16 y;
			static u32 pixel;

			// Copy subframe into Ethernet packet
			for (y = interlaced; y < VBUFFER_HEIGHT; y+=2) {
				PayloadPtr = (u8 *)TxFrame + XEL_HEADER_SIZE + 28;
				*((u16 *)PayloadPtr) = y;
				PayloadPtr += 2;
				for (x = 0; x < VBUFFER_WIDTH; x++) {
					pixel = frmptr[x + (y * FRAME_HORIZONTAL_LEN)];
					*((u16 *)PayloadPtr) = (u16)(((pixel & 0x00F80000) >> 8) | ((pixel & 0x0000FC00) >> 5) | ((pixel & 0x000000F8) >> 3));
					PayloadPtr += 2;
				}
				// Add header and send packet
				ethernetSend(VBUFFER_WIDTH * 2 + 2);
			}

			interlaced ^= 0x01;
		}
		else {
			streamDelay--;
		}

	}
//	xil_printf("w.");
}

/*****************************************************************************/
/*
* Call back function for write channel error interrupt
*
* @param	CallbackRef is the call back reference pointer
* @param	Mask is the interrupt mask passed in from the driver
*
* @return	None
*
******************************************************************************/
static void WriteErrorCallBack(void *CallbackRef, u32 Mask)
{
	if (Mask & XAXIVDMA_IXR_ERROR_MASK) {
		WriteError += 1;
	}
//	xil_printf("w!");
}


