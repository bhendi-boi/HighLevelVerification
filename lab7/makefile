build:
	iverilog -sverilog -o design testbench.sv design.sv environment.sv driver.sv direct_test.sv monitor.sv transactio.sv interface.sv scoreboard.sv

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