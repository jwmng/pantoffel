#TODO: img

.PHONY: clean website clean_tmp clean_site

# Executables
MD = ./bin/markdown_py 
SASS = ./bin/sassc
REPLACE = ./bin/replace.sh
REPLACEF = ./bin/replacef.sh
DEPLOY = ./bin/deploy

# Directories
CONTENTDIR = content
ARTICLEDIR = $(CONTENTDIR)/articles
HOMEFILE = $(CONTENTDIR)/home.md
TEMPLATEDIR = templates
TMPDIR = tmp
OUTDIR = site
STATICDIR = $(CONTENTDIR)/static
SASSDIR = $(CONTENTDIR)/sass

# Markdown files and intermediate paths
ARTICLES = $(wildcard $(ARTICLEDIR)/*.md)
TMPARTICLES = $(patsubst $(CONTENTDIR)/%, $(TMPDIR)/%, $(ARTICLES:.md=.html))
OUTARTICLES = $(patsubst $(CONTENTDIR)/%, $(OUTDIR)/%, $(ARTICLES:.md=.html))
MENUITEMS = $(patsubst $(ARTICLEDIR)/%, $(TMPDIR)/menu/%, $(ARTICLES:.md=.html))

# Sass files
SASSFILES = $(wildcard $(SASSDIR)/*.sass)
CSSFILES = $(patsubst $(SASSDIR)/%, $(OUTDIR)/static/css/%, $(SASSFILES:.sass=.css))

# Temp items
$(TMPDIR)/articles/%.html: $(ARTICLEDIR)/%.md
	$(MD) $^ > $@

$(TMPDIR)/menu/%.html: $(TEMPLATEDIR)/menu_item.html
	$(eval BASENAME = $(shell basename -s .html $@))
	$(REPLACE) $^ @url /articles/$(BASENAME).html > $@
	$(REPLACE) $@ @name $(BASENAME) -i

$(TMPDIR)/menu.html: $(MENUITEMS) $(TEMPLATEDIR)/menu.html
	cat $(MENUITEMS) > $(TMPDIR)/menu_list.html
	$(REPLACEF) $(TEMPLATEDIR)/menu.html @items $(TMPDIR)/menu_list.html > $(TMPDIR)/menu.html

$(TMPDIR)/home.html: $(HOMEFILE)
	$(eval HOMECONTENT := $(shell cat $(HOMEFILE)))
	$(MD) $^ > $@

# Intermediate page template
$(TMPDIR)/page.html: $(TEMPLATEDIR)/base.html $(TMPDIR)/menu.html
	$(eval MENUHTML := $(shell cat $(TMPDIR)/menu.html))
	$(REPLACEF) $(TEMPLATEDIR)/base.html @menu $(TMPDIR)/menu.html > $@

# Site files
$(OUTDIR)/index.html: $(TMPDIR)/page.html $(TMPDIR)/home.html
	$(eval TITLE := $(shell basename -s .html $@))
	$(REPLACEF) $(TMPDIR)/page.html @content $(TMPDIR)/home.html > $@
	$(REPLACEF) $@ @title $(CONTENTDIR)/title.txt -i

$(OUTDIR)/articles/%.html: $(TMPDIR)/articles/%.html $(TMPDIR)/page.html
	$(REPLACEF) $(TMPDIR)/page.html @content $(TMPDIR)/articles/%.html > $@
	$(REPLACEF) $@ @title $(shell basename -s .html $@) -i

$(OUTDIR)/static: $(STATICDIR)
	cp -r $^/* $@

$(OUTDIR)/static/css/%.css: $(SASSDIR)/%.sass
	$(SASS) $^ > $@

# Phony/command targets
website: $(OUTDIR)/index.html $(OUTARTICLES) $(OUTDIR)/static $(CSSFILES)
	echo Done

deploy:
	#####
	$(DEPLOY) $(OUTDIR)
	echo Deploying

clean:
	rm -rf tmp
	rm -rf site
	mkdir -p tmp/menu tmp/articles
	mkdir -p site/articles site/static site/static/css
	echo Done
