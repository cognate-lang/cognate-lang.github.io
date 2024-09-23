AWK=awk
HUGO=hugo
BASEURL=https://cognate-lang.github.io

.PHONY: build
build:
	# NOTE: Requires gawk
	tree-sitter query --test scripts/doc-comments.scm prelude.cog --config-path tree-sitter.json | $(AWK) -v linkURL="https://github.com/cognate-lang/cognate/blob/master/src/" -f scripts/doc-comments.awk > content/reference/prelude.md
	$(HUGO) #--baseURL $(BASEURL)
	make $(shell find public -type f -name "*.html")

public/%.html: .FORCE
	@mv $@ tmp.html
	# Does not require gawk
	$(AWK) -v outfile=$@ -f scripts/process-code-blocks.awk tmp.html
	@rm tmp.html

.PHONY: .FORCE
.FORCE:
