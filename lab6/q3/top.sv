module top ();
  import my_package::MemTrans;
  MemTrans mem_trans, mem_trans_copy;
  initial begin
    mem_trans = new;
    $display("mem_trans: ");
    $display("data_in and address are %d and %d respectively", mem_trans.data_in,
             mem_trans.address);

    mem_trans_copy = mem_trans.copy;
    $display("mem_trans_copy: ");
    $display("data_in and address are %d and %d respectively", mem_trans_copy.data_in,
             mem_trans_copy.address);
  end
endmodule
