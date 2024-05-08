
`include "environment.sv"

program test (
    intf inf
);

  int no_of_erros = 0;
  class my_trans extends transaction;
  function void pre_randomize();
    $display("PRE");
  endfunction
    constraint only_one_hot {
  // Use logical OR to check if any two or more bits are high
  !(nickel_in && dime_in) && !(nickel_in && quarter_in) && !(dime_in && quarter_in);
}
 
  endclass

  //declaring environment instance
  environment env;
  my_trans my_tr;

  initial begin
    //creating environment
    env = new(inf);

    my_tr = new();

    //setting the repeat count of generator as 4, means to generate 4 packets
    env.gen.repeat_count = 100;

    env.gen.trans = my_tr;

    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram