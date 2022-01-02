################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include src/util/subdir.mk
-include src/drivers/spi/subdir.mk
-include src/drivers/platform/xilinx/subdir.mk
-include src/drivers/io-expander/demux_spi/subdir.mk
-include src/drivers/frequency/ad9517/subdir.mk
-include src/drivers/axi_core/jesd204/subdir.mk
-include src/drivers/axi_core/clk_axi_clkgen/subdir.mk
-include src/drivers/axi_core/axi_dmac/subdir.mk
-include src/drivers/axi_core/axi_adc_core/subdir.mk
-include src/drivers/adc/ad9250/subdir.mk
-include src/subdir.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
ELFSIZE += \
test_ad9250.elf.size \


# All Target
all: test_ad9250.elf secondary-outputs

# Tool invocations
test_ad9250.elf: $(OBJS) ../src/lscript.ld $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: MicroBlaze gcc linker'
	mb-gcc -Wl,-T -Wl,../src/lscript.ld -L../../test_ad9250_bsp/sys_mb/lib -mlittle-endian -mxl-barrel-shift -mxl-pattern-compare -mno-xl-soft-div -mcpu=v11.0 -mno-xl-soft-mul -mxl-multiply-high -Wl,--no-relax -Wl,--gc-sections -o "test_ad9250.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '

test_ad9250.elf.size: test_ad9250.elf
	@echo 'Invoking: MicroBlaze Print Size'
	mb-size test_ad9250.elf  |tee "test_ad9250.elf.size"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(EXECUTABLES)$(OBJS)$(S_UPPER_DEPS)$(C_DEPS)$(ELFSIZE) test_ad9250.elf
	-@echo ' '

secondary-outputs: $(ELFSIZE)

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
