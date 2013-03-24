-------------------------------------------------------------------------------
-- system_qspi_flash_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library axi_quad_spi_v2_00_a;
use axi_quad_spi_v2_00_a.all;

entity system_qspi_flash_wrapper is
  port (
    EXT_SPI_CLK : in std_logic;
    S_AXI_ACLK : in std_logic;
    S_AXI_ARESETN : in std_logic;
    S_AXI4_ACLK : in std_logic;
    S_AXI4_ARESETN : in std_logic;
    S_AXI_AWADDR : in std_logic_vector(6 downto 0);
    S_AXI_AWVALID : in std_logic;
    S_AXI_AWREADY : out std_logic;
    S_AXI_WDATA : in std_logic_vector(31 downto 0);
    S_AXI_WSTRB : in std_logic_vector(3 downto 0);
    S_AXI_WVALID : in std_logic;
    S_AXI_WREADY : out std_logic;
    S_AXI_BRESP : out std_logic_vector(1 downto 0);
    S_AXI_BVALID : out std_logic;
    S_AXI_BREADY : in std_logic;
    S_AXI_ARADDR : in std_logic_vector(6 downto 0);
    S_AXI_ARVALID : in std_logic;
    S_AXI_ARREADY : out std_logic;
    S_AXI_RDATA : out std_logic_vector(31 downto 0);
    S_AXI_RRESP : out std_logic_vector(1 downto 0);
    S_AXI_RVALID : out std_logic;
    S_AXI_RREADY : in std_logic;
    S_AXI4_AWID : in std_logic_vector(3 downto 0);
    S_AXI4_AWADDR : in std_logic_vector(23 downto 0);
    S_AXI4_AWLEN : in std_logic_vector(7 downto 0);
    S_AXI4_AWSIZE : in std_logic_vector(2 downto 0);
    S_AXI4_AWBURST : in std_logic_vector(1 downto 0);
    S_AXI4_AWLOCK : in std_logic;
    S_AXI4_AWCACHE : in std_logic_vector(3 downto 0);
    S_AXI4_AWPROT : in std_logic_vector(2 downto 0);
    S_AXI4_AWVALID : in std_logic;
    S_AXI4_AWREADY : out std_logic;
    S_AXI4_WDATA : in std_logic_vector(31 downto 0);
    S_AXI4_WSTRB : in std_logic_vector(3 downto 0);
    S_AXI4_WLAST : in std_logic;
    S_AXI4_WVALID : in std_logic;
    S_AXI4_WREADY : out std_logic;
    S_AXI4_BID : out std_logic_vector(3 downto 0);
    S_AXI4_BRESP : out std_logic_vector(1 downto 0);
    S_AXI4_BVALID : out std_logic;
    S_AXI4_BREADY : in std_logic;
    S_AXI4_ARID : in std_logic_vector(3 downto 0);
    S_AXI4_ARADDR : in std_logic_vector(23 downto 0);
    S_AXI4_ARLEN : in std_logic_vector(7 downto 0);
    S_AXI4_ARSIZE : in std_logic_vector(2 downto 0);
    S_AXI4_ARBURST : in std_logic_vector(1 downto 0);
    S_AXI4_ARLOCK : in std_logic;
    S_AXI4_ARCACHE : in std_logic_vector(3 downto 0);
    S_AXI4_ARPROT : in std_logic_vector(2 downto 0);
    S_AXI4_ARVALID : in std_logic;
    S_AXI4_ARREADY : out std_logic;
    S_AXI4_RID : out std_logic_vector(3 downto 0);
    S_AXI4_RDATA : out std_logic_vector(31 downto 0);
    S_AXI4_RRESP : out std_logic_vector(1 downto 0);
    S_AXI4_RLAST : out std_logic;
    S_AXI4_RVALID : out std_logic;
    S_AXI4_RREADY : in std_logic;
    SCK_I : in std_logic;
    SCK_O : out std_logic;
    SCK_T : out std_logic;
    SS_I : in std_logic_vector(0 downto 0);
    SS_O : out std_logic_vector(0 downto 0);
    SS_T : out std_logic;
    SPISEL : in std_logic;
    IP2INTC_Irpt : out std_logic;
    IO0_I : in std_logic;
    IO0_O : out std_logic;
    IO0_T : out std_logic;
    IO1_I : in std_logic;
    IO1_O : out std_logic;
    IO1_T : out std_logic;
    IO2_I : in std_logic;
    IO2_O : out std_logic;
    IO2_T : out std_logic;
    IO3_I : in std_logic;
    IO3_O : out std_logic;
    IO3_T : out std_logic
  );

  attribute x_core_info : STRING;
  attribute x_core_info of system_qspi_flash_wrapper : entity is "axi_quad_spi_v2_00_a";

end system_qspi_flash_wrapper;

