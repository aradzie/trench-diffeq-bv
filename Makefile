SOURCE_DIR := book
BUILD_DIR := build
TEXLIVE := $(CURDIR)/texlive.sh
export SOURCE_DATE_EPOCH := 0
SOURCES := $(wildcard $(SOURCE_DIR)/*.tex) \
           $(wildcard $(SOURCE_DIR)/figures/*) \
           $(wildcard $(SOURCE_DIR)/chapters/*/*.tex)

.PHONY: all book clean

all: book
book: $(BUILD_DIR)/TRENCH_DIFFEQ_BV.pdf

$(BUILD_DIR)/%.pdf: $(SOURCE_DIR)/%.tex $(SOURCES) texlive.sh
	mkdir -p $(BUILD_DIR)
	cd $(SOURCE_DIR) && $(TEXLIVE) env SOURCE_DATE_EPOCH=$(SOURCE_DATE_EPOCH) latexmk -pdfps -interaction=nonstopmode -halt-on-error -file-line-error -outdir=../$(BUILD_DIR) $*.tex

clean:
	rm -rf $(BUILD_DIR)
