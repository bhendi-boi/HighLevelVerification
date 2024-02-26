module dut (
    intr.slave intf
);
  always @(negedge intf.clk) begin
    intf.data_out = intf.data_in;
  end
endmodule
