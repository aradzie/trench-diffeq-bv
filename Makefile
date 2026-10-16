SOURCE_DIR := book
BUILD_DIR := build
TEXLIVE := $(CURDIR)/texlive.sh
export SOURCE_DATE_EPOCH := 0
CHAPTER_NUMBERS := 01 02 03 04 05 06 07 08 09 10 11 12 13
CHAPTER_PDFS := $(addprefix $(BUILD_DIR)/chapters/,$(addsuffix .pdf,$(CHAPTER_NUMBERS)))
SOURCES := $(wildcard $(SOURCE_DIR)/*.tex) \
           $(wildcard $(SOURCE_DIR)/figures/*) \
           $(wildcard $(SOURCE_DIR)/chapters/*/*.tex)

.PHONY: all book chapters clean

all: book chapters
book: $(BUILD_DIR)/TRENCH_DIFFEQ_BV.pdf
chapters: $(CHAPTER_PDFS)

$(BUILD_DIR)/%.pdf: $(SOURCE_DIR)/%.tex $(SOURCES) texlive.sh
	mkdir -p $(BUILD_DIR)
	cd $(SOURCE_DIR) && $(TEXLIVE) env SOURCE_DATE_EPOCH=$(SOURCE_DATE_EPOCH) latexmk -pdfps -interaction=nonstopmode -halt-on-error -file-line-error -outdir=../$(BUILD_DIR) $*.tex

$(CHAPTER_PDFS) &: $(BUILD_DIR)/TRENCH_DIFFEQ_BV.pdf scripts/split-chapter-pdfs.py texlive.sh
	python3 scripts/split-chapter-pdfs.py $< $(BUILD_DIR)/chapters

clean:
	rm -rf $(BUILD_DIR)
