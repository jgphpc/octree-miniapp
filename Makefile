all: neighbor_search.exe

CXX = CC
NVCC = nvcc
NVCCFLAGS = -g -G -arch=sm_60 -forward-unknown-to-host-compiler
CXXFLAGS = -std=c++17 -w 
INCFLAGS = -I $(CRAY_MPICH_DIR)/include -x cu
LDFLAGS = $(shell pkg-config --libs cudart-11.8) $(shell pkg-config --libs nvidia-ml-11.8)

RM := rm -f

neighbor_search.exe: neighbor_search.o
	$(PREP) $(CXX) $(CXXFLAGS) $< -o $(@) $(LDFLAGS)

neighbor_search.o: neighbor_search.cu
	$(PREP) $(NVCC) $(NVCCFLAGS) $(CXXFLAGS) $(INCFLAGS) -c $< -o $(@)

help:
	@echo 'patch -i neighbor_search.patch'
	@echo 'module swap PrgEnv-cray PrgEnv-gnu'
	@echo 'module swap gcc/11.2.0'
	@echo 'export LD_LIBRARY_PATH=$$CRAY_LD_LIBRARY_PATH:$$LD_LIBRARY_PATH'
	@echo 'export PATH=/apps/daint/UES/hackaton/software/CUDAcore/11.8.0/bin:$$PATH'
	@echo 'export PKG_CONFIG_PATH=/apps/daint/UES/hackaton/software/CUDAcore/11.8.0/pkgconfig:$$PKG_CONFIG_PATH'


clean:
	-$(RM) *.o *.exe
