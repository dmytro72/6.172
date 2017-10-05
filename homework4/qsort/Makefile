TARGETS = qsort

# results dumped by cilkview objects
VIEWS = qsort

CC      = clang
CFLAGS  = -Wall -g -ftapir -m64 
LDFLAGS = -lcilkrts -ldl

include ../cilktool/cilkutils.mk

#INCLUDES = -I/afs/csail.mit.edu/proj/courses/6.172/cilkutil/include

ifeq ($(DEBUG),1)
  CFLAGS += -DDEBUG -O1
else
  CFLAGS += -O3
endif

all: $(TARGETS)

OLD_CFLAGS := $(shell cat .cflags 2> /dev/null)
ifneq ($(CFLAGS),$(OLD_CFLAGS))
.cflags::
	@echo "$(CFLAGS)" > $@
endif


OUTPUTS = $(VIEWS:%=%.csv) $(VIEWS:%=%.plt) $(TARGETS:%=%.cv.out) cilkview.out

$(TARGETS) : % : %.c .cflags
	$(CC) -o $@ $(CFLAGS) $(INCLUDES) $< $(LDFLAGS)

clean::
	rm -f $(TARGETS) $(OUTPUTS) *.stdout *.stderr
