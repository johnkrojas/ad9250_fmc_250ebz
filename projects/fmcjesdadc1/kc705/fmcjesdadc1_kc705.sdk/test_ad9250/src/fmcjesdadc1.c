/***************************************************************************//**
 *   @file   fmcjesdadc1.c
 *   @brief  Implementation of Main Function.
 *   @author DBogdan (dragos.bogdan@analog.com)
 *   @author Antoniu Miclaus(antoniu.miclaus@analog.com)
********************************************************************************
 * Copyright 2014(c) Analog Devices, Inc.
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *  - Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  - Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *  - Neither the name of Analog Devices, Inc. nor the names of its
 *    contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *  - The use of this software may or may not infringe the patent rights
 *    of one or more patent holders.  This license does not release you
 *    from the requirement that you obtain separate licenses from these
 *    patent holders to use this software.
 *  - Use of the software either in source or binary form, must be run
 *    on or directly connected to an Analog Devices Inc. component.
 *
 * THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT,
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, INTELLECTUAL PROPERTY RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*******************************************************************************/

/******************************************************************************/
/***************************** Include Files **********************************/
/******************************************************************************/
#include <stdio.h>
#include <inttypes.h>
//#include "drivers/frequency/ad9517/ad9517.h"
#include "drivers/adc/ad9250/ad9250.h"
#include "parameters.h"
#include <xparameters.h>
#include <xil_printf.h>
#include <xil_cache.h>
#include "drivers/axi_core/jesd204/axi_adxcvr.h"
#include "include/spi.h"
#include "include/gpio.h"
#include "drivers/platform/xilinx/spi_extra.h"
#include "drivers/platform/xilinx/gpio_extra.h"
#include "include/delay.h"
#include "include/error.h"
#include "drivers/axi_core/axi_adc_core/axi_adc_core.h"
#include "drivers/axi_core/axi_dmac/axi_dmac.h"
#include "drivers/axi_core/jesd204/axi_jesd204_rx.h"
#include "drivers/io-expander/demux_spi/demux_spi.h"

#ifdef IIO_SUPPORT
#include "iio_app.h"
#include "iio_axi_adc.h"
#endif

