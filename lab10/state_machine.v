module state_machine
  (
  output reg  nickel_out      ,
  output reg  dime_out        ,
  output reg  nickel_dime_out ,
  output reg  two_dime_out    ,
  output reg  dispense        ,
  input  wire nickel_in       ,
  input  wire dime_in         ,
  input  wire quarter_in      ,
  input  wire rst             ,
  input  wire clk           
  ) ;

`define idle                    4'd0
`define five                    4'd1
`define ten                     4'd2
`define fifteen                 4'd3
`define twenty                  4'd4
`define twenty_five             4'd5
`define thirty                  4'd6
`define thirty_five             4'd7
`define forty                   4'd8
`define forty_five              4'd9


/////////////

reg [3:0] state ; // variable



  always @ ( posedge clk )
    begin : fsm
      if (rst == 1)
        begin
          dispense        <= 0 ;
          nickel_out      <= 0 ;
          dime_out        <= 0 ;
          nickel_dime_out <= 0 ;
          two_dime_out    <= 0 ;
          state            = `idle ;
        end
      else
          case ( state )
          `idle:
            begin
              dispense        <= 0 ;
              nickel_out      <= 0 ;
              dime_out        <= 0 ;
              nickel_dime_out <= 0 ;
              two_dime_out    <= 0 ;
              if ( nickel_in == 1 )
                state  = `five ;
              else if ( dime_in == 1 )
                state  = `ten ;
              else if ( quarter_in == 1 )
                state  = `twenty_five ;
            end
          `five:
            if ( nickel_in == 1 )
              state  = `ten ;
            else if ( dime_in == 1 )
              state  = `fifteen ;
            else if ( quarter_in == 1 )
              state  = `thirty ;
          `ten:
            if ( nickel_in == 1 )
              state  = `fifteen ;
            else if ( dime_in == 1 )
              state  = `twenty ;
            else if ( quarter_in == 1 )
              state  = `thirty_five ;
          `fifteen:
            if ( nickel_in == 1 )
              state  = `twenty ;
            else if ( dime_in == 1 )
              state  = `twenty_five ;
            else if ( quarter_in == 1 )
              state  = `forty ;
          `twenty:
            if ( nickel_in == 1 )
              state  = `twenty_five ;
            else if ( dime_in == 1 )
              state  = `thirty ;
            else if ( quarter_in == 1 )
              state  = `forty_five ;
          `twenty_five:
            if ( nickel_in == 1 )
              state  = `twenty ;
            else if ( dime_in == 1 )
              state  = `thirty_five ;
            else if ( quarter_in == 1 )
              begin
                dispense <= 1 ;
                state     = `idle ;
              end

 `twenty_five:
            if ( nickel_in == 1 )
              state  = `twenty ;
            else if ( dime_in == 1 )
              state  = `thirty_five ;
            else if ( quarter_in == 1 )
              begin
                dispense <= 1 ;
                state     = `idle ;
              end

          `thirty:
            if ( nickel_in == 1 )
              state  = `thirty_five ;
            else if ( dime_in == 1 )
              state  = `forty ;
            else if ( quarter_in == 1 )
              begin
                dispense   <= 1 ;
                nickel_out <= 1 ;
                state     = `idle  ;
              end
          `thirty_five:
            if ( nickel_in == 1 )
              state  = `forty ;
            else if ( dime_in == 1 )
              state  = `forty_five ;
            else if ( quarter_in == 1 )
              begin
                dispense <= 1 ;
                dime_out <= 1 ;
                state     = `idle  ;
              end
          `forty:
            if ( nickel_in == 1 )
              state  = `forty_five ;
            else if ( dime_in == 1 )
              begin
                dispense <= 1 ;
                state     = `idle ;
              end
            else if ( quarter_in == 1 )
              begin
                dispense   <= 1 ;
                nickel_out <= 1 ;
                dime_out   <= 1 ;
                state       = `idle ;
              end
          `forty_five:
            if ( nickel_in == 1 )
              begin
                dispense <= 1 ;
                state     = `idle ;
              end
            else if ( dime_in == 1 )
              begin
                dispense   <= 1 ;
                nickel_out <= 1 ;
                state       = `idle ;
              end
            else if ( quarter_in == 1 )
              begin
                dispense     <= 1 ;
                two_dime_out <= 1 ;
                state         = `idle ;
              end
        endcase
    end

endmodule