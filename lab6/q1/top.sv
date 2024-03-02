import Pkg::MemTrans;
module top ();

  MemTrans mem_trans;

  initial begin
    mem_trans = new();
    mem_trans.print_all();
  end
endmodule