/***************************************************************************//**
* @brief main
*******************************************************************************/
int main(void)
{
	int32_t status;

	// SPI configuration
	struct spi_init_param demux_spi_param = {
		.max_speed_hz = 2000000u,
		.chip_select = 0,
		.mode = SPI_MODE_0,
		.platform_ops = &xil_spi_ops
	};

	struct spi_init_param ad9250_0_spi_param = {
		.device_id = SPI_DEVICE_ID,
		.max_speed_hz = demux_spi_param.max_speed_hz,
		.chip_select = 0,
		.mode = demux_spi_param.mode,
		.platform_ops = &demux_spi_platform_ops
	};

	struct xil_spi_init_param xil_spi_param = {
#ifdef PLATFORM_MB
		.type = SPI_PL,
#else
		.type = SPI_PS,
#endif
	};

	demux_spi_param.extra = &xil_spi_param;
	ad9250_0_spi_param.extra = &demux_spi_param;

	struct gpio_init_param gpio_sysref_param = {
		.number = GPIO_JESD204_SYSREF,
		.platform_ops = &xil_gpio_ops
	};

	struct xil_gpio_init_param xil_gpio_param = {
#ifdef PLATFORM_MB
		.type = GPIO_PL,
#else
		.type = GPIO_PS,
#endif
		.device_id = GPIO_DEVICE_ID
	};
	gpio_sysref_param.extra = &xil_gpio_param;

	gpio_desc *gpio_sysref;

	struct adxcvr_init ad9250_xcvr_param = {
		.name = "ad9250_xcvr",
		.base = RX_XCVR_BASEADDR,
		.sys_clk_sel = 0,
		.out_clk_sel = 2,
		.lpm_enable = 0,
		.cpll_enable = 1,
		.ref_rate_khz = 245760,
		.lane_rate_khz = 4915200,
	};
	struct adxcvr *ad9250_xcvr;

	struct jesd204_rx_init  ad9250_jesd_param = {
		.name = "ad9250_jesd",
		.base = RX_JESD_BASEADDR,
		.octets_per_frame = 2,
		.frames_per_multiframe = 32,
		.subclass = 1,
		.device_clk_khz = 4915200 / 40,
		.lane_clk_khz = 4915200,
	};
	struct axi_jesd204_rx *ad9250_jesd;

	struct axi_adc_init ad9250_core_param = {
		.name = "ad9250_adc",
		.base = RX_CORE_BASEADDR,
		.num_channels = 2
	};
	struct axi_adc	*ad9250_core;

	struct axi_dmac_init ad9250_dmac_param = {
		.name = "ad9250_dmac",
		.base = RX_DMA_BASEADDR,
		.direction = DMA_DEV_TO_MEM,
		.flags = 1//0
	};
	struct axi_dmac *ad9250_dmac;

	struct ad9250_platform_data ad9250_pdata_lpc = {
		.extrn_pdwnmode = 0,
		.en_clk_dcs = 1,
		.clk_selection = 0,
		.clk_div_ratio = 0,
		.clk_div_phase = 0,
		.adc_vref = 23, //15,
		.pll_low_encode = 0,
		.name = "ad9250-lpc"
	};

	struct ad9250_jesd204b_cfg ad9250_0_jesd204b_interface = {
		.jtx_in_standby = 0,
		.cml_level = 3,
		.quick_cfg_option = 0x22,
		.subclass = 1,
		.ctrl_bits_no = 0,
		.ctrl_bits_assign = 0,
		.tail_bits_mode = 0,
		.did = 0xF0,
		.bid = 0x00,
		.lid0 = 0x00,
		.lid1 = 0x01,
		.k = 32,
		.scrambling = 1,
		.ilas_mode = 1,
		.invert_logic_bits = 0,
		.en_ilas_test = 0,
		.en_sys_ref = 1,
		.en_sync_in_b = 1,
		.sys_ref_mode = 0,
		.align_sync_in_b = 1,
		.align_sys_ref = 0,
		.lane0_assign = 0,
		.lane1_assign = 1,
	};

	struct ad9250_fast_detect_cfg ad9250_fast_detect = {
		.en_fd = 0,
		.pin_function = 0,
		.force_pins = 0,
		.pin_force_value = 0,
		.fd_upper_tresh = 0,
		.fd_lower_tresh = 0,
		.df_dwell_time = 0,
	};

	struct ad9250_dev		*ad9250_0_device;
	struct ad9250_init_param	ad9250_0_param;

	ad9250_0_param.ad9250_st_init.pdata = &ad9250_pdata_lpc;
	ad9250_0_param.ad9250_st_init.p_jesd204b = &ad9250_0_jesd204b_interface;
	ad9250_0_param.ad9250_st_init.p_fd = &ad9250_fast_detect;


	// SPI configuration
	ad9250_0_param.spi_init = ad9250_0_spi_param;

	// setup GPIOs
	gpio_get(&gpio_sysref,  &gpio_sysref_param);
	gpio_direction_output(gpio_sysref,  1);
	mdelay(10);

	printf("Inicio \n\r");
	fflush(stdout);

	// set up the devices
	status= ad9250_setup(&ad9250_0_device, ad9250_0_param);
	if(status< 0){
		printf("Error ad9250_0_setup()\n");
	}

	// set up the XCVR core
	status = adxcvr_init(&ad9250_xcvr, &ad9250_xcvr_param);
	if (status != SUCCESS) {
		printf("error: %s: adxcvr_init() failed\n", ad9250_xcvr->name);
	}
	status = adxcvr_clk_enable(ad9250_xcvr);
	if (status != SUCCESS) {
		printf("error: %s: adxcvr_clk_enable() failed\n", ad9250_xcvr->name);
	}

	// setup JESD core
	status = axi_jesd204_rx_init(&ad9250_jesd, &ad9250_jesd_param);
	if (status != SUCCESS) {
		printf("error: %s: axi_jesd204_rx_init() failed\n", ad9250_jesd->name);
	}
	status = axi_jesd204_rx_lane_clk_enable(ad9250_jesd);
	if (status != SUCCESS) {
		printf("error: %s: axi_jesd204_tx_lane_clk_enable() failed\n",
		       ad9250_jesd->name);
	}

	// interface core setup
	status = axi_adc_init(&ad9250_core,  &ad9250_core_param);
	if (status != SUCCESS) {
		printf("axi_adc_init() error: %s\n", ad9250_core->name);
	}

	// JESD core status
	status = axi_jesd204_rx_status_read(ad9250_jesd);
	if (status != SUCCESS) {
		printf("axi_jesd204_rx_status_read() error: %"PRIi32"\n", status);
	}

	//ADC output_format
	ad9250_output_format(ad9250_0_device, AD9250_OUT_OFFSET_BINARY);
	printf("ad9250_output_format 0\n");

	// PRBS test
	ad9250_test_mode(ad9250_0_device, AD9250_TEST_PNLONG);
	ad9250_transfer(ad9250_0_device);

	if(axi_adc_pn_mon(ad9250_core, AXI_ADC_PN23, 10) == -1) {
		printf("%s ad9250 - PN23 sequence mismatch!\n", __func__);
	};

	// set up ramp output
	//ad9250_test_mode(ad9250_0_device, AD9250_TEST_RAMP);
	ad9250_test_mode(ad9250_0_device, AD9250_TEST_OFF);
	ad9250_transfer(ad9250_0_device);

	// test the captured data
	axi_dmac_init(&ad9250_dmac, &ad9250_dmac_param);
	axi_dmac_transfer(ad9250_dmac, ADC_DDR_BASEADDR, 16384 * 4);
	Xil_DCacheFlush();

	// set up normal output
	/*ad9250_test_mode(ad9250_0_device, AD9250_TEST_OFF);
	ad9250_transfer(ad9250_0_device);*/

	// capture data with DMA
	/*axi_dmac_transfer(ad9250_dmac, ADC_DDR_BASEADDR, 16384 * 4);
	Xil_DCacheFlush();*/

#ifdef IIO_SUPPORT
	printf("The board accepts libiio clients connections through the serial backend.\n");

	struct iio_axi_adc_desc *iio_axi_adc_desc;
	struct iio_device *adc_dev_desc;

	struct iio_axi_adc_init_param iio_axi_adc_init_par = {
		.rx_adc = ad9250_core,
		.rx_dmac = ad9250_dmac,
#ifndef PLATFORM_MB
		.dcache_invalidate_range = (void (*)(uint32_t,
						     uint32_t))Xil_DCacheInvalidateRange
#endif
	};

	status = iio_axi_adc_init(&iio_axi_adc_desc, &iio_axi_adc_init_par);
	if (status < 0)
		return status;

	iio_axi_adc_get_dev_descriptor(iio_axi_adc_desc, &adc_dev_desc);

	struct iio_data_buffer g_read_buff = {
		.buff = (void *)ADC_DDR_BASEADDR,
		.size = 0xFFFFFFFF,
	};

	struct iio_app_device devices[] = {
		IIO_APP_DEVICE("axi_adc", iio_axi_adc_desc, adc_dev_desc,
			       &g_read_buff, NULL),
	};

	return iio_app_run(devices, ARRAY_SIZE(devices));

#endif

	printf("adc1: setup and configuration is done\n");

	ad9250_remove(ad9250_0_device);
	gpio_remove(gpio_sysref);

	return SUCCESS;
}
