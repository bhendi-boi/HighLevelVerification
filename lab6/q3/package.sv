package automatic my_package;
  class Statistics;

    function Statistics copy();

    endfunction
  endclass  //Statistics
  class MemTrans;
    bit [7:0] data_in;
    bit [3:0] address;
    Statistics stats;
    function new();
      data_in = 3;
      address = 5;
      stats   = new();
    endfunction

    function MemTrans copy();
      copy = new;
      copy.data_in = data_in;
      copy.address = this.address;
      copy.stats = stats.copy;
    endfunction
  endclass
  ;
endpackage
