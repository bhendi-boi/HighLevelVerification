

//including interfcae and testcase files
`include "interface.sv"

//-------------------------[NOTE]---------------------------------
//Particular testcase can be run by uncommenting, and commenting the rest
// `include "random_test.sv"
`include "directed_test.sv"
//----------------------------------------------------------------

module tbench_top;

  covergroup dkm_cov @ (posedge inf.clk);

  option.per_instance = 1;
  
  covr1:coverpoint inf.nickel_out      ;
  covr2:coverpoint inf.dime_out        ;
  // covr3:coverpoint inf.nickel_dime_out ;
  covr4:coverpoint inf.two_dime_out    ;
  covr5:coverpoint inf.dispense        ;
  covr6:coverpoint inf.use_exact       ;
  covr7:coverpoint inf.empty           ;
  covr8:coverpoint inf.load_coins      ;
  covr9:coverpoint inf.load_cans       ;
  covr10:coverpoint inf.dimes {
    bins all = {[0:255]};
  }         
  covr11:coverpoint inf.nickels {
    bins all = {[0:255]};
  }                 
  covr12:coverpoint inf.cans   {
    bins all = {[0:255]};
  }    
  covr13:coverpoint inf.nickel_in       ;
  covr14:coverpoint inf.dime_in         ;
  covr15:coverpoint inf.quarter_in      ;
  // cross_nickel_dime : cross inf.nickel_in, inf.dime_in;
endgroup

dkm_cov dkm_cov_inst = new();
  

  //reset Generation
  initial begin
    inf.rst = 1;
    #10 inf.rst = 0;
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
  
  final begin
    dkm_cov_inst.sample();
    $display("Class Based Coverage = %0.2f %%\n", dkm_cov_inst.get_inst_coverage());
end
  always @(posedge inf.clk) begin
  $display("Class Based Coverage = %0.2f %%\n", dkm_cov_inst.get_inst_coverage());
  end
  //enabling the wave dump
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
