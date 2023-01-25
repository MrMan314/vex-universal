# VEXcode makefile 2019_03_26_01

# show compiler output
VERBOSE = 0
TOOLCHAIN = $(CURDIR)/sdk
SLOT = 1

# include toolchain options
include vex/mkenv.mk

# location of the project source cpp and c files
SRC_C  = $(wildcard src/*.cpp) 
SRC_C += $(wildcard src/*.c)
SRC_C += $(wildcard src/*/*.cpp) 
SRC_C += $(wildcard src/*/*.c)

OBJ = $(addprefix $(BUILD)/, $(addsuffix .o, $(basename $(SRC_C))) )

# location of include files that c and cpp files depend on
SRC_H  = $(wildcard include/*.h)

# additional dependancies
SRC_A  = makefile

# project header file locations
INC_F  = include

# upload and run
uprun: upload run

# build targets
all: $(BUILD)/$(PROJECT).bin

# include build rules
include vex/mkrules.mk

# upload
upload: $(BUILD)/$(PROJECT).bin
	pros upload --target v5 $< --slot $(SLOT)

# run, upload first
run:
	pros v5 run $(SLOT)

# stop
stop:
	pros v5 stop
