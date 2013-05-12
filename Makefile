.PHONY: install

zsh_lib_dir = /usr/share/zsh/site-functions
project     = usagi-$(shell git tag | tail -n 1)

install:
	@mkdir -p ${DESTDIR}${zsh_lib_dir}
	@mkdir -p ${DESTDIR}/usr/bin
	@install -m644 zsh/* ${DESTDIR}${zsh_lib_dir}
	@install -m755 bin/* ${DESTDIR}/usr/bin

dist:
	git archive --prefix=${project}/ -o ${project}.tar HEAD
	gzip ${project}.tar
