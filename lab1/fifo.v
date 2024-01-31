module fifo (clk,
reset,
write_enb,
read,
data_in,
data_out,
empty,
full);
input clk;
input reset;
input write_enb;
input read;
input [7:0] data_in;
output [7:0] data_out;
output empty;
output full;
wire clk;
wire write_enb;
wire read;
wire [7:0] data_in;
reg [7:0] data_out;
wire empty;
wire full;
reg [7:0] ram[0:25];
reg tmp_empty;
reg tmp_full;
integer write_ptr;
integer read_ptr;
always@(negedge reset)
begin
data_out = 8'b0000_0000;
tmp_empty = 1'b1;
tmp_full = 1'b0;
write_ptr = 0;
read_ptr = 0;
end

assign empty = tmp_empty;
assign full = tmp_full;
always @(posedge clk) begin
if ((write_enb == 1'b1) && (tmp_full == 1'b0)) begin
ram[write_ptr] = data_in;
tmp_empty <= 1'b0;
write_ptr = (write_ptr + 1) % 16;
if ( read_ptr == write_ptr ) begin
tmp_full <= 1'b1;
end
end

if ((read == 1'b1) && (tmp_empty == 1'b0)) begin
data_out <= ram[read_ptr];
tmp_full <= 1'b0;
read_ptr = (read_ptr + 1) % 16;
if ( read_ptr == write_ptr ) begin
tmp_empty <= 1'b1;
end
end
end
endmodule //fifo
