module coin_counter
  (
  output reg        use_exact       ,
  input  wire       nickel_out      ,
  input  wire       dime_out        ,
  input  wire       nickel_dime_out ,
  input  wire       two_dime_out    ,
  input  wire       load            ,
  input  wire [7:0] nickels         ,
  input  wire [7:0] dimes           ,
  input  wire       nickel_in       ,
  input  wire       dime_in         ,
  input  wire       quarter_in      ,
  input  wire       rst             ,
  input  wire       clk              
  ) ;

  always @ ( posedge clk )
    begin : cnt
    reg [7:0] quarter_count ; // variables
    reg [7:0] nickel_count  ;
    reg [7:0] dime_count    ;
      if (rst == 1)
        begin
          nickel_count  = 0 ;
          dime_count    = 0 ;
          quarter_count = 0 ;
          use_exact     <= 1 ;
        end
      else
        begin
          case ( { load,nickel_in, dime_in, quarter_in,nickel_out, dime_out, nickel_dime_out, two_dime_out } ) // parallel_case
            8'b10000000: // load
              begin
                nickel_count = nickel_count + nickels ;
                dime_count   = dime_count   + dimes   ;
              end
            8'b01000000: // nickel_in
              begin
                nickel_count  = nickel_count  + 1 ;
              end
            8'b00100000: // dime_in
              begin
                dime_count    = dime_count    + 1 ;
              end
            8'b00010000: // quarter_in
              begin
                quarter_count = quarter_count + 1 ;
              end
            8'b00001000: // nickel_out 
              begin
                if ( nickel_count >= 1 )
                  nickel_count = nickel_count - 1 ;
              end
            8'b00000100: // dime_out
              begin
                if (dime_count >= 1)
                  dime_count = dime_count - 1 ;
                else if ( nickel_count >= 2 )
                  nickel_count = nickel_count - 2 ;
              end
            8'b00000010: // nickel_dime_out
              begin
                if ( dime_count >= 1 && nickel_count >= 1 )
                  begin
                    dime_count   = dime_count - 1 ;
                    nickel_count = nickel_count - 1 ;
                  end
                 else if ( nickel_count >= 3 )
                   nickel_count = nickel_count - 3 ;
              end
            8'b00000001: // two_dime_out
              begin
                if ( dime_count >= 2 )
                  dime_count = dime_count - 2 ;
                else if ( dime_count >= 1 && nickel_count >= 2 )
                  begin
                    dime_count   = dime_count - 1 ;
                    nickel_count = nickel_count - 2 ;
                  end
                else if ( nickel_count >= 4 )
                  nickel_count = nickel_count - 4 ;
              end
          endcase
          if ( nickel_count >= 1 && dime_count >= 2
            || nickel_count >= 2 && dime_count >= 1
            || nickel_count >= 4 )
            use_exact <= 0 ;
          else
            use_exact <= 1 ;
        end
    end

endmodule

