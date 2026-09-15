IVERILOG ?= iverilog
VVP ?= vvp

SRCS = src/processing_element.v src/systolic_array_4x4.v src/tb_systolic_array_4x4.v
TARGET = systolic_sim.vvp

all: $(TARGET)

$(TARGET): $(SRCS)
	$(IVERILOG) -o $@ $^

test: $(TARGET)
	$(VVP) $(TARGET)

clean:
	rm -f $(TARGET) *.vcd

.PHONY: all test clean
