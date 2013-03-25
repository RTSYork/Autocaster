-------------------------------------------------------------------------------
-- system_stub.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity system_stub is
  port (
    zio : inout std_logic;
    rzq : inout std_logic;
    mcbx_dram_we_n : out std_logic;
    mcbx_dram_udqs_n : inout std_logic;
    mcbx_dram_udqs : inout std_logic;
    mcbx_dram_udm : out std_logic;
    mcbx_dram_ras_n : out std_logic;
    mcbx_dram_odt : out std_logic;
    mcbx_dram_ldm : out std_logic;
    mcbx_dram_dqs_n : inout std_logic;
    mcbx_dram_dqs : inout std_logic;
    mcbx_dram_dq : inout std_logic_vector(15 downto 0);
    mcbx_dram_clk_n : out std_logic;
    mcbx_dram_clk : out std_logic;
    mcbx_dram_cke : out std_logic;
    mcbx_dram_cas_n : out std_logic;
    mcbx_dram_ba : out std_logic_vector(2 downto 0);
    mcbx_dram_addr : out std_logic_vector(12 downto 0);
    RS232_Uart_1_sout : out std_logic;
    RS232_Uart_1_sin : in std_logic;
    RESET : in std_logic;
    QSPI_FLASH_SS : inout std_logic;
    QSPI_FLASH_SCLK : inout std_logic;
    QSPI_FLASH_IO1 : inout std_logic;
    QSPI_FLASH_IO0 : inout std_logic;
    Push_Buttons_5Bits_TRI_I : in std_logic_vector(4 downto 0);
    LEDs_8Bits_TRI_O : out std_logic_vector(7 downto 0);
    GCLK : in std_logic;
    DIP_Switches_8Bits_TRI_I : in std_logic_vector(7 downto 0);
    Digilent_Usb_Epp_IFCLK_pin : in std_logic;
    Digilent_Usb_Epp_STMEN_pin : in std_logic;
    Digilent_Usb_Epp_FLAGA_pin : in std_logic;
    Digilent_Usb_Epp_FLAGB_pin : in std_logic;
    Digilent_Usb_Epp_FLAGC_pin : in std_logic;
    Digilent_Usb_Epp_SLRD_pin : out std_logic;
    Digilent_Usb_Epp_SLWR_pin : out std_logic;
    Digilent_Usb_Epp_SLOE_pin : out std_logic;
    Digilent_Usb_Epp_FIFOADR_pin : out std_logic_vector(1 downto 0);
    Digilent_Usb_Epp_PKTEND : out std_logic;
    Digilent_Usb_Epp_EPPRST_pin : in std_logic;
    Digilent_Usb_Epp_DB : inout std_logic_vector(7 downto 0);
    axi_hdmi_0_TMDS_RX_CLK_P_pin : in std_logic;
    axi_hdmi_0_TMDS_RX_CLK_N_pin : in std_logic;
    axi_hdmi_0_TMDS_RX_2_P_pin : in std_logic;
    axi_hdmi_0_TMDS_RX_2_N_pin : in std_logic;
    axi_hdmi_0_TMDS_RX_1_P_pin : in std_logic;
    axi_hdmi_0_TMDS_RX_1_N_pin : in std_logic;
    axi_hdmi_0_TMDS_RX_0_P_pin : in std_logic;
    axi_hdmi_0_TMDS_RX_0_N_pin : in std_logic;
    axi_hdmi_0_TMDS_TX_CLK_P_pin : out std_logic;
    axi_hdmi_0_TMDS_TX_CLK_N_pin : out std_logic;
    axi_hdmi_0_TMDS_TX_2_P_pin : out std_logic;
    axi_hdmi_0_TMDS_TX_2_N_pin : out std_logic;
    axi_hdmi_0_TMDS_TX_1_P_pin : out std_logic;
    axi_hdmi_0_TMDS_TX_1_N_pin : out std_logic;
    axi_hdmi_0_TMDS_TX_0_P_pin : out std_logic;
    axi_hdmi_0_TMDS_TX_0_N_pin : out std_logic;
    axi_iic_0_Sda_pin : inout std_logic;
    axi_iic_0_Scl_pin : inout std_logic;
    gh_player_0_FRETS_pin : out std_logic_vector(4 downto 0);
    gh_player_0_STRUM_pin : out std_logic;
    gh_player_0_WHAMMY_pin : out std_logic_vector(7 downto 0);
    gh_player_0_TILT_pin : out std_logic;
    gh_player_0_LEDS_pin : out std_logic_vector(7 downto 0)
  );
end system_stub;

