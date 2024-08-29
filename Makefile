AWK=awk
HUGO=hugo

.PHONY: build
build:
	$(HUGO)
	make public/*.html
	make public/**/*.html

public/%.html: .FORCE
	@mv $@ tmp.html
	$(AWK) -v outfile=$@ -f scripts/process-code-blocks.awk tmp.html
	@rm tmp.html

.PHONY: .FORCE
.FORCE:
