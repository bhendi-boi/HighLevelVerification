module sw_tb #(
    parameter NUM_PORTS = 4
) (
    clock,
    packet_valid,
    data,
    port,
    ready,
    read
);
  input clock;
  output packet_valid;
  output [7:0] data;
  input [NUM_PORTS-1:0][7:0] port;
  input [NUM_PORTS-1:0] ready;
  output [NUM_PORTS-1:0] read;
  reg pkt_status;
  integer error_count = 0;
  event error;

  //Incriment the error counter on error.
  always @(error) begin
    #0 error_count = error_count + 1;
    $display(" ERROR RECIVED");
  end

  // Driver instance
  driver dv (
      clock,
      packet_valid,
      data,
      busy
  );

  // Make four reciever instancess. connect it to specific port.
  receiver rec0 (
      .clk  (clock),
      .data (port[0]),
      .ready(ready[0]),
      .read (read[0]),
      .port (0)
  );
  receiver rec1 (
      .clk  (clock),
      .data (port[1]),
      .ready(ready[1]),
      .read (read[1]),
      .port (1)
  );
  receiver rec2 (
      .clk  (clock),
      .data (port[2]),
      .ready(ready[2]),
      .read (read[2]),
      .port (2)
  );
  receiver rec3 (
      .clk  (clock),
      .data (port[3]),
      .ready(ready[3]),
      .read (read[3]),
      .port (3)
  );

  // Creat instance of scoreboard
  scoreboard sb ();

  // Call then packet gen and drive task in driver
  initial begin
    #100;
    dv.gen_and_drive(9);
    #1000;
    finish;
  end

  // finish task which display the tesults of the test.
  task finish();
    begin
      if (error_count != 0) $display("############# TEST FAILED ###############");
      else $display("############# TEST PASSED ###############");

      $finish();
    end
  endtask

endmodule
