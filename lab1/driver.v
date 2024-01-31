module driver (
    clock,
    packet_valid,
    data,
    busy
);
  output packet_valid;
  output [7:0] data;
  input busy;
  input clock;
  reg packet_valid;
  reg [7:0] data;

  integer delay;
  integer seed1 = 1;
  // Take an instance of packet
  pktgen gen ();
  //Define task to generate the packet and call the drive task
  task gen_and_drive(input integer no_of_pkts);
    integer i;
    begin

      for (i = 0; i < no_of_pkts; i = i + 1) begin
        delay = {$random(seed1)} % 4;
        $display("DRIVER gen and drive pkt_no = %d delay %d", i, delay);
        repeat (delay) @(negedge clock);
        // randomize the packet
        gen.randomize();
        //pack the packet
        gen.packing();
        // call the drive packet task.
        @(negedge clock);
        drive_packet();
        // add the sent packet to score board
        top.tb.sb.add_pkt(i);

      end
    end
  endtask



  task drive_packet();
    integer i;
    begin
      $display("DRIVER Starting to drive packet to port %0d len %0d ", gen.Da, gen.len);
      repeat (4) @(negedge clock);

      // based on packet length in pktgen module, pick up one byte at a time, and store in data[7:0]
      // The data should be driven during negetive edge of clock
      // drive the packet_valid true while data is being driven to data[7:0], and make it zero after entire packet is sent
      for (i = 0; i < gen.len + 4; i = i + 1) begin
        @(negedge clock);

        packet_valid = 1;
        data[7:0] = gen.pkt[i];
        $display("[DRIVER] data %b at i %d", gen.pkt[i], i);

      end
      @(negedge clock);
      packet_valid = 0;
      @(negedge clock);
    end
    //*************************************
    //***********************************


  endtask

endmodule
