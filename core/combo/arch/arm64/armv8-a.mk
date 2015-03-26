# Configuration for Linux on ARM.
# Generating binaries for the ARMv8-a architecture
#
ifneq (,$(filter denver64,$(TARGET_CPU_VARIANT)))

ARCH_ARM_HAVE_NEON := true

arch_variant_cflags := \
    -mcpu=cortex-a57 \
    -march=armv8-a

endif
