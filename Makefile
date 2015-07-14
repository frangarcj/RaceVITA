#
# Copyright (c) 2015 Sergi Granell (xerpi)
# based on Cirne's vita-toolchain test Makefile
#

TARGET		:= RACE
HANDY := lynx
PSPAPP = race/psp
PSP_APP_NAME=RaceVITA
PSP_APP_VER=2.16

#SOURCES		:= src $(ZLIB)
SOURCES		:= race

INCLUDES	:= race


BUILD_EMUL=$(SOURCES)/cz80.o $(SOURCES)/cz80_support.o $(SOURCES)/input.o $(SOURCES)/neopopsound.o \
           $(SOURCES)/ngpBios.o $(SOURCES)/tlcs900h.o $(SOURCES)/memory.o $(SOURCES)/flash.o $(SOURCES)/graphics.o \
           $(SOURCES)/main.o $(SOURCES)/state.o $(SOURCES)/sound.o
BUILD_MZ=$(SOURCES)/ioapi.o $(SOURCES)/unzip.o
BUILD_PORT=$(PSPAPP)/main.o $(PSPAPP)/emulate.o $(PSPAPP)/menu.o


#CFILES   := $(foreach dir,$(SOURCES), $(wildcard $(dir)/*.c))
#CXXFILES   := $(foreach dir,$(SOURCES), $(wildcard $(dir)/*.cpp))
#OBJS     := $(CFILES:.c=.o) $(BUILD_APP) $(CXXFILES:.cpp=.o)

OBJS=$(BUILD_EMUL) $(BUILD_MZ) $(BUILD_PORT)

LIBS= -lpsplib -lz -lpng -lvita2d -lm_stub -lSceDisplay_stub -lSceGxm_stub 	\
	-lSceCtrl_stub -lSceAudio_stub -lSceRtc_stub -lScePower_stub -lSceAppUtil_stub

DEFINES = -DPSP -DCZ80 -DTARGET_PSP -DPSP_APP_NAME=\"$(PSP_APP_NAME)\" -DPSP_APP_VER=\"$(PSP_APP_VER)\" -D_MAX_PATH=2048 -DHOST_FPS=60



PREFIX  = arm-none-eabi
AS	= $(PREFIX)-as
CC      = $(PREFIX)-gcc
CXX			=$(PREFIX)-g++
READELF = $(PREFIX)-readelf
OBJDUMP = $(PREFIX)-objdump
CFLAGS  = -O2 -Wall -specs=psp2.specs $(DEFINES) -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -ffunction-sections
CXXFLAGS = $(CFLAGS) -mword-relocations -fno-rtti -Wno-deprecated -Wno-comment -Wno-sequence-point
ASFLAGS = $(CFLAGS) --gc-sections



all: $(TARGET).velf

$(TARGET).velf: $(TARGET).elf
	psp2-fixup -q -S $< $@

$(TARGET).elf: $(OBJS)
	$(CC) $(CFLAGS) $^ $(LIBS) -o $@

clean:
	@rm -rf $(TARGET).elf $(TARGET).velf $(OBJS) $(DATA)/*.h

copy: $(TARGET).velf
	@cp $(TARGET).velf ~/PSPSTUFF/compartido/$(TARGET).elf
