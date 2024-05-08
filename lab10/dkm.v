module coin_counter (
    output reg        use_exact,
    input  wire       nickel_out,
    input  wire       dime_out,
    input  wire       nickel_dime_out,
    input  wire       two_dime_out,
    input  wire       load,
    input  wire [7:0] nickels,
    input  wire [7:0] dimes,
    input  wire       nickel_in,
    input  wire       dime_in,
    input  wire       quarter_in,
    input  wire       rst,
    input  wire       clk
);

  always @(posedge clk) begin : cnt
    reg [7:0] quarter_count;  // variables
    reg [7:0] nickel_count;
    reg [7:0] dime_count;
    if (rst == 1) begin
      nickel_count  = 0 ;
      dime_count    = 0 ;
      quarter_count = 0 ;
      use_exact <= 1;
    end else begin
      case ({
        load, nickel_in, dime_in, quarter_in, nickel_out, dime_out, nickel_dime_out, two_dime_out
      })  // parallel_case
        8'b10000000: // load
              begin
          nickel_count = nickel_count + nickels;
          dime_count   = dime_count + dimes;
        end
        8'b01000000: // nickel_in
              begin
          nickel_count = nickel_count + 1;
        end
        8'b00100000: // dime_in
              begin
          dime_count = dime_count + 1;
        end
        8'b00010000: // quarter_in
              begin
          quarter_count = quarter_count + 1;
        end
        8'b00001000: // nickel_out 
              begin
          if (nickel_count >= 1) nickel_count = nickel_count - 1;
        end
        8'b00000100: // dime_out
              begin
          if (dime_count >= 1) dime_count = dime_count - 1;
          else if (nickel_count >= 2) nickel_count = nickel_count - 2;
        end
        8'b00000010: // nickel_dime_out
              begin
          if (dime_count >= 1 && nickel_count >= 1) begin
            dime_count   = dime_count - 1;
            nickel_count = nickel_count - 1;
          end else if (nickel_count >= 3) nickel_count = nickel_count - 3;
        end
        8'b00000001: // two_dime_out
              begin
          if (dime_count >= 2) dime_count = dime_count - 2;
          else if (dime_count >= 1 && nickel_count >= 2) begin
            dime_count   = dime_count - 1;
            nickel_count = nickel_count - 2;
          end else if (nickel_count >= 4) nickel_count = nickel_count - 4;
        end
      endcase
      if ( nickel_count >= 1 && dime_count >= 2
            || nickel_count >= 2 && dime_count >= 1
            || nickel_count >= 4 )
        use_exact <= 0;
      else use_exact <= 1;
    end
  end

endmodule


module can_counter (
    output reg        empty,
    input  wire       dispense,
    input  wire       load,
    input  wire [7:0] cans,
    input  wire       rst,
    input  wire       clk
);

  always @(posedge clk) begin : cnt
    reg [7:0] total;  // variable
    if (rst == 1) begin
      total = 0;
      empty <= 1;
    end else begin
      case ({
        load, dispense
      })  // parallel_case
        2'b10: total = total + cans;
        2'b01: if (total != 0) total = total - 1;
      endcase
      if (total == 0) empty <= 1;
      else empty <= 0;
    end
  end

  //Extra logic to cover branch coverage
  //assign test = empty ? 1'b1  : 1'b0;


endmodule


module state_machine (
    output reg  nickel_out,
    output reg  dime_out,
    output reg  nickel_dime_out,
    output reg  two_dime_out,
    output reg  dispense,
    input  wire nickel_in,
    input  wire dime_in,
    input  wire quarter_in,
    input  wire rst,
    input  wire clk
);

  `define idle 4'd0
  `define five 4'd1
  `define ten 4'd2
  `define fifteen 4'd3
  `define twenty 4'd4
  `define twenty_five 4'd5
  `define thirty 4'd6
  `define thirty_five 4'd7
  `define forty 4'd8
  `define forty_five 4'd9


  /////////////

  reg [3:0] state;  // variable



  always @(posedge clk) begin : fsm
    if (rst == 1) begin
      dispense        <= 0;
      nickel_out      <= 0;
      dime_out        <= 0;
      nickel_dime_out <= 0;
      two_dime_out    <= 0;
      state = `idle;
    end else
      case (state)
        `idle: begin
          dispense        <= 0;
          nickel_out      <= 0;
          dime_out        <= 0;
          nickel_dime_out <= 0;
          two_dime_out    <= 0;
          if (nickel_in == 1) state = `five;
          else if (dime_in == 1) state = `ten;
          else if (quarter_in == 1) state = `twenty_five;
        end
        `five:
        if (nickel_in == 1) state = `ten;
        else if (dime_in == 1) state = `fifteen;
        else if (quarter_in == 1) state = `thirty;
        `ten:
        if (nickel_in == 1) state = `fifteen;
        else if (dime_in == 1) state = `twenty;
        else if (quarter_in == 1) state = `thirty_five;
        `fifteen:
        if (nickel_in == 1) state = `twenty;
        else if (dime_in == 1) state = `twenty_five;
        else if (quarter_in == 1) state = `forty;
        `twenty:
        if (nickel_in == 1) state = `twenty_five;
        else if (dime_in == 1) state = `thirty;
        else if (quarter_in == 1) state = `forty_five;
        `twenty_five:
        if (nickel_in == 1) state = `twenty;
        else if (dime_in == 1) state = `thirty_five;
        else if (quarter_in == 1) begin
          dispense <= 1;
          state = `idle;
        end

        `twenty_five:
        if (nickel_in == 1) state = `twenty;
        else if (dime_in == 1) state = `thirty_five;
        else if (quarter_in == 1) begin
          dispense <= 1;
          state = `idle;
        end

        `thirty:
        if (nickel_in == 1) state = `thirty_five;
        else if (dime_in == 1) state = `forty;
        else if (quarter_in == 1) begin
          dispense   <= 1;
          nickel_out <= 1;
          state = `idle;
        end
        `thirty_five:
        if (nickel_in == 1) state = `forty;
        else if (dime_in == 1) state = `forty_five;
        else if (quarter_in == 1) begin
          dispense <= 1;
          dime_out <= 1;
          state = `idle;
        end
        `forty:
        if (nickel_in == 1) state = `forty_five;
        else if (dime_in == 1) begin
          dispense <= 1;
          state = `idle;
        end else if (quarter_in == 1) begin
          dispense   <= 1;
          nickel_out <= 1;
          dime_out   <= 1;
          state = `idle;
        end
        `forty_five:
        if (nickel_in == 1) begin
          dispense <= 1;
          state = `idle;
        end else if (dime_in == 1) begin
          dispense   <= 1;
          nickel_out <= 1;
          state = `idle;
        end else if (quarter_in == 1) begin
          dispense     <= 1;
          two_dime_out <= 1;
          state = `idle;
        end
      endcase
  end

endmodule


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


