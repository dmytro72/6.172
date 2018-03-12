ifeq ($(CILKSAN),1)
CXXFLAGS += -fsanitize=cilk
CFLAGS += -fsanitize=cilk
LDFLAGS += -fsanitize=cilk
endif

ifeq ($(CILKSCALE),1)
CXXFLAGS += -mllvm -instrument-cilk -DCILKSCALE
CFLAGS += -mllvm -instrument-cilk -DCILKSCALE
LDFLAGS += -lcilkscale
endif

