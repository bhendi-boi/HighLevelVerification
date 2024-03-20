// Code your design here
module counter_load (
    clk,
    rst,
    load,
    data_out,
    data_in,
    up_down
);

  input rst, clk, load, up_down;
  input [3:0] data_in;
  output [3:0] data_out;

  reg [3:0] data_out;
  initial data_out = 4'b0;

  always @(posedge clk or posedge rst) begin
    if (rst) data_out <= 4'b0;
    else if (load) data_out <= data_in;
    else begin
      if (data_out == 4'd12) data_out <= 4'b0;
      else if (data_out == 4'b0) data_out <= 4'd12;
      else begin
        if (up_down) data_out <= data_out + 1;
        else data_out <= data_out - 1;
      end
    end
  end

endmodule
