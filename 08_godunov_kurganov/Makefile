#
# Makefile for building and testing a fortran program
# ----------------------------------
#
# Build executable build/main:
#
# 	$ make
#
# Build unit tests executable build/test:
#
# 	$ make test
#
# Remove build files:
#
# 	$ make clean
#
# This Makefile is based on https://stackoverflow.com/a/30142139/297131
#

# Fortran compiler
FC=gfortran
# FC=ifort

# Compiler flags for gfortran
FFLAGS=-J$(@D) -Wall -Wextra -g

# Compiler flags for ifort
# FFLAGS=-module $(@D) -no-wrap-margin

# Libraries to link
# Example: -lm /opt/OpenBLAS/lib/libopenblas.a -lpthread
LINKER_FLAGS =

# Additional directories containing *.h files
# Example: -I/opt/OpenBLAS/include
HEADER_DIRS =

# Binary file name to build
BIN = main

# Put all auto generated stuff to this build dir.
BUILD_DIR = ./build

# List of all .f90 source files.
SOURCE_FILES = 	types.f90 \
							string.f90 \
							constants.f90 \
							asserts_test.f90 \
							float_utils.f90 \
							float_utils_test.f90 \
							string_test.f90 \
							file_utils.f90 \
							file_utils_test.f90 \
							command_line_args.f90 \
							command_line_args_test.f90 \
							settings.f90 \
							settings_test.f90 \
							output.f90 \
							output_test.f90 \
							physics.f90 \
							interface_flux.f90 \
							grid.f90 \
							grid_test.f90 \
							initial_conditions.f90 \
							initial_conditions_test.f90 \
							step.f90 \
							step_test.f90 \
							equation.f90 \
							equation_test.f90 \
							main.f90 \
							main_test.f90

# Add the 'src' subdirectory prefix to all file names
FFILES_ALL=$(patsubst %, src/%, $(SOURCE_FILES))

# List all *.f90 files excluding tests
FFILES = $(filter-out %_test.f90, $(FFILES_ALL))

# List all unit test .f90 files
FTESTS = $(filter-out %main.f90, $(FFILES_ALL))

ifeq ($(MAKECMDGOALS), test)
# Build tests
  CFILES_TO_BUILD=$(FTESTS)
  BIN = test
else
# Build the program
  CFILES_TO_BUILD=$(FFILES)
endif

# All .o files go to build dir.
OBJ = $(CFILES_TO_BUILD:%.f90=$(BUILD_DIR)/%.o)

# Default target named after the binary.
$(BIN) : $(BUILD_DIR)/$(BIN)

# Actual target of the binary - depends on all .o files.
$(BUILD_DIR)/$(BIN) : $(OBJ)
# Create build directories - same structure as sources.
	mkdir -p $(@D)
# Link all the object files and make the executable.
	$(FC) $(FFLAGS) $^ -o $@ $(LINKER_FLAGS)


# Build target for every single object file.
# The potential dependency on header files is covered
# by calling `-include $(DEP)`.
$(BUILD_DIR)/%.o : %.f90
	mkdir -p $(@D)
# Complile *.f90 files into the object files.
	$(FC) $(FFLAGS) $(HEADER_DIRS) -cpp -c $< -o $@

.PHONY : clean

clean :
# This should remove all generated files.
	-rm -rf $(BUILD_DIR)