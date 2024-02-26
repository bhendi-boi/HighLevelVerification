module dut (
    intr.slave intf
);
  always @(negedge intf.clk) begin
    #25 intf.data_out = intf.data_in;
  end
endmodule
