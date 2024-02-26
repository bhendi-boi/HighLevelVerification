build:
	iverilog -g 2012 -o design top.sv interface.sv master.sv slave.sv

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
term:
	make clean
	make build
	make synth