
class transaction;

  rand logic rst;
  rand logic load;
  rand bit up_down;
  randc logic [3:0] data_in;
  logic [3:0] data_out;
  static int no_of_xtn;

  constraint VALID_RST {
    rst dist {
      1 := 1,
      0 := 12
    };
  }

  constraint VALID_LOAD {
    load dist {
      1 := 1,
      0 := 12
    };
  }

  constraint VALID_DATA {data_in inside {[0 : 12]};}


  //declaring the transaction items
  function void display(string name);
    $display("-------------------------");
    $display("- %s ", name);
    $display("-------------------------");
    if (up_down) $display("[ UP COUNTER ]");
    else $display("[ DOWN COUNTER ]");
    $display("- load = %0d, reset = %0d, data_in = %0d, up_down = %0d", load, rst, data_in,
             up_down);
    $display("- data_out = %0d", data_out);
    $display("-------------------------");
  endfunction
endclass
