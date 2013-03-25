-------------------------------------------------------------------------------
-- system_axi_iic_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library axi_iic_v1_02_a;
use axi_iic_v1_02_a.all;

entity system_axi_iic_0_wrapper is
  port (
    S_AXI_ACLK : in std_logic;
    S_AXI_ARESETN : in std_logic;
    IIC2INTC_Irpt : out std_logic;
    S_AXI_AWADDR : in std_logic_vector(8 downto 0);
    S_AXI_AWVALID : in std_logic;
    S_AXI_AWREADY : out std_logic;
    S_AXI_WDATA : in std_logic_vector(31 downto 0);
    S_AXI_WSTRB : in std_logic_vector(3 downto 0);
    S_AXI_WVALID : in std_logic;
    S_AXI_WREADY : out std_logic;
    S_AXI_BRESP : out std_logic_vector(1 downto 0);
    S_AXI_BVALID : out std_logic;
    S_AXI_BREADY : in std_logic;
    S_AXI_ARADDR : in std_logic_vector(8 downto 0);
    S_AXI_ARVALID : in std_logic;
    S_AXI_ARREADY : out std_logic;
    S_AXI_RDATA : out std_logic_vector(31 downto 0);
    S_AXI_RRESP : out std_logic_vector(1 downto 0);
    S_AXI_RVALID : out std_logic;
    S_AXI_RREADY : in std_logic;
    Sda_I : in std_logic;
    Sda_O : out std_logic;
    Sda_T : out std_logic;
    Scl_I : in std_logic;
    Scl_O : out std_logic;
    Scl_T : out std_logic;
    Gpo : out std_logic_vector(0 to 0)
  );

  attribute x_core_info : STRING;
  attribute x_core_info of system_axi_iic_0_wrapper : entity is "axi_iic_v1_02_a";

end system_axi_iic_0_wrapper;

architecture STRUCTURE of system_axi_iic_0_wrapper is

  component axi_iic is
    generic (
      C_FAMILY : STRING;
      C_INSTANCE : STRING;
      C_S_AXI_ADDR_WIDTH : INTEGER;
      C_S_AXI_DATA_WIDTH : INTEGER;
      C_IIC_FREQ : INTEGER;
      C_TEN_BIT_ADR : INTEGER;
      C_GPO_WIDTH : INTEGER;
      C_S_AXI_ACLK_FREQ_HZ : INTEGER;
      C_SCL_INERTIAL_DELAY : INTEGER;
      C_SDA_INERTIAL_DELAY : INTEGER;
      C_SDA_LEVEL : INTEGER
    );
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      IIC2INTC_Irpt : out std_logic;
      S_AXI_AWADDR : in std_logic_vector(8 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector((C_S_AXI_DATA_WIDTH-1) downto 0);
      S_AXI_WSTRB : in std_logic_vector(((C_S_AXI_DATA_WIDTH/8)-1) downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector(8 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector((C_S_AXI_DATA_WIDTH-1) downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      Sda_I : in std_logic;
      Sda_O : out std_logic;
      Sda_T : out std_logic;
      Scl_I : in std_logic;
      Scl_O : out std_logic;
      Scl_T : out std_logic;
      Gpo : out std_logic_vector((C_GPO_WIDTH-1) to 0)
    );
  end component;

begin

  axi_iic_0 : axi_iic
    generic map (
      C_FAMILY => "spartan6",
      C_INSTANCE => "axi_iic_0",
      C_S_AXI_ADDR_WIDTH => 9,
      C_S_AXI_DATA_WIDTH => 32,
      C_IIC_FREQ => 100000,
      C_TEN_BIT_ADR => 0,
      C_GPO_WIDTH => 1,
      C_S_AXI_ACLK_FREQ_HZ => 100000000,
      C_SCL_INERTIAL_DELAY => 5,
      C_SDA_INERTIAL_DELAY => 5,
      C_SDA_LEVEL => 1
    )
    port map (
      S_AXI_ACLK => S_AXI_ACLK,
      S_AXI_ARESETN => S_AXI_ARESETN,
      IIC2INTC_Irpt => IIC2INTC_Irpt,
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
      Sda_I => Sda_I,
      Sda_O => Sda_O,
      Sda_T => Sda_T,
      Scl_I => Scl_I,
      Scl_O => Scl_O,
      Scl_T => Scl_T,
      Gpo => Gpo
    );

end architecture STRUCTURE;

