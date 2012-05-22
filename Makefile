SHELL	= /bin/sh
LATEX	= jlatex
MAIN	= main
TEX	= $(MAIN).tex \
	chap1.tex \
	chap2.tex \
	chap3.tex \
	chap4.tex \
	chap5.tex \
	ack.tex \
	abst.tex \
	jabst.tex \
	refer.tex \
	app.tex
FIGDIR	= ../fig
FIGTEX	= $(FIGDIR)/groupdb.dev \
	$(FIGDIR)/tfs-lattice.dev \
	$(FIGDIR)/dpa.dev
BACKUPDIR = yasaka:tex/masterthesis
DEV	= latex

.SUFFIXES: .fig .dev .tex .tex .bbl .blg .aux .dvi .finaux .iniaux

.fig.dev:
	fig2dev -L $(DEV) $< > $@
	cp $@ ./`basename $@ .dev`.tex

.tex.iniaux:
	$(LATEX) $*
	touch $@

.iniaux.bbl:
	jbibtex $*

.bbl.finaux:
	@echo Executing latex once more...
	$(LATEX) $*
	touch $@

all: iniaux

iniaux:	$(MAIN).iniaux

$(MAIN).iniaux:	$(TEX) $(FIGTEX)

bbl:	$(MAIN).bbl

finaux:	$(MAIN).finaux

finish:	finaux
	@echo Executing latex once more...
	$(LATEX) $(MAIN)

backup:
	-if [ "$(BACKUPDIR)" != "" ] ; \
	  for i in $(BACKUPDIR) ; \
	  do echo $$i; \
	     rcp Makefile *.tex $(FIGTEX) $(FIGTEX:.dev=.fig) $$i; \
	  done ; \
	fi

realclean: clean figdirclean figtexclean

clean:
	rm -f *.aux *.log *.dvi *.toc *.bbl *.blg *.finaux *.iniaux core

figdirclean:
	rm -f $(FIGTEX)

figtexclean:
	-if [ "$(FIGTEX)" != "" ] ; \
	  then for i in $(FIGTEX) ; \
	       do rm -f `basename $$i .dev`.tex ; \
	       done ; \
	fi
