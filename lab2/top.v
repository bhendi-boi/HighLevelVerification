`timescale 1ns / 1ps

module top ();

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
    #16
    // checking transmission
    tx_enable = 1;
    rx_enable = 1;
    ld_tx_data = 1; tx_data = 8'h3A; #16
    ld_tx_data = 0;

  end

  always @(posedge txclk) begin
    if(rx_enable)
      rx_in = tx_out;
  end

  always @(negedge rxclk) begin
    if(rx_enable && !rx_empty) begin
      uld_rx_data = 1; #10 uld_rx_data = 0;
    end
  end
  // dumping 
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1, transmitter);
    $dumpvars(0, reciever);
  end
endmodule
