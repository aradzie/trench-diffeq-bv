SOURCE_DIR := book
BUILD_DIR := build
TEXLIVE := $(CURDIR)/texlive.sh
SOURCES := $(wildcard $(SOURCE_DIR)/*.tex) $(SOURCE_DIR)/wtrench.sty $(wildcard $(SOURCE_DIR)/EPS/*)

.PHONY: all book clean

all: book
book: $(BUILD_DIR)/TRENCH_DIFFEQ_BV.pdf

$(BUILD_DIR)/%.pdf: $(SOURCE_DIR)/%.tex $(SOURCES) texlive.sh
	mkdir -p $(BUILD_DIR)
	cd $(SOURCE_DIR) && $(TEXLIVE) latexmk -pdfps -interaction=nonstopmode -halt-on-error -file-line-error -outdir=../$(BUILD_DIR) $*.tex

clean:
	rm -rf $(BUILD_DIR)