architecture STRUCTURE of system_qspi_flash_wrapper is

  component axi_quad_spi is
    generic (
      C_INSTANCE : STRING;
      C_FAMILY : STRING;
      C_SUB_FAMILY : STRING;
      C_S_AXI_DATA_WIDTH : INTEGER;
      C_S_AXI4_DATA_WIDTH : INTEGER;
      C_S_AXI4_ID_WIDTH : INTEGER;
      C_FIFO_DEPTH : INTEGER;
      C_SCK_RATIO : INTEGER;
      C_NUM_SS_BITS : INTEGER;
      C_NUM_TRANSFER_BITS : INTEGER;
      C_TYPE_OF_AXI4_INTERFACE : INTEGER;
      C_XIP_MODE : INTEGER;
      C_SPI_MODE : INTEGER;
      C_SPI_MEMORY : INTEGER;
      C_USE_STARTUP : INTEGER
    );
    port (
      EXT_SPI_CLK : in std_logic;
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI4_ACLK : in std_logic;
      S_AXI4_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector(6 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector((C_S_AXI_DATA_WIDTH-1) downto 0);
      S_AXI_WSTRB : in std_logic_vector(((C_S_AXI_DATA_WIDTH/8)-1) downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(6 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector((C_S_AXI_DATA_WIDTH-1) downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      S_AXI4_AWID : in std_logic_vector((C_S_AXI4_ID_WIDTH-1) downto 0);
      S_AXI4_AWADDR : in std_logic_vector(23 downto 0);
      S_AXI4_AWLEN : in std_logic_vector(7 downto 0);
      S_AXI4_AWSIZE : in std_logic_vector(2 downto 0);
      S_AXI4_AWBURST : in std_logic_vector(1 downto 0);
      S_AXI4_AWLOCK : in std_logic;
      S_AXI4_AWCACHE : in std_logic_vector(3 downto 0);
      S_AXI4_AWPROT : in std_logic_vector(2 downto 0);
      S_AXI4_AWVALID : in std_logic;
      S_AXI4_AWREADY : out std_logic;
      S_AXI4_WDATA : in std_logic_vector((C_S_AXI4_DATA_WIDTH-1) downto 0);
      S_AXI4_WSTRB : in std_logic_vector(((C_S_AXI4_DATA_WIDTH/8)-1) downto 0);
      S_AXI4_WLAST : in std_logic;
      S_AXI4_WVALID : in std_logic;
      S_AXI4_WREADY : out std_logic;
      S_AXI4_BID : out std_logic_vector((C_S_AXI4_ID_WIDTH-1) downto 0);
      S_AXI4_BRESP : out std_logic_vector(1 downto 0);
      S_AXI4_BVALID : out std_logic;
      S_AXI4_BREADY : in std_logic;
      S_AXI4_ARID : in std_logic_vector((C_S_AXI4_ID_WIDTH-1) downto 0);
      S_AXI4_ARADDR : in std_logic_vector(23 downto 0);
      S_AXI4_ARLEN : in std_logic_vector(7 downto 0);
      S_AXI4_ARSIZE : in std_logic_vector(2 downto 0);
      S_AXI4_ARBURST : in std_logic_vector(1 downto 0);
      S_AXI4_ARLOCK : in std_logic;
      S_AXI4_ARCACHE : in std_logic_vector(3 downto 0);
      S_AXI4_ARPROT : in std_logic_vector(2 downto 0);
      S_AXI4_ARVALID : in std_logic;
      S_AXI4_ARREADY : out std_logic;
      S_AXI4_RID : out std_logic_vector((C_S_AXI4_ID_WIDTH-1) downto 0);
      S_AXI4_RDATA : out std_logic_vector((C_S_AXI4_DATA_WIDTH-1) downto 0);
      S_AXI4_RRESP : out std_logic_vector(1 downto 0);
      S_AXI4_RLAST : out std_logic;
      S_AXI4_RVALID : out std_logic;
      S_AXI4_RREADY : in std_logic;
      SCK_I : in std_logic;
      SCK_O : out std_logic;
      SCK_T : out std_logic;
      SS_I : in std_logic_vector((C_NUM_SS_BITS-1) downto 0);
      SS_O : out std_logic_vector((C_NUM_SS_BITS-1) downto 0);
      SS_T : out std_logic;
      SPISEL : in std_logic;
      IP2INTC_Irpt : out std_logic;
      IO0_I : in std_logic;
      IO0_O : out std_logic;
      IO0_T : out std_logic;
      IO1_I : in std_logic;
      IO1_O : out std_logic;
      IO1_T : out std_logic;
      IO2_I : in std_logic;
      IO2_O : out std_logic;
      IO2_T : out std_logic;
      IO3_I : in std_logic;
      IO3_O : out std_logic;
      IO3_T : out std_logic
    );
  end component;

begin

  QSPI_FLASH : axi_quad_spi
    generic map (
      C_INSTANCE => "QSPI_FLASH",
      C_FAMILY => "spartan6",
      C_SUB_FAMILY => "spartan6",
      C_S_AXI_DATA_WIDTH => 32,
      C_S_AXI4_DATA_WIDTH => 32,
      C_S_AXI4_ID_WIDTH => 4,
      C_FIFO_DEPTH => 16,
      C_SCK_RATIO => 16,
      C_NUM_SS_BITS => 1,
      C_NUM_TRANSFER_BITS => 8,
      C_TYPE_OF_AXI4_INTERFACE => 0,
      C_XIP_MODE => 0,
      C_SPI_MODE => 0,
      C_SPI_MEMORY => 1,
      C_USE_STARTUP => 0
    )
    port map (
      EXT_SPI_CLK => EXT_SPI_CLK,
      S_AXI_ACLK => S_AXI_ACLK,
      S_AXI_ARESETN => S_AXI_ARESETN,
      S_AXI4_ACLK => S_AXI4_ACLK,
      S_AXI4_ARESETN => S_AXI4_ARESETN,
      S_AXI_AWADDR => S_AXI_AWADDR,
      S_AXI_AWVALID => S_AXI_AWVALID,
      S_AXI_AWREADY => S_AXI_AWREADY,
      S_AXI_WDATA => S_AXI_WDATA,
      S_AXI_WSTRB => S_AXI_WSTRB,
      S_AXI_WVALID => S_AXI_WVALID,
      S_AXI_WREADY => S_AXI_WREADY,
      S_AXI_BRESP => S_AXI_BRESP,
      S_AXI_BVALID => S_AXI_BVALID,
      S_AXI_BREADY => S_AXI_BREADY,
      S_AXI_ARADDR => S_AXI_ARADDR,
      S_AXI_ARVALID => S_AXI_ARVALID,
      S_AXI_ARREADY => S_AXI_ARREADY,
      S_AXI_RDATA => S_AXI_RDATA,
      S_AXI_RRESP => S_AXI_RRESP,
      S_AXI_RVALID => S_AXI_RVALID,
      S_AXI_RREADY => S_AXI_RREADY,
      S_AXI4_AWID => S_AXI4_AWID,
      S_AXI4_AWADDR => S_AXI4_AWADDR,
      S_AXI4_AWLEN => S_AXI4_AWLEN,
      S_AXI4_AWSIZE => S_AXI4_AWSIZE,
      S_AXI4_AWBURST => S_AXI4_AWBURST,
      S_AXI4_AWLOCK => S_AXI4_AWLOCK,
      S_AXI4_AWCACHE => S_AXI4_AWCACHE,
      S_AXI4_AWPROT => S_AXI4_AWPROT,
      S_AXI4_AWVALID => S_AXI4_AWVALID,
      S_AXI4_AWREADY => S_AXI4_AWREADY,
      S_AXI4_WDATA => S_AXI4_WDATA,
      S_AXI4_WSTRB => S_AXI4_WSTRB,
      S_AXI4_WLAST => S_AXI4_WLAST,
      S_AXI4_WVALID => S_AXI4_WVALID,
      S_AXI4_WREADY => S_AXI4_WREADY,
      S_AXI4_BID => S_AXI4_BID,
      S_AXI4_BRESP => S_AXI4_BRESP,
      S_AXI4_BVALID => S_AXI4_BVALID,
      S_AXI4_BREADY => S_AXI4_BREADY,
      S_AXI4_ARID => S_AXI4_ARID,
      S_AXI4_ARADDR => S_AXI4_ARADDR,
      S_AXI4_ARLEN => S_AXI4_ARLEN,
      S_AXI4_ARSIZE => S_AXI4_ARSIZE,
      S_AXI4_ARBURST => S_AXI4_ARBURST,
      S_AXI4_ARLOCK => S_AXI4_ARLOCK,
      S_AXI4_ARCACHE => S_AXI4_ARCACHE,
      S_AXI4_ARPROT => S_AXI4_ARPROT,
      S_AXI4_ARVALID => S_AXI4_ARVALID,
      S_AXI4_ARREADY => S_AXI4_ARREADY,
      S_AXI4_RID => S_AXI4_RID,
      S_AXI4_RDATA => S_AXI4_RDATA,
      S_AXI4_RRESP => S_AXI4_RRESP,
      S_AXI4_RLAST => S_AXI4_RLAST,
      S_AXI4_RVALID => S_AXI4_RVALID,
      S_AXI4_RREADY => S_AXI4_RREADY,
      SCK_I => SCK_I,
      SCK_O => SCK_O,
      SCK_T => SCK_T,
      SS_I => SS_I,
      SS_O => SS_O,
      SS_T => SS_T,
      SPISEL => SPISEL,
      IP2INTC_Irpt => IP2INTC_Irpt,
      IO0_I => IO0_I,
      IO0_O => IO0_O,
      IO0_T => IO0_T,
      IO1_I => IO1_I,
      IO1_O => IO1_O,
      IO1_T => IO1_T,
      IO2_I => IO2_I,
      IO2_O => IO2_O,
      IO2_T => IO2_T,
      IO3_I => IO3_I,
      IO3_O => IO3_O,
      IO3_T => IO3_T
    );

end architecture STRUCTURE;