architecture STRUCTURE of system_stub is

  component system is
    port (
      zio : inout std_logic;
      rzq : inout std_logic;
      mcbx_dram_we_n : out std_logic;
      mcbx_dram_udqs_n : inout std_logic;
      mcbx_dram_udqs : inout std_logic;
      mcbx_dram_udm : out std_logic;
      mcbx_dram_ras_n : out std_logic;
      mcbx_dram_odt : out std_logic;
      mcbx_dram_ldm : out std_logic;
      mcbx_dram_dqs_n : inout std_logic;
      mcbx_dram_dqs : inout std_logic;
      mcbx_dram_dq : inout std_logic_vector(15 downto 0);
      mcbx_dram_clk_n : out std_logic;
      mcbx_dram_clk : out std_logic;
      mcbx_dram_cke : out std_logic;
      mcbx_dram_cas_n : out std_logic;
      mcbx_dram_ba : out std_logic_vector(2 downto 0);
      mcbx_dram_addr : out std_logic_vector(12 downto 0);
      RS232_Uart_1_sout : out std_logic;
      RS232_Uart_1_sin : in std_logic;
      RESET : in std_logic;
      QSPI_FLASH_SS : inout std_logic;
      QSPI_FLASH_SCLK : inout std_logic;
      QSPI_FLASH_IO1 : inout std_logic;
      QSPI_FLASH_IO0 : inout std_logic;
      Push_Buttons_5Bits_TRI_I : in std_logic_vector(4 downto 0);
      LEDs_8Bits_TRI_O : out std_logic_vector(7 downto 0);
      GCLK : in std_logic;
      DIP_Switches_8Bits_TRI_I : in std_logic_vector(7 downto 0);
      Digilent_Usb_Epp_IFCLK_pin : in std_logic;
      Digilent_Usb_Epp_STMEN_pin : in std_logic;
      Digilent_Usb_Epp_FLAGA_pin : in std_logic;
      Digilent_Usb_Epp_FLAGB_pin : in std_logic;
      Digilent_Usb_Epp_FLAGC_pin : in std_logic;
      Digilent_Usb_Epp_SLRD_pin : out std_logic;
      Digilent_Usb_Epp_SLWR_pin : out std_logic;
      Digilent_Usb_Epp_SLOE_pin : out std_logic;
      Digilent_Usb_Epp_FIFOADR_pin : out std_logic_vector(1 downto 0);
      Digilent_Usb_Epp_PKTEND : out std_logic;
      Digilent_Usb_Epp_EPPRST_pin : in std_logic;
      Digilent_Usb_Epp_DB : inout std_logic_vector(7 downto 0);
      axi_hdmi_0_TMDS_RX_CLK_P_pin : in std_logic;
      axi_hdmi_0_TMDS_RX_CLK_N_pin : in std_logic;
      axi_hdmi_0_TMDS_RX_2_P_pin : in std_logic;
      axi_hdmi_0_TMDS_RX_2_N_pin : in std_logic;
      axi_hdmi_0_TMDS_RX_1_P_pin : in std_logic;
      axi_hdmi_0_TMDS_RX_1_N_pin : in std_logic;
      axi_hdmi_0_TMDS_RX_0_P_pin : in std_logic;
      axi_hdmi_0_TMDS_RX_0_N_pin : in std_logic;
      axi_hdmi_0_TMDS_TX_CLK_P_pin : out std_logic;
      axi_hdmi_0_TMDS_TX_CLK_N_pin : out std_logic;
      axi_hdmi_0_TMDS_TX_2_P_pin : out std_logic;
      axi_hdmi_0_TMDS_TX_2_N_pin : out std_logic;
      axi_hdmi_0_TMDS_TX_1_P_pin : out std_logic;
      axi_hdmi_0_TMDS_TX_1_N_pin : out std_logic;
      axi_hdmi_0_TMDS_TX_0_P_pin : out std_logic;
      axi_hdmi_0_TMDS_TX_0_N_pin : out std_logic;
      axi_iic_0_Sda_pin : inout std_logic;
      axi_iic_0_Scl_pin : inout std_logic;
      gh_player_0_FRETS_pin : out std_logic_vector(4 downto 0);
      gh_player_0_STRUM_pin : out std_logic;
      gh_player_0_WHAMMY_pin : out std_logic_vector(7 downto 0);
      gh_player_0_TILT_pin : out std_logic;
      gh_player_0_LEDS_pin : out std_logic_vector(7 downto 0)
    );
  end component;

  attribute BOX_TYPE : STRING;
  attribute BOX_TYPE of system : component is "user_black_box";

