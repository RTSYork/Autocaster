-------------------------------------------------------------------------------
-- system_digilent_usb_epp_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library d_usb_epp_dstm_axi_v1_00_a;
use d_usb_epp_dstm_axi_v1_00_a.all;

entity system_digilent_usb_epp_wrapper is
  port (
    IFCLK : in std_logic;
    STMEN : in std_logic;
    FLAGA : in std_logic;
    FLAGB : in std_logic;
    FLAGC : in std_logic;
    SLRD : out std_logic;
    SLWR : out std_logic;
    SLOE : out std_logic;
    FIFOADR : out std_logic_vector(1 downto 0);
    PKTEND : out std_logic;
    EPPRST : in std_logic;
    int_usb : out std_logic;
    DB_I : in std_logic_vector(7 downto 0);
    DB_O : out std_logic_vector(7 downto 0);
    DB_T : out std_logic_vector(7 downto 0);
    IRQ_EPP : out std_logic;
    S_AXI_ACLK : in std_logic;
    S_AXI_ARESETN : in std_logic;
    S_AXI_AWADDR : in std_logic_vector(31 downto 0);
    S_AXI_AWVALID : in std_logic;
    S_AXI_WDATA : in std_logic_vector(31 downto 0);
    S_AXI_WSTRB : in std_logic_vector(3 downto 0);
    S_AXI_WVALID : in std_logic;
    S_AXI_BREADY : in std_logic;
    S_AXI_ARADDR : in std_logic_vector(31 downto 0);
    S_AXI_ARVALID : in std_logic;
    S_AXI_RREADY : in std_logic;
    S_AXI_ARREADY : out std_logic;
    S_AXI_RDATA : out std_logic_vector(31 downto 0);
    S_AXI_RRESP : out std_logic_vector(1 downto 0);
    S_AXI_RVALID : out std_logic;
    S_AXI_WREADY : out std_logic;
    S_AXI_BRESP : out std_logic_vector(1 downto 0);
    S_AXI_BVALID : out std_logic;
    S_AXI_AWREADY : out std_logic
  );
end system_digilent_usb_epp_wrapper;

architecture STRUCTURE of system_digilent_usb_epp_wrapper is

  component d_usb_epp_dstm_axi is
    generic (
      C_NUM_USER_REGS : INTEGER;
      FIFO_ADDR_WIDTH : INTEGER;
      C_S_AXI_DATA_WIDTH : INTEGER;
      C_S_AXI_ADDR_WIDTH : INTEGER;
      C_S_AXI_MIN_SIZE : std_logic_vector;
      C_USE_WSTRB : INTEGER;
      C_DPHASE_TIMEOUT : INTEGER;
      C_BASEADDR : std_logic_vector;
      C_HIGHADDR : std_logic_vector;
      C_FAMILY : STRING;
      C_NUM_REG : INTEGER;
      C_NUM_MEM : INTEGER;
      C_SLV_AWIDTH : INTEGER;
      C_SLV_DWIDTH : INTEGER
    );
    port (
      IFCLK : in std_logic;
      STMEN : in std_logic;
      FLAGA : in std_logic;
      FLAGB : in std_logic;
      FLAGC : in std_logic;
      SLRD : out std_logic;
      SLWR : out std_logic;
      SLOE : out std_logic;
      FIFOADR : out std_logic_vector(1 downto 0);
      PKTEND : out std_logic;
      EPPRST : in std_logic;
      int_usb : out std_logic;
      DB_I : in std_logic_vector(7 downto 0);
      DB_O : out std_logic_vector(7 downto 0);
      DB_T : out std_logic_vector(7 downto 0);
      IRQ_EPP : out std_logic;
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector((C_S_AXI_ADDR_WIDTH-1) downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_WDATA : in std_logic_vector((C_S_AXI_DATA_WIDTH-1) downto 0);
      S_AXI_WSTRB : in std_logic_vector(((C_S_AXI_DATA_WIDTH/8)-1) downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector((C_S_AXI_ADDR_WIDTH-1) downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_RREADY : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector((C_S_AXI_DATA_WIDTH-1) downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_AWREADY : out std_logic
    );
  end component;

begin

  Digilent_Usb_Epp : d_usb_epp_dstm_axi
    generic map (
      C_NUM_USER_REGS => 2,
      FIFO_ADDR_WIDTH => 11,
      C_S_AXI_DATA_WIDTH => 32,
      C_S_AXI_ADDR_WIDTH => 32,
      C_S_AXI_MIN_SIZE => X"00000200",
      C_USE_WSTRB => 0,
      C_DPHASE_TIMEOUT => 8,
      C_BASEADDR => X"7bc00000",
      C_HIGHADDR => X"7bc0ffff",
      C_FAMILY => "spartan6",
      C_NUM_REG => 1,
      C_NUM_MEM => 1,
      C_SLV_AWIDTH => 32,
      C_SLV_DWIDTH => 32
    )
    port map (
      IFCLK => IFCLK,
      STMEN => STMEN,
      FLAGA => FLAGA,
      FLAGB => FLAGB,
      FLAGC => FLAGC,
      SLRD => SLRD,
      SLWR => SLWR,
      SLOE => SLOE,
      FIFOADR => FIFOADR,
      PKTEND => PKTEND,
      EPPRST => EPPRST,
      int_usb => int_usb,
      DB_I => DB_I,
      DB_O => DB_O,
      DB_T => DB_T,
      IRQ_EPP => IRQ_EPP,
      S_AXI_ACLK => S_AXI_ACLK,
      S_AXI_ARESETN => S_AXI_ARESETN,
      S_AXI_AWADDR => S_AXI_AWADDR,
      S_AXI_AWVALID => S_AXI_AWVALID,
      S_AXI_WDATA => S_AXI_WDATA,
      S_AXI_WSTRB => S_AXI_WSTRB,
      S_AXI_WVALID => S_AXI_WVALID,
      S_AXI_BREADY => S_AXI_BREADY,
      S_AXI_ARADDR => S_AXI_ARADDR,
      S_AXI_ARVALID => S_AXI_ARVALID,
      S_AXI_RREADY => S_AXI_RREADY,
      S_AXI_ARREADY => S_AXI_ARREADY,
      S_AXI_RDATA => S_AXI_RDATA,
      S_AXI_RRESP => S_AXI_RRESP,
      S_AXI_RVALID => S_AXI_RVALID,
      S_AXI_WREADY => S_AXI_WREADY,
      S_AXI_BRESP => S_AXI_BRESP,
      S_AXI_BVALID => S_AXI_BVALID,
      S_AXI_AWREADY => S_AXI_AWREADY
    );

end architecture STRUCTURE;

