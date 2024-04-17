
class transaction;


  rand bit quarter_in, dime_in, nickel_in;
  bit [7:0] cans, nickels, dimes;
  bit load_cans, load_coins;
  bit empty, use_exact, dispense;
  bit two_dime_out, nickel_dime_out, dime_out, nickel_out;

  function transaction do_copy();
    transaction trans;
    trans = new();

    trans.quarter_in = this.quarter_in;
    trans.dime_in = this.dime_in;
    trans.nickel_in = this.nickel_in;
    trans.cans = this.cans;
    trans.nickels = this.nickels;
    trans.dimes = this.dimes;
    trans.load_cans = this.load_cans;
    trans.load_coins = this.load_coins;
    trans.empty = this.empty;
    trans.use_exact = this.use_exact;
    trans.dispense = this.dispense;
    trans.two_dime_out = this.two_dime_out;
    trans.nickel_dime_out = this.nickel_dime_out;
    trans.dime_out = this.dime_out;
    trans.nickel_out = this.nickel_out;

    return trans;
  endfunction





  //declaring the transaction items
  function void display(string name);
    $display("-------------------------");
    $display("- %s %0t", name, $time);
    $display("-------------------------");
    $display("quarter_in = %0d, dime_in = %0d, nickel_in = %0d", quarter_in, dime_in, nickel_in);

    $display("empty = %0d, use_exact = %0d, dispense = %0d", empty, use_exact, dispense);

    $display("two_dime_out = %0d,nickel_dime_out = %0d, dime_out = %0d, nickel_out = %0d",
             two_dime_out, nickel_dime_out, dime_out, nickel_out);
    $display("-------------------------");
  endfunction
endclass
