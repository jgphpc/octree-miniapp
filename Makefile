all: neighbor_search.exe

NVCC = nvcc
SM = sm_80
NVCCFLAGS = -G -arch=$(SM) -forward-unknown-to-host-compiler
CXXFLAGS = -g -std=c++17 -w

ifdef UENV_MOUNT_LIST
	# uenv:
	CXX = mpicxx
	# INCFLAGS = -I $(CRAY_MPICH_DIR)/include -x cu -ccbin=$(CXX)
	INCFLAGS = -x cu -ccbin=$(CXX)
	LDFLAGS = -L$(CUDA_HOME)/lib64 -L$(CUDA_HOME)/lib64/stubs \
			  -lcudart -lnvidia-ml \
			  -Wl,-rpath=$(CUDA_HOME)/lib64 \
			  -Wl,-rpath=$(CUDA_HOME)/lib64/stubs
	# LDFLAGS = $(shell pkg-config --libs cudart-11.8) $(shell pkg-config --libs nvidia-ml-11.8)
else
	# cpe:
	CXX = CC
	INCFLAGS = -x cu -ccbin=$(CXX)
	LDFLAGS = -lcudart -lnvidia-ml -Wl,-rpath=$(GCC_PREFIX)/snos/lib64 
endif

RM := rm -f

neighbor_search.exe: neighbor_search.o
	$(PREP) $(CXX) $(CXXFLAGS) $< -o $(@) $(LDFLAGS)

neighbor_search.o: neighbor_search.cu
	$(PREP) $(NVCC) $(NVCCFLAGS) $(CXXFLAGS) $(INCFLAGS) -c $< -o $(@)

help:
	@echo 'https://github.com/eth-cscs/alps-spack-stacks'

clean:
	-$(RM) *.o *.exe
