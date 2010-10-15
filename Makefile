.PHONY: install
ZSH_DIR = /usr/share/zsh/site-functions

install:
	@install -D -m644 zsh/* ${DESTDIR}${ZSH_DIR}
