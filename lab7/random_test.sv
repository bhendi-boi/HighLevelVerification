
`define NUM_PACKETS 20
`include "environment.sv"

program test (
    intf i_intf
);
  /* program block
  • To provide an entry point to the execution of testbenches
• To create a container to hold all other testbench data such as tasks, class objects and functions
• Avoid race conditions with the design by getting executed during the reactive region of a simulation cycle
*/

  //declaring environment instance, creates a handle
  environment env;

  initial begin

    //creating environment, constructing a new object of particular class datatype
    env = new(i_intf);

    //setting the repeat count of generator as 4, means to generate 4 packets
    //repeat_count is a property/variable inside generator class
    env.gen.repeat_count = `NUM_PACKETS;

    //calling run of env, it interns calls generator and driver main tasks. run is a method in environment class
    env.run();
  end
endprogram
