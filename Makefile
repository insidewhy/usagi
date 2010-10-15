.PHONY: install
ZSH_DIR = /usr/share/zsh/site-functions

install:
	@mkdir -p ${DESTDIR}${ZSH_DIR}
	@install -m644 zsh/* ${DESTDIR}${ZSH_DIR}
