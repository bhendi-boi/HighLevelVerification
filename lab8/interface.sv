//Interface
interface counter_inf (
    input bit clk
);
  logic [3:0] data_in;
  logic [3:0] data_out;
  logic load;
  logic rst;
  logic up_down;
  //Driver Clocking Block
  clocking driver_cb @(posedge clk);
    default input #1 output #1;
    output rst;
    output data_in;
    output load;
    output up_down;
  endclocking
  // output monitor clocking block
  clocking output_mon_cb @(posedge clk);
    default input #1 output #1;
    input data_out;
  endclocking
  //input monitor clocking block
  clocking input_mon_cb @(posedge clk);
    default input #1 output #1;
    input load;
    input rst;
    input data_in;
    input up_down;
  endclocking
  //driver modport
  modport DRIVER(clocking driver_cb);
  //input Monitor modport
  modport INPUT_MON(clocking input_mon_cb);
  //Output monitor
  modport OUTPUT_MON(clocking output_mon_cb);

endinterface
