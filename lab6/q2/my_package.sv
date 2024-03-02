package automatic my_package;
  class Transaction;
    static logic [7:0] addr;
    static logic [7:0] addr_init;
    static logic [7:0] count = 0;
    function new(logic [7:0] addr_init = 0);
      addr  = addr_init;
      count = count + 1;
      if (addr_init != 0) addr = addr_init++;
      else addr = count;
      $display("Addr inside class =%0h %0h", addr, addr_init);
    endfunction
  endclass
endpackage
