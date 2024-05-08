class coverage;


  transaction trans;
  covergroup cov_in;
    option.per_instance = 1;
    nickel_in: coverpoint trans.nickel_in;
    dime_in: coverpoint trans.dime_in;
    quarter_in: coverpoint trans.quarter_in;

  endgroup

  function new();
    cov_in = new();
    trans  = new;
  endfunction  //new()

  task run(transaction trans);
    this.trans = trans;
    trans.display("[ Coverage ]");
    cov_in.sample();
  endtask
endclass  //coverage
