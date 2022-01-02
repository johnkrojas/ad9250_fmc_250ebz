################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/drivers/axi_core/clk_axi_clkgen/clk_axi_clkgen.c 

OBJS += \
./src/drivers/axi_core/clk_axi_clkgen/clk_axi_clkgen.o 

C_DEPS += \
./src/drivers/axi_core/clk_axi_clkgen/clk_axi_clkgen.d 


# Each subdirectory must supply rules for building sources it contributes
src/drivers/axi_core/clk_axi_clkgen/%.o: ../src/drivers/axi_core/clk_axi_clkgen/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: MicroBlaze gcc compiler'
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -I../../test_ad9250_bsp/sys_mb/include -mlittle-endian -mxl-barrel-shift -mxl-pattern-compare -mno-xl-soft-div -mcpu=v11.0 -mno-xl-soft-mul -mxl-multiply-high -Wl,--no-relax -ffunction-sections -fdata-sections -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


