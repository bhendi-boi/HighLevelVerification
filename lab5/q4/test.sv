module test (
    intr.master intf
);
  int seed = 0;

  task generate_random;
    @(negedge intf.clk) begin
      #15 intf.data_in = $random(seed);
    end
  endtask
  initial begin
    generate_random();
    #100 generate_random();
    #100 generate_random();

  end
endmodule
