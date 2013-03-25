-------------------------------------------------------------------------------
-- system_image_filter_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library image_filter_v1_00_a;
use image_filter_v1_00_a.all;

entity system_image_filter_0_wrapper is
  port (
    ACLK : in std_logic;
    RGB_OUT : out std_logic_vector(23 downto 0);
    S_AXIS_S2MM_ACLK : out std_logic;
    S_AXIS_S2MM_ARESETN : in std_logic;
    S_AXIS_S2MM_TREADY : out std_logic;
    S_AXIS_S2MM_TDATA : in std_logic_vector(31 downto 0);
    S_AXIS_S2MM_TKEEP : in std_logic_vector(3 downto 0);
    S_AXIS_S2MM_TLAST : in std_logic;
    S_AXIS_S2MM_TVALID : in std_logic;
    M_AXIS_S2MM_ACLK : out std_logic;
    M_AXIS_S2MM_ARESETN : in std_logic;
    M_AXIS_S2MM_TVALID : out std_logic;
    M_AXIS_S2MM_TDATA : out std_logic_vector(31 downto 0);
    M_AXIS_S2MM_TKEEP : out std_logic_vector(3 downto 0);
    M_AXIS_S2MM_TLAST : out std_logic;
    M_AXIS_S2MM_TREADY : in std_logic;
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
end system_image_filter_0_wrapper;

architecture STRUCTURE of system_image_filter_0_wrapper is

  component image_filter is
    generic (
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
      ACLK : in std_logic;
      RGB_OUT : out std_logic_vector(23 downto 0);
      S_AXIS_S2MM_ACLK : out std_logic;
      S_AXIS_S2MM_ARESETN : in std_logic;
      S_AXIS_S2MM_TREADY : out std_logic;
      S_AXIS_S2MM_TDATA : in std_logic_vector(31 downto 0);
      S_AXIS_S2MM_TKEEP : in std_logic_vector(3 downto 0);
      S_AXIS_S2MM_TLAST : in std_logic;
      S_AXIS_S2MM_TVALID : in std_logic;
      M_AXIS_S2MM_ACLK : out std_logic;
      M_AXIS_S2MM_ARESETN : in std_logic;
      M_AXIS_S2MM_TVALID : out std_logic;
      M_AXIS_S2MM_TDATA : out std_logic_vector(31 downto 0);
      M_AXIS_S2MM_TKEEP : out std_logic_vector(3 downto 0);
      M_AXIS_S2MM_TLAST : out std_logic;
      M_AXIS_S2MM_TREADY : in std_logic;
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

  image_filter_0 : image_filter
    generic map (
      C_S_AXI_DATA_WIDTH => 32,
      C_S_AXI_ADDR_WIDTH => 32,
      C_S_AXI_MIN_SIZE => X"000001ff",
      C_USE_WSTRB => 0,
      C_DPHASE_TIMEOUT => 8,
      C_BASEADDR => X"73a00000",
      C_HIGHADDR => X"73a0ffff",
      C_FAMILY => "spartan6",
      C_NUM_REG => 1,
      C_NUM_MEM => 1,
      C_SLV_AWIDTH => 32,
      C_SLV_DWIDTH => 32
    )
    port map (
      ACLK => ACLK,
      RGB_OUT => RGB_OUT,
      S_AXIS_S2MM_ACLK => S_AXIS_S2MM_ACLK,
      S_AXIS_S2MM_ARESETN => S_AXIS_S2MM_ARESETN,
      S_AXIS_S2MM_TREADY => S_AXIS_S2MM_TREADY,
      S_AXIS_S2MM_TDATA => S_AXIS_S2MM_TDATA,
      S_AXIS_S2MM_TKEEP => S_AXIS_S2MM_TKEEP,
      S_AXIS_S2MM_TLAST => S_AXIS_S2MM_TLAST,
      S_AXIS_S2MM_TVALID => S_AXIS_S2MM_TVALID,
      M_AXIS_S2MM_ACLK => M_AXIS_S2MM_ACLK,
      M_AXIS_S2MM_ARESETN => M_AXIS_S2MM_ARESETN,
      M_AXIS_S2MM_TVALID => M_AXIS_S2MM_TVALID,
      M_AXIS_S2MM_TDATA => M_AXIS_S2MM_TDATA,
      M_AXIS_S2MM_TKEEP => M_AXIS_S2MM_TKEEP,
      M_AXIS_S2MM_TLAST => M_AXIS_S2MM_TLAST,
      M_AXIS_S2MM_TREADY => M_AXIS_S2MM_TREADY,
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

