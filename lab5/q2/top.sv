module top ();
  bit clk;
  always begin
    #1 clk = !clk;
  end
  intr intf (clk);
  test t1 (intf.master);
  dut d1 (intf.slave);

  initial begin
    #8 $finish();
  end
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end
endmodule
