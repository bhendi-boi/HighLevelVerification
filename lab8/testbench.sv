

//including interfcae and testcase files
`include "interface.sv"

//-------------------------[NOTE]---------------------------------
//Particular testcase can be run by uncommenting, and commenting the rest
`include "random_test.sv"
// `include "directed_test.sv"
//----------------------------------------------------------------

module tbench_top;

  //clock and reset signal declaration
  bit clk;
  bit reset;

  //clock generation
  always #5 clk = ~clk;

  //reset Generation
  initial begin
    clk = 0;
    i_intf.rst = 1;
    #5 i_intf.rst = 0;
  end


  //creatinng instance of interface, inorder to connect DUT and testcase
  counter_inf i_intf (clk);

  //Testcase instance, interface handle is passed to test as an argument
  test t1 (i_intf);

  //DUT instance, interface signals are connected to the DUT ports
  counter_load DUT (
      .clk(i_intf.clk),
      .rst(i_intf.rst),
      .load(i_intf.load),
      .data_out(i_intf.data_out),
      .data_in(i_intf.data_in),
      .up_down(i_intf.up_down)
  );

  //enabling the wave dump
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
