module scoreboard ();
  // Declare a memory to store sent packets
  reg [0:7] sent_pkt[0:64][0:10];

  integer pkt_no;
  initial pkt_no = 0;

  // task to add packets to scoreboard
  task add_pkt(input integer pkt_no);
    integer i;
    begin
      for (i = 0; i < 65; i = i + 1) sent_pkt[i][pkt_no] = top.tb.dv.gen.pkt[i];
    end
  endtask

endmodule
