

//including interfcae and testcase files
`include "interface.sv"

//-------------------------[NOTE]---------------------------------
//Particular testcase can be run by uncommenting, and commenting the rest
// `include "random_test.sv"
`include "directed_test.sv"
//----------------------------------------------------------------

module tbench_top;



  //reset Generation
  initial begin
    inf.rst = 1;
    #5 inf.rst = 0;
  end

  initial begin
    forever begin
      #5 inf.clk = ~ inf.clk;
    end 
  end
  
//   initial $finish();

  //creatinng instance of interface, inorder to connect DUT and testcase
  intf inf ();

  //Testcase instance, interface handle is passed to test as an argument
  test t1 (inf);

  dkm DUT (
      .nickel_out(inf.nickel_out),
      .dime_out(inf.dime_out),
      .nickel_dime_out(inf.nickel_dime_out),
      .two_dime_out(inf.two_dime_out),
      .dispense(inf.dispense),
      .use_exact(inf.use_exact),
      .empty(inf.empty),
      .load_coins(inf.load_coins),
      .load_cans(inf.load_cans),
      .dimes(inf.dimes),
      .nickels(inf.nickels),
      .cans(inf.cans),
      .nickel_in(inf.nickel_in),
      .dime_in(inf.dime_in),
      .quarter_in(inf.quarter_in),
      .rst(inf.rst),
      .clk(inf.clk)
  );
  //enabling the wave dump
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
