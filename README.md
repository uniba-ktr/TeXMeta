# TeXMeta
Templates for our LaTeX files


## Adding the Repository to a new Project

Just add the following Makefile to a new git repository, create a new LaTeX document.

```[makefile]
# Copyright 2016, Marcel Großmann <marcel.grossmann@uni-bamberg.de>
# TODO: Adjust your base GIT directory relatively to Makefile
base := .
# Internal Variables - Touch & Perish
# Folder to clone TeXMeta to, relatively to $base
meta := $(base)/meta
# TODO: Define your main.tex file here
main := main
# TODO: Define the bibtexstyles, which are needed
bibtexstyles := IEEEtranSN.bst
# TeXMeta location
metaurl := "https://github.com/uniba-ktr/TeXMeta.git"

MAKE_FILE := $(meta)/Makefile

ifeq ($(wildcard $(MAKE_FILE)),)
.DEFAULT_GOAL := gitmodules
else
include $(MAKE_FILE)
endif

# Internal Targets
gitmodules: initialize
	@test -d $(meta) || git submodule add $(metaurl) $(meta)
	@git submodule update --init $(meta)
	@( git add $(meta) && git commit -m "Update meta" ) || true
	@make prepare

initialize:
	@test -f .prepared || ( git log | grep "Update meta" || rm -rf .git .gitmodules meta )
	@test -f .prepared || ( cd $(base) && ( test -d .git || git init ) )
```

You can add the commands of the meta repository by adding the following code to your LaTeX file:

```[tex]
\newcommand\meta{./meta}
\input{\meta/config/commands}
\input{\meta/config/hyphenation}
```


## Building the Docker Image

The build instructions for the Docker image reside in the folder `docker`, and the image can be pulled or build by calling `make preparedocker`
