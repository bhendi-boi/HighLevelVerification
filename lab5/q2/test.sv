module test (
    intr.master intf
);
  int seed = 0;

  task generate_random;
    @(negedge intf.clk) begin
      intf.data_in = $random(seed);
    end
  endtask
  initial begin
    generate_random();
    generate_random();
    generate_random();
  end
endmodule
