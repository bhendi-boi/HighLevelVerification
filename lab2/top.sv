`timescale 1ns / 1ps

module top ();

	integer SEED = 0;
  reg reset;

  reg txclk;
  reg ld_tx_data;
  reg [7:0] tx_data;
  reg tx_enable;
  wire tx_out;
  wire tx_empty;

  // reciever wires
  reg rxclk;
  reg uld_rx_data;
  wire [7:0] rx_data;
  reg rx_enable;
  reg rx_in;
  wire rx_empty;

  // temp vars
  reg [9:0] tx_out_check;
  bit [7:0] transmitted_data;

  initial begin
    reset = 1;
    txclk = 0;
    rxclk = 0;
    rx_enable = 0;
    tx_enable = 0;
    uld_rx_data = 0;
    #10 reset = 0;
    #2000 $finish();
  end

  // clock for both the duts
  always begin
    #16 txclk = !txclk;
  end

  always begin
    #1 rxclk = !rxclk;
  end

  // instantiation
  uart_tx transmitter (
      reset,
      txclk,
      ld_tx_data,
      tx_data,
      tx_enable,
      tx_out,
      tx_empty
  );

  uart_rx reciever (
      reset,
      rxclk,
      uld_rx_data,
      rx_data,
      rx_enable,
      rx_in,
      rx_empty
  );

  // 

  initial begin
    #32
    // checking transmission
    tx_enable = 1;
    rx_enable = 1;
    randomise_data(); 
    ld_tx_data = 1; #32
    ld_tx_data = 0;
    check_transmission();
  end

  always @(posedge rxclk) begin
    if(rx_enable)
      rx_in = tx_out;
  end

  always @(negedge txclk) begin
    if(rx_enable && !rx_empty) begin
      uld_rx_data = 1; #10 uld_rx_data = 0;
    end
  end

  task randomise_data ();
    tx_data = $random(SEED);
		$display("[Randomise Data] Random Data Produced is : 8'h%h",tx_data);
  endtask

  task check_transmission ();
    tx_out_check = 9'h0;
    for (int i = 0; i < 10; i++) begin
      @(posedge txclk) begin
        #1
        tx_out_check = {tx_out,tx_out_check[9:1]};
        // $display("%b - %b \n",tx_out, tx_out_check);
      end
    end
    
    for (int i = 0; i<8; i++) begin
      transmitted_data[i] = tx_out_check[8-i];
    end

    if(tx_out_check[0] == 0 && tx_out_check[9] == 1 && transmitted_data == tx_data) begin 
      $display("[Check Transmission] Transimssion Successful. Transmitted data: %h\n",transmitted_data);
    end
    else begin
      $display("[Check Transmission] Transmission Failed");
    end
  endtask

  // dumping 
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, transmitter);
    $dumpvars(0, reciever);
  end
endmodule
