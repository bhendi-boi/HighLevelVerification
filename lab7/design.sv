
module addsub (
    input        clk,
    input        reset,
    input  [3:0] ain,
    input  [3:0] bin,
    input        add_sub,
    output [6:0] cout
);

  reg [6:0] tmp_c;

  //Reset 
  //always @(posedge reset) 
  //   tmp_c <= 0;

  // Waddition operation
  always @(posedge clk or posedge reset)
    if (reset) tmp_c <= 0;
    else begin
      if (add_sub) tmp_c <= ain + bin;
      else tmp_c <= ain - bin;
    end
  assign cout = tmp_c;

endmodule
