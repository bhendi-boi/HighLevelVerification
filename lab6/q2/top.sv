import my_package::Transaction;
program automatic test;
  initial begin
    Transaction tarray[5];
  end
  task generator(Transaction tarray[]);
    foreach (tarray[i]) begin
      tarray[i] = new();
      transmit(tarray[i]);
    end
  endtask

  task transmit(Transaction tr);
    $display("%f", 0.1);
  endtask : transmit
endprogram
