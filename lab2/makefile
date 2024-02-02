build:
	iverilog -g 2012 -o design top.sv uart_rx.v uart_tx.v

synth:
	vvp design

wave:
	gtkwave dump.vcd

clean:
	rm -f design dump.vcd
	clear

all: 
	make clean
	make build
	make synth
	make wave