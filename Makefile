# Copyright 2016, Marcel Großmann <marcel.grossmann@uni-bamberg.de>
styles := $(styles) gitinfo2.sty gitexinfo.sty
hooks := post-checkout post-commit post-merge
# Git Prepare message
gitprepare := "Initialized Git Foo $(main)"
# Git hooks
gitinfohook := $(meta)/style/gitinfo2-hook.txt
githooks := $(base)/.git/hooks
# Docker adjustments
uid := $(shell id -u $$USER)
gid := $(shell id -g $$USER)
dockerabsvol := $(shell git rev-parse --show-toplevel)
dockerincontainer := $(shell dirname $(shell git ls-tree --full-name --name-only HEAD Makefile))
# config
prepared := .prepared

.PHONY: all alldocker prepare init clean docker
ifeq ($(wildcard $(prepared)),)
.DEFAULT_GOAL := gitmodules
else
.DEFAULT_GOAL := $(main)
endif

# Call make init to create structure and update the meta files
init: updateMeta $(styles) $(bibtexstyles) $(classes)
	@echo "\nCopying styles and creating initial structure\n"
	@mkdir -p graphic code images content

# Call make on LaTeX's main file
$(main): $(main).tex
	@echo "\nCompiling $(main)\n"
	@latexmk -pdf -pdflatex="pdflatex -shell-escape -synctex=1 -interaction=nonstopmode" -use-make $<
	@latexmk -c

# Call make clean
clean:
	@echo "\nCleaning up latex crap\n"
	@latexmk -c
	@rm -f *.synctex.gz *.bbl *.nlo *.nls *.nav *.snm *.loa

# Call make docker
docker:
	@echo "\nDockerizing the build process\n"
	@docker run -it --rm -v $(dockerabsvol)/:/src/ -w /src unibaktr/dock-tex:jessie /bin/sh -c "cd $(dockerincontainer) && make && make clean && chown $(uid):$(gid) $(main).pdf"

all: init $(main) clean
	@echo "\nEverything is done and cleaned\n"

alldocker: init docker
	@echo "\nEverything is done and cleaned\n"

# Internal Targets
# Call make prepare only once after checkout
prepare: $(hooks)
	@echo "\nInitializing git, modules and hooks"
	@test -f $(prepared) || sed -i 's#\\newcommand\\meta.*#\\newcommand\\meta{${meta}}#g' $(main).tex
	@test -f $(prepared) || ln -fs $(base)/.git/gitHeadInfo.gin gitHeadLocal.gin
	@echo "Performing first commit for $(main)\n"
	@test -f $(prepared) || git add .
	@test -f $(prepared) || git commit -m $(gitprepare)
	@test -f $(prepared) || touch .prepared
	@make all

updateMeta:
	@test -f $(prepared) || make gitmodules
	@echo "\nUpdating meta repository\n"
	@cd $(meta) && git pull origin master

$(styles): %.sty : $(meta)/style/%.sty
	@cp $^ $@

$(bibtexstyles): %.bst : $(meta)/style/%.bst
	@cp $^ $@

$(classes): %.cls : $(meta)/style/%.cls
	@cp $^ $@

$(hooks):
	@cp $(gitinfohook) $(githooks)/$@
	@chmod u+x $(githooks)/$@
