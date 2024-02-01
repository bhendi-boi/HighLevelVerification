build:
	iverilog -o design top.v design.v fifo.v port_fsm.v env.v driver.v receiver.v packet.v scoreboard.v

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