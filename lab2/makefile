build:
	iverilog -o design top.v uart_rx.v uart_tx.v

synth:
	vvp design

wave:
	gtkwave dump.vcd

clean:
	rm design dump.vcd

all: 
	make clean
	make build
	make synth
	make wave