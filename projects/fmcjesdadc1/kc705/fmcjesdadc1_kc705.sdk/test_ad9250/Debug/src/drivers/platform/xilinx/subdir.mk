################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/drivers/platform/xilinx/axi_io.c \
../src/drivers/platform/xilinx/delay.c \
../src/drivers/platform/xilinx/gpio.c \
../src/drivers/platform/xilinx/xilinx_gpio.c \
../src/drivers/platform/xilinx/xilinx_spi.c 

OBJS += \
./src/drivers/platform/xilinx/axi_io.o \
./src/drivers/platform/xilinx/delay.o \
./src/drivers/platform/xilinx/gpio.o \
./src/drivers/platform/xilinx/xilinx_gpio.o \
./src/drivers/platform/xilinx/xilinx_spi.o 

C_DEPS += \
./src/drivers/platform/xilinx/axi_io.d \
./src/drivers/platform/xilinx/delay.d \
./src/drivers/platform/xilinx/gpio.d \
./src/drivers/platform/xilinx/xilinx_gpio.d \
./src/drivers/platform/xilinx/xilinx_spi.d 


# Each subdirectory must supply rules for building sources it contributes
src/drivers/platform/xilinx/%.o: ../src/drivers/platform/xilinx/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: MicroBlaze gcc compiler'
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -I../../test_ad9250_bsp/sys_mb/include -mlittle-endian -mxl-barrel-shift -mxl-pattern-compare -mno-xl-soft-div -mcpu=v11.0 -mno-xl-soft-mul -mxl-multiply-high -Wl,--no-relax -ffunction-sections -fdata-sections -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


