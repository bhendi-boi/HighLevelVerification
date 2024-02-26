interface intr (
    input bit clk
);
  bit write;
  bit [15:0] data_in;
  bit [7:0] address;
  logic [15:0] data_out;


  modport slave(input clk, write, data_in, output data_out);
  modport master(output write, data_in, address, input data_out, clk);
endinterface
