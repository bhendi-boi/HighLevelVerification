
//gets the packet from generator and drive the transaction paket items into interface (interface is connected to DUT, so the items driven into interface signal will get driven in to DUT) 

class driver;

  //used to count the number of transactions
  int no_transactions;

  //creating virtual interface handle
  virtual intf vif;

  //creating mailbox handle
  mailbox gen2driv;

  //constructor
  function new(virtual intf vif, mailbox gen2driv);
    //getting the interface
    this.vif = vif;
    //getting the mailbox handles from  environment 
    this.gen2driv = gen2driv;
  endfunction


  //Reset task, Reset the Interface signals to default/initial values
  task reset;
    wait (vif.rst);
    $display("[ DRIVER ] ----- Reset Started -----");

    wait (!vif.rst);
    $display("[ DRIVER ] ----- Reset Ended   -----");
  endtask

  //drivers the transaction items to interface signals
  task main;
    transaction trans;

    forever begin
      gen2driv.get(trans);

      @(posedge vif.clk) begin
        vif.quarter_in <= trans.quarter_in;
        vif.dime_in <= trans.dime_in;
        vif.nickel_in <= trans.nickel_in;
        vif.load_cans <= trans.load_cans;
        vif.load_coins <= trans.load_coins;
        vif.cans <= trans.cans;
        vif.nickels <= trans.nickels;
        vif.dimes <= trans.dimes;
      end

      trans.display("[ Driver ]");
      no_transactions++;
    end
  endtask

endclass
