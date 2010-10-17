.PHONY: install

zsh_dir = /usr/share/zsh/site-functions
project = usagi-$(shell git tag | tail -n 1)

install:
	@mkdir -p ${DESTDIR}${zsh_dir}
	@install -m644 zsh/* ${DESTDIR}${zsh_dir}

dist:
	git archive --prefix=${project}/ -o ${project}.tar HEAD
	gzip ${project}.tar
