################################################################################
CORE_FILE ?= lisp/$(NAME).el
ELPKG     ?= elpkg
VERSION   ?= $(shell $(ELPKG)/version.sh $(CORE_FILE))
PACKAGE   ?= $(NAME)-$(VERSION)
TARBALL   ?= $(PACKAGE).tar
PKG_FILES ?= $(shell git ls-files|egrep -vi '.git|makefile|elpkg')
EL_FILES  ?= $(shell git ls-files|egrep '\.el$$')

################################################################################
EMACS = emacs
EMACS_FLAGS = -q --no-site-file --batch
EMACS_FLAGS += --eval "(add-to-list 'load-path \"lisp\")"
EMACS_FLAGS += -f package-initialize
EMACS_FLAGS += -f batch-byte-compile

################################################################################
.PHONEY: all clean compile

################################################################################
all: $(TARBALL)

################################################################################
compile: $(EL_FILES:.el=.elc)

################################################################################
clean:
	rm -rf $(TARBALL) $(PACKAGE)
	rm -f $(EL_FILES:.el=.elc)

################################################################################
$(PACKAGE): $(PKG_FILES)
	mkdir $@
	cp $(PKG_FILES) $@
	$(ELPKG)/defpkg.sh $(NAME) $@/$(notdir $(CORE_FILE)) > $@/$(NAME)-pkg.el

################################################################################
$(TARBALL): $(PACKAGE)
	tar -cf $@ $<

################################################################################
%.elc: %.el
	@ echo emacs compile $<
	@ $(EMACS) $(EMACS_FLAGS) $<
