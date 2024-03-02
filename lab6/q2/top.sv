import my_package::Transaction;
program automatic test;
  initial begin
    Transaction tarray[5];
    generator(tarray);
  end
  task generator(Transaction tarray[]);
    foreach (tarray[i]) begin
      tarray[i] = new();
      transmit(tarray[i]);
    end
  endtask

  task transmit(Transaction tr);
    $display("transmitted");
  endtask : transmit
endprogram
