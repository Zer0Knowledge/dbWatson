#dbWatson Makefile
#Author: Kevin Klein, Riesa
.PHONY: all test clean

CC := g++
CCC := gcc
CFLAGS := -c -Wall
CPPFLAGS := -std=c++14
TARGET := dbWatson

SRCDIR := src
INCDIR := include
OBJDIR := obj
BINDIR := bin
TSTDIR := test

OS := $(shell uname)

ifeq ($(OS), Darwin)
	include libs_osx.mk
else
	include libs_lnx.mk
endif

LIBFILES := $(addprefix -l, $(LIBFILES))
LPATHS := $(addprefix -L, $(LPATHS))
IPATHS := $(addprefix -I, $(IPATHS))

SOURCES := $(wildcard $(SRCDIR)/*.cpp) \
           $(wildcard $(SRCDIR)/*.c)
OBJFILES := $(subst $(SRCDIR),$(OBJDIR),$(SOURCES:.cpp=.o))
OBJFILES := $(OBJFILES:.c=.o) #*.c-Files

all: $(BINDIR)/$(TARGET)

test: clean all
	cd $(TSTDIR); ../$(BINDIR)/$(TARGET)

$(BINDIR)/$(TARGET): $(OBJFILES)
	mkdir -p $(BINDIR)
	$(CC) $(LPATHS) $(LIBFILES) $(OBJFILES) -o $@

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp
	mkdir -p $(OBJDIR)
	$(CC) $(CFLAGS) $(CPPFLAGS) -I$(INCDIR) $(IPATHS)  $< -o $@

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	mkdir -p $(OBJDIR)
	$(CCC) $(CFLAGS) -I$(INCDIR) $(IPATHS)  $< -o $@

clean:
	rm -r -f $(OBJDIR)
	rm -r -f $(BINDIR)
