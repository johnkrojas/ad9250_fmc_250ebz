################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/drivers/spi/spi.c 

OBJS += \
./src/drivers/spi/spi.o 

C_DEPS += \
./src/drivers/spi/spi.d 


# Each subdirectory must supply rules for building sources it contributes
src/drivers/spi/%.o: ../src/drivers/spi/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: MicroBlaze gcc compiler'
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -I../../test_ad9250_bsp/sys_mb/include -mlittle-endian -mxl-barrel-shift -mxl-pattern-compare -mno-xl-soft-div -mcpu=v11.0 -mno-xl-soft-mul -mxl-multiply-high -Wl,--no-relax -ffunction-sections -fdata-sections -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


