//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
//Date        : Mon Dec 13 21:03:17 2021
//Host        : CI-89 running 64-bit major release  (build 9200)
//Command     : generate_target system_wrapper.bd
//Design      : system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module system_wrapper
   (ddr3_addr,
    ddr3_ba,
    ddr3_cas_n,
    ddr3_ck_n,
    ddr3_ck_p,
    ddr3_cke,
    ddr3_cs_n,
    ddr3_dm,
    ddr3_dq,
    ddr3_dqs_n,
    ddr3_dqs_p,
    ddr3_odt,
    ddr3_ras_n,
    ddr3_reset_n,
    ddr3_we_n,
    ddr_clk_out,
    gpio0_i,
    gpio0_o,
    gpio0_t,
    gpio1_i,
    gpio1_o,
    gpio1_t,
    rx_core_clk,
    rx_data_0_n,
    rx_data_0_p,
    rx_data_1_n,
    rx_data_1_p,
    rx_ref_clk_0,
    rx_sync_0,
    rx_sysref_0,
    spi_clk_i,
    spi_clk_o,
    spi_csn_i,
    spi_csn_o,
    spi_sdi_i,
    spi_sdo_i,
    spi_sdo_o,
    sgmii_clk, // entrada de reloj de 125MHz (proveniente de la tarjeta KC705)
    sys_clk_n,
    sys_clk_p,
    sys_rst,
    uart_sin,
    uart_sout);
  output [13:0]ddr3_addr;
  output [2:0]ddr3_ba;
  output ddr3_cas_n;
  output [0:0]ddr3_ck_n;
  output [0:0]ddr3_ck_p;
  output [0:0]ddr3_cke;
  output [0:0]ddr3_cs_n;
  output [7:0]ddr3_dm;
  inout [63:0]ddr3_dq;
  inout [7:0]ddr3_dqs_n;
  inout [7:0]ddr3_dqs_p;
  output [0:0]ddr3_odt;
  output ddr3_ras_n;
  output ddr3_reset_n;
  output ddr3_we_n;
  output ddr_clk_out;
  input [31:0]gpio0_i;
  output [31:0]gpio0_o;
  output [31:0]gpio0_t;
  input [31:0]gpio1_i;
  output [31:0]gpio1_o;
  output [31:0]gpio1_t;
  output rx_core_clk;
  input rx_data_0_n;
  input rx_data_0_p;
  input rx_data_1_n;
  input rx_data_1_p;
  input rx_ref_clk_0;
  output [0:0]rx_sync_0;
  input rx_sysref_0;
  input spi_clk_i;
  output spi_clk_o;
  input [7:0]spi_csn_i;
  output [7:0]spi_csn_o;
  input spi_sdi_i;
  input spi_sdo_i;
  output spi_sdo_o;
  input sgmii_clk;
  input sys_clk_n;
  input sys_clk_p;
  input sys_rst;
  input uart_sin;
  output uart_sout;

  wire [13:0]ddr3_addr;
  wire [2:0]ddr3_ba;
  wire ddr3_cas_n;
  wire [0:0]ddr3_ck_n;
  wire [0:0]ddr3_ck_p;
  wire [0:0]ddr3_cke;
  wire [0:0]ddr3_cs_n;
  wire [7:0]ddr3_dm;
  wire [63:0]ddr3_dq;
  wire [7:0]ddr3_dqs_n;
  wire [7:0]ddr3_dqs_p;
  wire [0:0]ddr3_odt;
  wire ddr3_ras_n;
  wire ddr3_reset_n;
  wire ddr3_we_n;
  wire ddr_clk_out;
  wire [31:0]gpio0_i;
  wire [31:0]gpio0_o;
  wire [31:0]gpio0_t;
  wire [31:0]gpio1_i;
  wire [31:0]gpio1_o;
  wire [31:0]gpio1_t;
  wire rx_core_clk;
  wire rx_data_0_n;
  wire rx_data_0_p;
  wire rx_data_1_n;
  wire rx_data_1_p;
  wire rx_ref_clk_0;
  wire [0:0]rx_sync_0;
  wire rx_sysref_0;
  wire spi_clk_i;
  wire spi_clk_o;
  wire [7:0]spi_csn_i;
  wire [7:0]spi_csn_o;
  wire spi_sdi_i;
  wire spi_sdo_i;
  wire spi_sdo_o;
  wire sgmii_clk;
  wire sys_clk_n;
  wire sys_clk_p;
  wire sys_rst;
  wire uart_sin;
  wire uart_sout;

  system system_i
       (.ddr3_addr(ddr3_addr),
        .ddr3_ba(ddr3_ba),
        .ddr3_cas_n(ddr3_cas_n),
        .ddr3_ck_n(ddr3_ck_n),
        .ddr3_ck_p(ddr3_ck_p),
        .ddr3_cke(ddr3_cke),
        .ddr3_cs_n(ddr3_cs_n),
        .ddr3_dm(ddr3_dm),
        .ddr3_dq(ddr3_dq),
        .ddr3_dqs_n(ddr3_dqs_n),
        .ddr3_dqs_p(ddr3_dqs_p),
        .ddr3_odt(ddr3_odt),
        .ddr3_ras_n(ddr3_ras_n),
        .ddr3_reset_n(ddr3_reset_n),
        .ddr3_we_n(ddr3_we_n),
        .ddr_clk_out(ddr_clk_out),
        .gpio0_i(gpio0_i),
        .gpio0_o(gpio0_o),
        .gpio0_t(gpio0_t),
        .gpio1_i(gpio1_i),
        .gpio1_o(gpio1_o),
        .gpio1_t(gpio1_t),
        .rx_core_clk(rx_core_clk),
        .rx_data_0_n(rx_data_0_n),
        .rx_data_0_p(rx_data_0_p),
        .rx_data_1_n(rx_data_1_n),
        .rx_data_1_p(rx_data_1_p),
        .rx_ref_clk_0(rx_ref_clk_0),
        .rx_sync_0(rx_sync_0),
        .rx_sysref_0(rx_sysref_0),
        .spi_clk_i(spi_clk_i),
        .spi_clk_o(spi_clk_o),
        .spi_csn_i(spi_csn_i),
        .spi_csn_o(spi_csn_o),
        .spi_sdi_i(spi_sdi_i),
        .spi_sdo_i(spi_sdo_i),
        .spi_sdo_o(spi_sdo_o),
        .sgmii_clk(sgmii_clk),
        .sys_clk_n(sys_clk_n),
        .sys_clk_p(sys_clk_p),
        .sys_rst(sys_rst),
        .uart_sin(uart_sin),
        .uart_sout(uart_sout));
endmodule
