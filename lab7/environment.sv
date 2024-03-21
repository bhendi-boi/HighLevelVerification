`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;
  /*A class is a user-defined data type that includes data (class properties), functions and tasks that operate on data.

functions and tasks are called as methods, both are members of the class.classes allow objects to be dynamically created, deleted, assigned and accessed via object handles*/

  //generator and driver instance, creates handle
  generator    gen;
  driver       driv;
  monitor      mon;
  scoreboard   scb;

  //mailbox handle's -  a way to allow different processes to exchane data
  mailbox      gen2driv;
  mailbox      mon2scb;

  //virtual interface
  /*SystemVerilog interface is static in nature, whereas classes are dynamic in nature. because of this reason, it is not allowed to declare the interface within classes, but it is allowed to refer to or point to the interface. A virtual interface is a variable of an interface type that is used in classes to provide access to the interface signals.*/
  virtual intf vif;

  //constructor
  function new(virtual intf vif);
    //get the interface from test
    /*The this keyword is used to refer to class properties, parameters and methods of the current instance. this is basically a pre-defined object handle that refers to the object that was used to invoke the method in which this is used.*/
    // vif variable in environment class should be
    // assigned with local variable vif in new()
    this.vif = vif;

    //creating the mailbox (Same handle will be shared across generator and driver)
    gen2driv = new();
    mon2scb = new();

    //creating generator and driver
    gen = new(gen2driv);
    driv = new(vif, gen2driv);
    mon = new(vif, mon2scb);
    scb = new(mon2scb);
  endfunction

  //
  task pre_test();
    driv.reset();
  endtask

  task test();  //main code is here!
    //Fork-Join_any will be unblocked after the completion of any of the Processes
    //except gen, rest of process run forever
    fork
      gen.main();
      driv.main();
      mon.main();
      scb.main();
    join_any
  endtask

  task post_test();
    wait (gen.ended.triggered);
    wait (gen.repeat_count == scb.no_transactions);
    //wait (scb.no_transactions == `NUM_PACKETS);
  endtask

  //run task
  task run;
    pre_test();
    test();
    post_test();
    $finish;
  endtask

endclass
