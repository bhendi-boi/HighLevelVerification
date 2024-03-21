
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
    wait (vif.reset);
    $display("[ DRIVER ] ----- Reset Started -----");
    vif.a <= 0;
    vif.b <= 0;
    vif.add_sub = 1;
    wait (!vif.reset);
    $display("[ DRIVER ] ----- Reset Ended   -----");
  endtask

  //drivers the transaction items to interface signals
  task main;
    forever begin
      transaction trans;
      gen2driv.get(trans);
      @(posedge vif.clk);

      vif.a <= trans.a;
      vif.b <= trans.b;
      vif.add_sub <= trans.add_sub;
      @(posedge vif.clk);

      trans.cout = vif.cout;
      //       @(posedge vif.clk);
      trans.display("[ Driver ]");
      no_transactions++;
    end
  endtask

endclass
