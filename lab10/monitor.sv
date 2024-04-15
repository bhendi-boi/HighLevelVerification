

//Samples the interface signals, captures into transaction packet and send the packet to scoreboard.

class monitor;

  //creating virtual interface handle
  virtual intf vif;

  //creating mailbox handle
  mailbox mon2scb;

  //constructor
  function new(virtual intf vif, mailbox mon2scb);
    //getting the interface
    this.vif = vif;
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
  endfunction

  //Samples the interface signal and send the sample packet to scoreboard
  task main;
    forever begin
      transaction trans;
      trans = new();
      @(posedge vif.clk) begin
        $display("mon");
        trans.quarter_in = vif.quarter_in;
        trans.dime_in = vif.dime_in;
        trans.nickel_in = vif.nickel_in;

        // @(posedge trans.dispense) begin
        trans.load_cans = vif.load_cans;
        trans.load_coins = vif.load_coins;
        trans.empty = vif.empty;


        trans.cans = vif.cans;
        trans.nickels = vif.nickels;
        trans.dimes = vif.dimes;
        trans.two_dime_out = vif.two_dime_out;
        trans.nickel_dime_out = vif.nickel_dime_out;
        trans.dime_out = vif.dime_out;
        trans.nickel_dime_out = vif.nickel_dime_out;
        // end
        mon2scb.put(trans);
        trans.display("Monitor");
      end
    end
  endtask

endclass