begin

  system_i : system
    port map (
      zio => zio,
      rzq => rzq,
      mcbx_dram_we_n => mcbx_dram_we_n,
      mcbx_dram_udqs_n => mcbx_dram_udqs_n,
      mcbx_dram_udqs => mcbx_dram_udqs,
      mcbx_dram_udm => mcbx_dram_udm,
      mcbx_dram_ras_n => mcbx_dram_ras_n,
      mcbx_dram_odt => mcbx_dram_odt,
      mcbx_dram_ldm => mcbx_dram_ldm,
      mcbx_dram_dqs_n => mcbx_dram_dqs_n,
      mcbx_dram_dqs => mcbx_dram_dqs,
      mcbx_dram_dq => mcbx_dram_dq,
      mcbx_dram_clk_n => mcbx_dram_clk_n,
      mcbx_dram_clk => mcbx_dram_clk,
      mcbx_dram_cke => mcbx_dram_cke,
      mcbx_dram_cas_n => mcbx_dram_cas_n,
      mcbx_dram_ba => mcbx_dram_ba,
      mcbx_dram_addr => mcbx_dram_addr,
      RS232_Uart_1_sout => RS232_Uart_1_sout,
      RS232_Uart_1_sin => RS232_Uart_1_sin,
      RESET => RESET,
      QSPI_FLASH_SS => QSPI_FLASH_SS,
      QSPI_FLASH_SCLK => QSPI_FLASH_SCLK,
      QSPI_FLASH_IO1 => QSPI_FLASH_IO1,
      QSPI_FLASH_IO0 => QSPI_FLASH_IO0,
      Push_Buttons_5Bits_TRI_I => Push_Buttons_5Bits_TRI_I,
      LEDs_8Bits_TRI_O => LEDs_8Bits_TRI_O,
      GCLK => GCLK,
      DIP_Switches_8Bits_TRI_I => DIP_Switches_8Bits_TRI_I,
      Digilent_Usb_Epp_IFCLK_pin => Digilent_Usb_Epp_IFCLK_pin,
      Digilent_Usb_Epp_STMEN_pin => Digilent_Usb_Epp_STMEN_pin,
      Digilent_Usb_Epp_FLAGA_pin => Digilent_Usb_Epp_FLAGA_pin,
      Digilent_Usb_Epp_FLAGB_pin => Digilent_Usb_Epp_FLAGB_pin,
      Digilent_Usb_Epp_FLAGC_pin => Digilent_Usb_Epp_FLAGC_pin,
      Digilent_Usb_Epp_SLRD_pin => Digilent_Usb_Epp_SLRD_pin,
      Digilent_Usb_Epp_SLWR_pin => Digilent_Usb_Epp_SLWR_pin,
      Digilent_Usb_Epp_SLOE_pin => Digilent_Usb_Epp_SLOE_pin,
      Digilent_Usb_Epp_FIFOADR_pin => Digilent_Usb_Epp_FIFOADR_pin,
      Digilent_Usb_Epp_PKTEND => Digilent_Usb_Epp_PKTEND,
      Digilent_Usb_Epp_EPPRST_pin => Digilent_Usb_Epp_EPPRST_pin,
      Digilent_Usb_Epp_DB => Digilent_Usb_Epp_DB,
      axi_hdmi_0_TMDS_RX_CLK_P_pin => axi_hdmi_0_TMDS_RX_CLK_P_pin,
      axi_hdmi_0_TMDS_RX_CLK_N_pin => axi_hdmi_0_TMDS_RX_CLK_N_pin,
      axi_hdmi_0_TMDS_RX_2_P_pin => axi_hdmi_0_TMDS_RX_2_P_pin,
      axi_hdmi_0_TMDS_RX_2_N_pin => axi_hdmi_0_TMDS_RX_2_N_pin,
      axi_hdmi_0_TMDS_RX_1_P_pin => axi_hdmi_0_TMDS_RX_1_P_pin,
      axi_hdmi_0_TMDS_RX_1_N_pin => axi_hdmi_0_TMDS_RX_1_N_pin,
      axi_hdmi_0_TMDS_RX_0_P_pin => axi_hdmi_0_TMDS_RX_0_P_pin,
      axi_hdmi_0_TMDS_RX_0_N_pin => axi_hdmi_0_TMDS_RX_0_N_pin,
      axi_hdmi_0_TMDS_TX_CLK_P_pin => axi_hdmi_0_TMDS_TX_CLK_P_pin,
      axi_hdmi_0_TMDS_TX_CLK_N_pin => axi_hdmi_0_TMDS_TX_CLK_N_pin,
      axi_hdmi_0_TMDS_TX_2_P_pin => axi_hdmi_0_TMDS_TX_2_P_pin,
      axi_hdmi_0_TMDS_TX_2_N_pin => axi_hdmi_0_TMDS_TX_2_N_pin,
      axi_hdmi_0_TMDS_TX_1_P_pin => axi_hdmi_0_TMDS_TX_1_P_pin,
      axi_hdmi_0_TMDS_TX_1_N_pin => axi_hdmi_0_TMDS_TX_1_N_pin,
      axi_hdmi_0_TMDS_TX_0_P_pin => axi_hdmi_0_TMDS_TX_0_P_pin,
      axi_hdmi_0_TMDS_TX_0_N_pin => axi_hdmi_0_TMDS_TX_0_N_pin,
      axi_iic_0_Sda_pin => axi_iic_0_Sda_pin,
      axi_iic_0_Scl_pin => axi_iic_0_Scl_pin,
      gh_player_0_FRETS_pin => gh_player_0_FRETS_pin,
      gh_player_0_STRUM_pin => gh_player_0_STRUM_pin,
      gh_player_0_WHAMMY_pin => gh_player_0_WHAMMY_pin,
      gh_player_0_TILT_pin => gh_player_0_TILT_pin,
      gh_player_0_LEDS_pin => gh_player_0_LEDS_pin
    );

end architecture STRUCTURE;

