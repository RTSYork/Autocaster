The Autocaster
==============
### An FPGA-Based Embedded System to Autonomously Play Music Video Games
#### Russell Joyce, Department of Computer Science, University of York, UK
For more information, see https://wiki.york.ac.uk/display/RTS/The+Autocaster

---

The included 'download.bit' file is ready for configuring the FPGA using Xilinx iMPACT or Digilent Adept software. The .bit file includes the compiled MicroBlaze software .elf file.


#### Requirements for building:
- Xilinx ISE Design Tools 14.3 (Embedded or System Edition)
- Arduino 1.0.4 (http://www.arduino.cc/en/Main/Software)
- Teensyduino 1.13 (http://www.pjrc.com/teensy/td_download.html)
- Microsoft Visual Studio 2010 (for optional support programs)

---

Xilinx EDK Project
-------------------
- Open 'GH-EDK\system.xmp' in Xilinx Platform Studio
- Use 'Generate Bitstream' command to create a .bit file or 'Export to SDK' to generate .bit file and open SDK project


Xilinx SDK Project
-------------------
- In Xilinx SDK import project and choose 'GH-SDK' folder
- Import all three projects
- Use 'Export to SDK' command in XPS and select the workspace to copy over .bit file, etc.
- Use 'Program FPGA' and run as 'Execute on Hardware' to run project


Teensyduino Project
-------------------
- Copy the contents of the 'Teensy/teensy' folder to the 'hardware/teensy' folder in the Arduino install directory
- Open 'Guitar/Guitar.ino' in Arduino IDE
- From tools menu, select "Teensy 3.0" as the board
- From tools menu, select "My Guitar" as the USB Type
- Use 'Verify' or 'Upload' to build the program
- Press the reset button on the Teensy board to program


UART Image Capture
-------------------
- Open 'UARTImage/UARTImage.sln' in Microsoft Visual Studio


Image Filter Test
-------------------
- Open 'Image Filter/Image Filter.sln' in Microsoft Visual Studio
