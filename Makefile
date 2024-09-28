# ============================
# Flags
# ============================

DEBUG     = -ggdb
OPTIMISE  = -O0
TARGET 	  = -m elf_i386  # 32-bit target
WARNINGS  = -Wall -Werror -Wextra -ansi -pedantic
CFLAGS    = $(DEBUG) $(OPTIMISE) $(WARNINGS) $(TARGET)
ASMFLAGS  = -f elf32

# Dirs
LIBS_DIR = $(HOME)/Projects_WSL/ASM_Libs

# Raylib libraries
RAYLIB_INC = -I$(LIBS_DIR)/include       # Include path for Raylib
RAYLIB_LIB = -L$(LIBS_DIR)/lib -lraylib  # Corrected library linking

# Raylib and its dependencies
RAYLIB_DEPS = -L/usr/lib/i386-linux-gnu -lGL -lm -lpthread -ldl -lrt -lX11

# ============================
# Commands
# ============================

ASM       = nasm
CC		  = gcc
LD        = ld
RM        = rm -f
ASSEM     = $(ASM) $(ASMFLAGS)
LINK      = $(LD) $(TARGET) --dynamic-linker /lib/ld-linux.so.2  # Specify the correct dynamic linker

# ============================
# Directories
# ============================

SRC_DIR   = src
OBJ_DIR   = bin-int
BIN_DIR   = bin

# ============================
# Files
# ============================

ASM_SRCS  = main  # Add other assembly sources if needed
ASM_OBJS  = $(addsuffix .o, $(ASM_SRCS))
EXECUTABLES = $(addprefix $(BIN_DIR)/, $(ASM_SRCS))

# ============================
# Phony Targets
# ============================

.PHONY: all clean run directories

# ============================
# Default Target
# ============================

all: directories $(EXECUTABLES)

# ============================
# Executable Linking
# ============================

$(BIN_DIR)/%: $(OBJ_DIR)/%.o
	$(LINK) $< -o $@ $(RAYLIB_LIB) $(RAYLIB_DEPS)

# ============================
# Assembly
# ============================

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.asm
	$(ASSEM) $< -o $@

# ============================
# Directory Creation
# ============================

directories:
	@mkdir -p $(OBJ_DIR) $(BIN_DIR)

# ============================
# Clean Target
# ============================

clean:
	$(RM) $(OBJ_DIR)/*.o $(BIN_DIR)/*
	@echo "Cleaned up intermediate and executable files."

# ============================
# Run Target
# ============================

run: all
	@echo "Running executables:"
	@for exe in $(EXECUTABLES); do \
		echo "---- $$exe ----"; \
		./$$exe; \
	done

# ============================
# End of Makefile
# ============================
