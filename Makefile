ASSEMBLER = nasm
CFLAGS = -f bin
SRC_DIR = src
BUILD_DIR = build
SOURCE = $(wildcard $(SRC_DIR)/*.asm)
OUTPUT = $(BUILD_DIR)/snake_os.bin
VM_EXEC = qemu-system-x86_64

all: $(OUTPUT)

$(OUTPUT): $(SOURCE)
	@mkdir -p $(BUILD_DIR)
	@echo "Compiling..."
	@$(ASSEMBLER) $(CFLAGS) -o $@ $^
	@echo "Compile complete!"

run:
	@make all
	@echo "Executing..."
	@$(VM_EXEC) $(OUTPUT)

clean:
	@echo "Cleaning..."
	@rm -f $(OUTPUT)
	@echo "Build successfuly cleaned!"
