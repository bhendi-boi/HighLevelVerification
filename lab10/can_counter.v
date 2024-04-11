module can_counter
  (
  output reg        empty    ,
  input  wire       dispense ,
  input  wire       load     ,
  input  wire [7:0] cans     ,
  input  wire       rst      ,
  input  wire       clk       
  ) ;

  always @ ( posedge clk )
    begin : cnt
    reg [7:0] total ; // variable
    if (rst == 1)
      begin
        total   = 0 ;
        empty  <= 1 ;
      end
    else
      begin
        case ( { load, dispense } ) // parallel_case
          2'b10:
            total = total + cans ;
          2'b01:
            if ( total != 0 )
              total = total - 1 ;
        endcase
        if ( total == 0 )
          empty <= 1 ;
        else
          empty <= 0 ;
      end
    end

//Extra logic to cover branch coverage
//assign test = empty ? 1'b1  : 1'b0;


endmodule

