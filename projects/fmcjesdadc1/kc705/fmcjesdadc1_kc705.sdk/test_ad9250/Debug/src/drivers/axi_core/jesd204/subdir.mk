################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/drivers/axi_core/jesd204/axi_adxcvr.c \
../src/drivers/axi_core/jesd204/axi_jesd204_rx.c \
../src/drivers/axi_core/jesd204/xilinx_transceiver.c 

OBJS += \
./src/drivers/axi_core/jesd204/axi_adxcvr.o \
./src/drivers/axi_core/jesd204/axi_jesd204_rx.o \
./src/drivers/axi_core/jesd204/xilinx_transceiver.o 

C_DEPS += \
./src/drivers/axi_core/jesd204/axi_adxcvr.d \
./src/drivers/axi_core/jesd204/axi_jesd204_rx.d \
./src/drivers/axi_core/jesd204/xilinx_transceiver.d 


# Each subdirectory must supply rules for building sources it contributes
src/drivers/axi_core/jesd204/%.o: ../src/drivers/axi_core/jesd204/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: MicroBlaze gcc compiler'
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -I../../test_ad9250_bsp/sys_mb/include -mlittle-endian -mxl-barrel-shift -mxl-pattern-compare -mno-xl-soft-div -mcpu=v11.0 -mno-xl-soft-mul -mxl-multiply-high -Wl,--no-relax -ffunction-sections -fdata-sections -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


