TEX = pdflatex
AUTHOR = jan-kvapil
TARGET = square-crypt-project-plan-$(AUTHOR)

BUILD_DIR = build
SRC_DIR = src

FLAGS = --output-directory="$(BUILD_DIR)" \
	--jobname="$(TARGET)" \
	--shell-escape

all: plan

plan:
	$(TEX) $(FLAGS) $(SRC_DIR)/main.tex

plan-release: clean
	$(TEX) $(FLAGS) $(SRC_DIR)/main.tex

build: clean plan

.PHONY: clean build
clean-all: clean

clean:
	-rm -rf $(BUILD_DIR)
	mkdir $(BUILD_DIR)
