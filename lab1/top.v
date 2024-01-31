module top ();
  parameter NUM_PORTS = 8;
  reg clock;
  wire packet_valid;
  wire [7:0] data;
  wire [NUM_PORTS-1:0][7:0] port;
  wire [NUM_PORTS-1:0] ready;
  wire [NUM_PORTS-1:0] read;

  reg reset;
  reg mem_en;
  reg mem_rd_wr;
  reg [7:0] mem_data;
  reg [2:0] mem_add;
  reg [7:0] mem[3:0];

  // take istance of testbench
  sw_tb #(
      .NUM_PORTS(NUM_PORTS)
  ) tb (
      clock,
      packet_valid,
      data,
      port,
      ready,
      read
  );

  // take instance dut
  switch #(
      .NUM_PORTS(NUM_PORTS)
  ) dut (
      clock,
      reset,
      packet_valid,
      data,
      port,
      ready,
      read,
      mem_en,
      mem_rd_wr,
      mem_add,
      mem_data
  );


  //Clock generator
  initial clock = 0;
  always begin
    #5 clock = !clock;
  end

  // Do reset and configure the dut port address
  initial begin
    $dumpon;
    mem[0] = $random;
    mem[1] = $random;
    mem[2] = $random;
    mem[3] = $random;
    mem_en = 0;
    @(posedge clock);
    #2 reset = 1;
    @(posedge clock);
    #2 reset = 0;
    mem_en = 1;
    @(negedge clock);
    mem_rd_wr = 1;
    mem_add   = 0;
    mem_data  = mem[0];
    @(negedge clock);
    mem_rd_wr = 1;
    mem_add   = 1;
    mem_data  = mem[1];
    @(negedge clock);
    mem_rd_wr = 1;
    mem_add   = 2;
    mem_data  = mem[2];
    @(negedge clock);
    mem_rd_wr = 1;
    mem_add   = 3;
    mem_data  = mem[3];
    @(negedge clock);
    mem_en = 0;
    mem_rd_wr = 0;
    mem_add = 0;
    mem_data = 0;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, dut);
  end


endmodule  //top
