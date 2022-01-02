# aclk {FREQ_HZ 200000000 CLK_DOMAIN system_axi_ddr_cntrl_0_ui_clk PHASE 0} aclk1 {FREQ_HZ 100000000 CLK_DOMAIN system_axi_ddr_cntrl_0_ui_clk PHASE 0}
# Clock Domain: system_axi_ddr_cntrl_0_ui_clk
create_clock -name aclk -period 5.000 [get_ports aclk]
# Generated clocks
create_generated_clock -name aclk1 -source [get_ports aclk] -divide_by 2 [get_ports aclk1]
