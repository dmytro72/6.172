ifeq ($(CILKSAN),1)
CFLAGS += -fsanitize=cilk
LDFLAGS += -fsanitize=cilk
endif

ifeq ($(CILKSCALE),1)
CFLAGS += -mllvm -instrument-cilk -DCILKSCALE
LDFLAGS += -lcilkscale
endif

