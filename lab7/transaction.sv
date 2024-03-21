
class transaction;

  //declaring the transaction items
  rand bit [3:0] a;
  rand bit [3:0] b;
  rand bit add_sub;
  bit [6:0] cout;

  constraint a_greater_than_b {a >= b;}

  function void display(string name);
    $display("-------------------------");
    $display("- %s ", name);
    $display("-------------------------");
    if (add_sub) $display("Add");
    else $display("Sub");
    $display("- a = %0d, b = %0d, add_sub = %0d", a, b, add_sub);
    $display("- c = %0d", cout);
    $display("-------------------------");
  endfunction
endclass
