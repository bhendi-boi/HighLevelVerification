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
  bit [7:0] recieved_data;

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
    rx_enable = 1;
    transmission_seq();
    check_reciever();#32
    transmission_seq();
    check_reciever();
  end

  always @(posedge rxclk) begin
    if(rx_enable)
      rx_in = tx_out;
  end

  always @(posedge rxclk) begin
    if(rx_enable && !rx_empty) begin
      uld_rx_data = 1; #10 uld_rx_data = 0;
    end
  end

  task transmission_seq ();
    tx_enable = 1;
    randomise_data(); 
    ld_tx_data = 1; #32
    ld_tx_data = 0;
    check_transmission();
    tx_enable = 0;
  endtask

  task randomise_data ();
    tx_data = $random(SEED);
		$display("[Randomise Data] Random Data Produced is : 8'h%h",tx_data);
  endtask

  task check_transmission ();
    tx_out_check = 9'h0;
    for (int i = 0; i < 10; i++) begin
      @(posedge txclk) begin
        #1
        tx_out_check[i] = tx_out;
      end
    end

    transmitted_data = tx_out_check[8:1];
    if(tx_out_check[0] == 0 && tx_out_check[9] == 1 && transmitted_data == tx_data) begin 
      $display("[Check Transmission] Transimssion Successful. Transmitted data: %h",transmitted_data);
    end
    else begin
      $display("[Check Transmission] Transmission Failed.");
      if(tx_out_check[0] != 0) begin
        $display("Start bit is missing.\n");
      end
      else if (tx_out_check[9] != 1) begin
        $display("End bit is missing.\n");
      end
      else begin
        $display("Problem with transmitted data. Data transmitted is %h\n",transmitted_data);
      end
    end
  endtask

  task check_reciever ();
    @(posedge uld_rx_data) begin
      @(posedge rxclk) begin
        recieved_data = rx_data;
        if(transmitted_data == recieved_data) begin
          $display("[Check Reciever] Data recieved sucessfully. Recieved data: 8'h%h\n",recieved_data);
        end
        else begin
          $display("[Check Reciever] Corrupt data recieved. Recieved data: 8'h%h\n",recieved_data);
        end
      end
    end
  endtask
  // dumping 
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, transmitter);
    $dumpvars(0, reciever);
  end
endmodule
