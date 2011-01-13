
GEN=index.html
WEB=lzo.forge.ocamlcore.org:/home/groups/lzo/htdocs

html: $(GEN)

%.html: %.brtx
	brtx -html -doc -i $< -o $@

upload: index.html
	rsync -avhz $< $(WEB)/
	make -C .. doc
	rsync -avihz ../_build/src/api.docdir/ $(WEB)/api

clean:
	rm -f $(GEN)

