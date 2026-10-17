SPHINX = .venv/bin/sphinx-build
SRC = docs
OUT = docs/_build

.PHONY: html pdf keywords clean

html:
	$(SPHINX) -W --keep-going -b html $(SRC) $(OUT)/html

pdf:
	$(SPHINX) -W --keep-going -b latex $(SRC) $(OUT)/latex
	$(MAKE) -C $(OUT)/latex all-pdf

keywords:
	.venv/bin/python docs/_ext/priroda_keywords.py

clean:
	rm -rf $(OUT)
