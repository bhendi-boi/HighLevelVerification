package Pkg;
  class PrintUtilities;
    function void print_4(input string name, input [3:0] val_4bits);
      $display("%t: %s = %h", $time, name, val_4bits);
    endfunction
    function void print_8(input string name, input [7:0] val_8bits);
      $display("%t: %s = %h", $time, name, val_8bits);
    endfunction
  endclass
  ;


  class MemTrans;
    bit [7:0] data_in;
    bit [3:0] address;
    PrintUtilities print;
    function new();
      print = new();
    endfunction
    function void print_all();
      print.print_4("adress", address);
      print.print_8("data_in", data_in);
    endfunction
  endclass
  ;

endpackage
