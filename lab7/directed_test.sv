
`include "environment.sv"
program test (
    intf i_intf
);

  class my_trans extends transaction;

    function void pre_randomize();
      a.rand_mode(0);
      b.rand_mode(0);
      add_sub.rand_mode(0);


      a = 6;
      b = 9;
      add_sub = 1;
    endfunction

  endclass

  environment env;
  my_trans my_tr;

  initial begin
    //creating environment
    env = new(i_intf);

    my_tr = new();

    //setting the repeat count of generator as 4, means to generate 4 packets
    env.gen.repeat_count = 1;

    env.gen.trans = my_tr;

    //calling run of env, it interns calls generator and driver main tasks.
    my_tr.pre_randomize();
    env.run();
  end
endprogram
