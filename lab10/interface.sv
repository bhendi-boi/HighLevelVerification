interface intf;

  bit clk, rst;
  bit quarter_in, dime_in, nickel_in;
  bit [7:0] cans, nickels, dimes;
  bit load_cans, load_coins;
  logic empty, use_exact, dispense;
  logic two_dime_out, nickel_dime_out, dime_out, nickel_out;


endinterface  //intf
