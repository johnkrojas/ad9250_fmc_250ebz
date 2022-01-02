// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module system_top (

  input                   sys_rst,
  input                   sys_clk_p,
  input                   sys_clk_n,

  //input                    sgmii_clk_p,
  //input                    sgmii_clk_n,

  input                   uart_sin,
  output                  uart_sout,

  output      [ 2:0]      ddr3_1_n,
  output      [ 1:0]      ddr3_1_p,
  output                  ddr3_reset_n,
  output      [13:0]      ddr3_addr,
  output      [ 2:0]      ddr3_ba,
  output                  ddr3_cas_n,
  output                  ddr3_ras_n,
  output                  ddr3_we_n,
  output      [ 0:0]      ddr3_ck_n,
  output      [ 0:0]      ddr3_ck_p,
  output      [ 0:0]      ddr3_cke,
  output      [ 0:0]      ddr3_cs_n,
  output      [ 7:0]      ddr3_dm,
  inout       [63:0]      ddr3_dq,
  inout       [ 7:0]      ddr3_dqs_n,
  inout       [ 7:0]      ddr3_dqs_p,
  output      [ 0:0]      ddr3_odt,

  output                  fan_pwm,

  inout       [16:0]      gpio_bd,

  input                   rx_ref_clk_p,
  input                   rx_ref_clk_n,
  //output                  rx_sysref,
  output                  rx_sysref_p,
  output                  rx_sysref_n,
  //output                  rx_sync,
  output                  rx_sync_p,
  output                  rx_sync_n,
  input       [ 1:0]      rx_data_p,
  input       [ 1:0]      rx_data_n,

  output                  spi_csn_0,
  output                  spi_clk,
  inout                   spi_sdio,
  output                  spi_csn_out,
  output                  spi_clk_out,
  output                  spi_sdio_out);

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;
  wire    [ 7:0]  spi_csn_reg;
  wire          spi_clk_reg;
  wire            spi_mosi;
  wire            spi_miso;
  wire            rx_ref_clk;
  wire            rx_clk;
  wire            rx_sysref;
  wire            rx_sync;
  wire          ddr_clk_out;
  wire          sgmii_clk;

  assign ddr3_1_p = 2'b11;
  assign ddr3_1_n = 3'b000;
  assign fan_pwm = 1'b1;
  
  // salidas para depuracion
  assign spi_csn_out = rx_sysref; //spi_csn_0;
  assign spi_clk_out = ddr_clk_out;//rx_sync; //spi_clk;
  assign spi_sdio_out = sgmii_clk;//rx_clk; //gpio_o[32]; //spi_sdio;

  // instantiations
  
   /*IBUFDS_GTE2 i_ibufds_sgmii_clk (
    .CEB (1'd0),
    .I (sgmii_clk_p),
    .IB (sgmii_clk_n),
    .O (sgmii_clk),
    .ODIV2 ());*/

  IBUFDS_GTE2 i_ibufds_rx_ref_clk (
    .CEB (1'd0),
    .I (rx_ref_clk_p),
    .IB (rx_ref_clk_n),
    .O (rx_ref_clk),
    .ODIV2 (sgmii_clk));//.ODIV2 ());

  ad_iobuf #(.DATA_WIDTH(17)) i_iobuf (
    .dio_t (gpio_t[16:0]),
    .dio_i (gpio_o[16:0]),
    .dio_o (gpio_i[16:0]),
    .dio_p (gpio_bd));

  assign gpio_i[63:32] = gpio_o[63:32];
  assign gpio_i[31:17] = gpio_o[31:17];

  fmcjesdadc1_spi i_fmcjesdadc1_spi (
    .spi_csn_i (spi_csn_reg[0]),
    .spi_clk_i (spi_clk_reg),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_csn_o (spi_csn_0),
    .spi_clk_o (spi_clk),
    .spi_sdio (spi_sdio));

  ad_sysref_gen #(.SYSREF_PERIOD(64)) i_sysref (
    .core_clk (rx_clk),
    .sysref_en (gpio_o[32]),
    .sysref_out (rx_sysref));
    
  OBUFDS_LVDS_25 i_ad_sysref_lvds ( .I(rx_sysref),
    .O(rx_sysref_p),
    .OB(rx_sysref_n)
    );
    
  OBUFDS_LVDS_25 i_ad_sync_lvds ( .I(rx_sync),
    .O(rx_sync_p),
    .OB(rx_sync_n)
   );

  // instantiations

  system_wrapper i_system_wrapper (
    .ddr3_addr (ddr3_addr),
    .ddr3_ba (ddr3_ba),
    .ddr3_cas_n (ddr3_cas_n),
    .ddr3_ck_n (ddr3_ck_n),
    .ddr3_ck_p (ddr3_ck_p),
    .ddr3_cke (ddr3_cke),
    .ddr3_cs_n (ddr3_cs_n),
    .ddr3_dm (ddr3_dm),
    .ddr3_dq (ddr3_dq),
    .ddr3_dqs_n (ddr3_dqs_n),
    .ddr3_dqs_p (ddr3_dqs_p),
    .ddr3_odt (ddr3_odt),
    .ddr3_ras_n (ddr3_ras_n),
    .ddr3_reset_n (ddr3_reset_n),
    .ddr3_we_n (ddr3_we_n),
    .ddr_clk_out(ddr_clk_out),
    .gpio0_i (gpio_i[31:0]),
    .gpio0_o (gpio_o[31:0]),
    .gpio0_t (gpio_t[31:0]),
    .gpio1_i (gpio_i[63:32]),
    .gpio1_o (gpio_o[63:32]),
    .gpio1_t (gpio_t[63:32]),
    .sgmii_clk (sgmii_clk),
    .sys_clk_n (sys_clk_n),
    .sys_clk_p (sys_clk_p),
    .sys_rst (sys_rst),
    .uart_sin (uart_sin),
    .uart_sout (uart_sout),
    .rx_data_0_n (rx_data_n[0]),
    .rx_data_0_p (rx_data_p[0]),
    .rx_data_1_n (rx_data_n[1]),
    .rx_data_1_p (rx_data_p[1]),
    .rx_ref_clk_0 (rx_ref_clk),
    .rx_sync_0 (rx_sync),
    .rx_sysref_0 (rx_sysref),
    .rx_core_clk (rx_clk),
    .spi_clk_i (spi_clk_reg),
    .spi_clk_o (spi_clk_reg),
    .spi_csn_i (spi_csn_reg),
    .spi_csn_o (spi_csn_reg),
    .spi_sdi_i (spi_miso),
    .spi_sdo_i (spi_mosi),
    .spi_sdo_o (spi_mosi));

endmodule

// ***************************************************************************
// ***************************************************************************
