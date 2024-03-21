/*
┌──────────────────────────────────────────────────────────────────────────┐
│ testbench                                                                │
│                                                                          │
│   ┌────────────────────────────────────────────────────┐                 │
│   │test              /*
┌──────────────────────────────────────────────────────────────────────────┐
│ testbench                                                                │
│                                                                          │
│   ┌────────────────────────────────────────────────────┐                 │
│   │test                                                │                 │
│   │  ┌───────────────────────────────────────────────┐ │                 │
│   │  │ environment                                   │ │                 │
│   │  │                      ┌───────────────────┐    │ │                 │
│   │  │   generator────┐     │  scoreboard       │    │ │                 │
│   │  │   │            │     │                   │    │ │                 │
│   │  │   │            │     └─────────▲─────────┘    │ │                 │
│   │  │   │ transactor │               │   monitor    │ │                 │
│   │  │   │ │        │ │               │   ┌───────┐  │ │                 │
│   │  │   │ └────────┘ │               └───┤       │  │ │                 │
│   │  │   │            │                   │       │  │ │                 │
│   │  │   └─────┬──────┘ ┌───────────────┐ │       │  │ │                 │
│   │  │         │        │               │ │       │  │ │                 │
│   │  │         │        │ driver        │ └───┬───┘  │ │                 │
│   │  │         └───────►└─────────────┬─┘     │      │ │                 │
│   │  │                                │       │      │ │                 │
│   │  └────────────────────────────────┼───────┼──────┘ │                 │
│   │                                   │       │        │                 │
│   └───────────────────────────────────┼───────┴────────┘                 │
│                                       │interface                         │
│            ┌──────────────────────────▼───────◄──────┐                   │
│            │                                         │                   │
│            │               DUT                       │                   │
│            └─────────────────────────────────────────┘                   │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
*/

//including interfcae and testcase files
`include "interface.sv"

//-------------------------[NOTE]---------------------------------
//Particular testcase can be run by uncommenting, and commenting the rest
`include "random_test.sv"
// `include "directed_test.sv"
//----------------------------------------------------------------

module tbench_top;

  //clock and reset signal declaration
  bit clk;
  bit reset;

  //clock generation
  always #5 clk = ~clk;

  //reset Generation
  initial begin
    reset = 1;
    #5 reset = 0;
  end
// 

  //creatinng instance of interface, inorder to connect DUT and testcase
  intf i_intf (
      clk,
      reset
  );

  //Testcase instance, interface handle is passed to test as an argument
  test t1 (i_intf);

  //DUT instance, interface signals are connected to the DUT ports
  addsub DUT (
      .clk(i_intf.clk),
      .reset(i_intf.reset),
      .ain(i_intf.a),
      .bin(i_intf.b),
      .add_sub(i_intf.add_sub),
      .cout(i_intf.cout)
  );

  //enabling the wave dump
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
                                  │                 │
│   │  ┌───────────────────────────────────────────────┐ │                 │
│   │  │ environment                                   │ │                 │
│   │  │                      ┌───────────────────┐    │ │                 │
│   │  │   generator────┐     │  scoreboard       │    │ │                 │
│   │  │   │            │     │                   │    │ │                 │
│   │  │   │            │     └─────────▲─────────┘    │ │                 │
│   │  │   │ transactor │               │   monitor    │ │                 │
│   │  │   │ │        │ │               │   ┌───────┐  │ │                 │
│   │  │   │ └────────┘ │               └───┤       │  │ │                 │
│   │  │   │            │                   │       │  │ │                 │
│   │  │   └─────┬──────┘ ┌───────────────┐ │       │  │ │                 │
│   │  │         │        │               │ │       │  │ │                 │
│   │  │         │        │ driver        │ └───┬───┘  │ │                 │
│   │  │         └───────►└─────────────┬─┘     │      │ │                 │
│   │  │                                │       │      │ │                 │
│   │  └────────────────────────────────┼───────┼──────┘ │                 │
│   │                                   │       │        │                 │
│   └───────────────────────────────────┼───────┴────────┘                 │
│                                       │interface                         │
│            ┌──────────────────────────▼───────◄──────┐                   │
│            │                                         │                   │
│            │               DUT                       │                   │
│            └─────────────────────────────────────────┘                   │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
*/

//including interfcae and testcase files
`include "interface.sv"

//-------------------------[NOTE]---------------------------------
//Particular testcase can be run by uncommenting, and commenting the rest
`include "random_test.sv"
//`include "directed_test.sv"
//----------------------------------------------------------------

module tbench_top;

  //clock and reset signal declaration
  bit clk;
  bit reset;

  //clock generation
  always #5 clk = ~clk;

  //reset Generation
  initial begin
    reset = 1;
    #5 reset = 0;
  end


  //creatinng instance of interface, inorder to connect DUT and testcase
  intf i_intf (
      clk,
      reset
  );

  //Testcase instance, interface handle is passed to test as an argument
  test t1 (i_intf);

  //DUT instance, interface signals are connected to the DUT ports
  addsub DUT (
      .clk(i_intf.clk),
      .reset(i_intf.reset),
      .ain(i_intf.a),
      .bin(i_intf.b),
      .add_sub(i_intf.add_sub),
      .cout(i_intf.cout)
  );

  //enabling the wave dump
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
