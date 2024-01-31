module switch #(
    parameter NUM_PORTS = 4
) (
    input clk,
    input reset,
    input data_status,
    input [7:0] data,
    output [NUM_PORTS-1:0][7:0] port,
    output [NUM_PORTS-1:0] ready,
    input [NUM_PORTS-1:0] read,
    input mem_en,
    input mem_rd_wr,
    input [2:0] mem_add,
    input [7:0] mem_data
);

  initial begin
    if (NUM_PORTS == 8) begin
      `define IS_EIGHT 1`b1;
    end
  end
  wire [7:0] data_out_0;
  wire [7:0] data_out_1;
  wire [7:0] data_out_2;
  wire [7:0] data_out_3;

  wire ll0;
  wire ll1;
  wire ll2;
  wire ll3;

  wire [NUM_PORTS-1:0] empty;

  wire ffee;
  wire ffee0;
  wire ffee1;
  wire ffee2;
  wire ffee3;

  wire ld0;
  wire ld1;
  wire ld2;
  wire ld3;

  wire hold;
  wire [NUM_PORTS-1:0] write_enb;
  wire [7:0] data_out_fsm;
  wire [7:0] addr;

  reg [NUM_PORTS-1:0][7:0] mem;
  wire reset;

  fifo queue_0 (
      .clk(clk),
      .reset(reset),
      .write_enb(write_enb[0]),
      .read(read[0]),
      .data_in(data_out_fsm),
      .data_out(data_out_0),
      .empty(empty[0]),
      .full(ll0)
  );

  fifo queue_1 (
      .clk(clk),
      .reset(reset),
      .write_enb(write_enb[1]),
      .read(read[1]),
      .data_in(data_out_fsm),
      .data_out(data_out_1),
      .empty(empty[1]),
      .full(ll1)
  );

  fifo queue_2 (
      .clk(clk),
      .reset(reset),
      .write_enb(write_enb[2]),
      .read(read[2]),
      .data_in(data_out_fsm),
      .data_out(data_out_2),
      .empty(empty[2]),
      .full(ll2)
  );

  fifo queue_3 (
      .clk(clk),
      .reset(reset),
      .write_enb(write_enb[3]),
      .read(read[3]),
      .data_in(data_out_fsm),
      .data_out(data_out_3),
      .empty(empty[3]),
      .full(ll3)
  );


`ifdef IS_EIGHT
  wire [7:0] data_out_4;
  wire [7:0] data_out_5;
  wire [7:0] data_out_6;
  wire [7:0] data_out_7;

  wire ll4;
  wire ll5;
  wire ll6;
  wire ll7;

  wire ffee4;
  wire ffee5;
  wire ffee6;
  wire ffee7;

  wire ld4;
  wire ld5;
  wire ld6;
  wire ld7;

  fifo queue_4 (
      .clk(clk),
      .reset(reset),
      .write_enb(write_enb[4]),
      .read(read[4]),
      .data_in(data_out_fsm),
      .data_out(data_out_4),
      .empty(empty[4]),
      .full(ll4)
  );

  fifo queue_5 (
      .clk(clk),
      .reset(reset),
      .write_enb(write_enb[5]),
      .read(read[5]),
      .data_in(data_out_fsm),
      .data_out(data_out_5),
      .empty(empty[5]),
      .full(ll5)
  );

  fifo queue_6 (
      .clk(clk),
      .reset(reset),
      .write_enb(write_enb[6]),
      .read(read[6]),
      .data_in(data_out_fsm),
      .data_out(data_out_6),
      .empty(empty[6]),
      .full(ll6)
  );

  fifo queue_7 (
      .clk(clk),
      .reset(reset),
      .write_enb(write_enb[7]),
      .read(read[7]),
      .data_in(data_out_fsm),
      .data_out(data_out_7),
      .empty(empty[7]),
      .full(ll7)
  );
`endif

  port_fsm #(
      .NUM_PORTS(NUM_PORTS)
  ) in_port (
      .clk(clk),
      .reset(reset),
      .write_enb(write_enb),
      .ffee(ffee),
      .hold(hold),
      .data_status(data_status),
      .data_in(data),
      .data_out(data_out_fsm),
      .mem(mem),
      .addr(addr)
  );
  assign port[0] = data_out_0;  //make note assignment only for
  //consistency with vlog env
  assign port[1] = data_out_1;
  assign port[2] = data_out_2;
  assign port[3] = data_out_3;

  if (NUM_PORTS == 8) begin
    assign port[4] = data_out_4;
    assign port[5] = data_out_5;
    assign port[6] = data_out_6;
    assign port[7] = data_out_7;
  end

  assign ready[0] = ~empty[0];
  assign ready[1] = ~empty[1];
  assign ready[2] = ~empty[2];
  assign ready[3] = ~empty[3];

  if (NUM_PORTS == 8) begin
    assign ready[4] = ~empty[4];
    assign ready[5] = ~empty[5];
    assign ready[6] = ~empty[6];
    assign ready[7] = ~empty[7];
  end

  assign ffee0 = (empty[0] | (addr != mem[0]));
  assign ffee1 = (empty[1] | (addr != mem[1]));
  assign ffee2 = (empty[2] | (addr != mem[2]));
  assign ffee3 = (empty[3] | (addr != mem[3]));

  if (NUM_PORTS == 8) begin
    assign ffee4 = (empty[4] | (addr != mem[4]));
    assign ffee5 = (empty[5] | (addr != mem[5]));
    assign ffee6 = (empty[6] | (addr != mem[6]));
    assign ffee7 = (empty[7] | (addr != mem[7]));
  end

  assign ffee = ffee0 & ffee1 & ffee2 & ffee3;

  if (NUM_PORTS == 8) begin
    assign ffee = ffee0 & ffee1 & ffee2 & ffee3 & ffee4 & ffee5 & ffee6 & ffee7;
  end

  assign ld0 = (ll0 & (addr == mem[0]));
  assign ld1 = (ll1 & (addr == mem[1]));
  assign ld2 = (ll2 & (addr == mem[2]));
  assign ld3 = (ll3 & (addr == mem[3]));

  if (NUM_PORTS == 8) begin
    assign ld4 = (ll4 & (addr == mem[4]));
    assign ld5 = (ll5 & (addr == mem[5]));
    assign ld6 = (ll6 & (addr == mem[6]));
    assign ld7 = (ll7 & (addr == mem[7]));
  end

  assign hold = ld0 | ld1 | ld2 | ld3;

  if (NUM_PORTS == 8) begin
    assign hold = ld0 | ld1 | ld2 | ld3 | ld4 | ld5 | ld6 | ld7;
  end

  always @(posedge clk) begin

    if (mem_en)
      if (mem_rd_wr) begin
        mem[mem_add] = mem_data;
        ///$display("%d %d %d %d %d",mem_add,mem[0],mem[1],mem[2],mem[3]);
      end
  end
endmodule  //router
