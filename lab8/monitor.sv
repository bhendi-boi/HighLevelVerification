
//Samples the interface signals, captures into transaction packet and send the packet to scoreboard.

class monitor;
  
  //creating virtual interface handle
  virtual counter_inf vif;
  
  //creating mailbox handle
  mailbox mon2scb;
  
  //constructor
  function new(virtual counter_inf vif,mailbox mon2scb);
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
     // @(posedge vif.clk);
      //@(posedge vif.clk);
      if (vif.rst == 0) begin
      trans.load   = vif.load;
        trans.rst = vif.rst;
      trans.data_in   = vif.data_in;
      trans.data_out   = vif.data_out;
     @(posedge vif.clk);
      mon2scb.put(trans);
      trans.display("[ Monitor ]");
      end
    end
  endtask
  
endclass