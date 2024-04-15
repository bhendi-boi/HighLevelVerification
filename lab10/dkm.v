`include "coin_counter.v"
`include "can_count.v"
`include "state_machine.v"

module dkm  // drink_machine top
(
    output wire       nickel_out,
    output wire       dime_out,
    output wire       nickel_dime_out,
    output wire       two_dime_out,
    output wire       dispense,
    output wire       use_exact,
    output wire       empty,
    input  wire       load_coins,
    input  wire       load_cans,
    input  wire [7:0] dimes,
    input  wire [7:0] nickels,
    input  wire [7:0] cans,
    input  wire       nickel_in,
    input  wire       dime_in,
    input  wire       quarter_in,
    input  wire       rst,
    input  wire       clk
);

  coin_counter coin_counter_i (
      use_exact,
      nickel_out,
      dime_out,
      nickel_dime_out,
      two_dime_out,
      load_coins,
      nickels,
      dimes,
      nickel_in,
      dime_in,
      quarter_in,
      rst,
      clk
  );

  can_counter can_counter_i (
      empty,
      dispense,
      load_cans,
      cans,
      rst,
      clk
  );

  state_machine state_machine_i (
      nickel_out,
      dime_out,
      nickel_dime_out,
      two_dime_out,
      dispense,
      nickel_in,
      dime_in,
      quarter_in,
      rst,
      clk
  );


endmodule


