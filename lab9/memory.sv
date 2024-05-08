// Code your design here

module wb_memory #(
    // {{{
    parameter DW = 32,
    parameter AW = 3
    // }}}
) (
    // {{{
    input wire i_clk,
    i_reset,
    input wire i_wb_cyc,
    i_wb_stb,
    i_wb_we,
    input wire [(AW-1):0] i_wb_addr,
    input wire [(DW-1):0] i_wb_data,
    input wire [(DW/8-1):0] i_wb_sel,
    output wire o_wb_stall,
    output reg o_wb_ack,
    output reg [(DW-1):0] o_wb_data
    // }}}
);

  // Local declarations
  // {{{
  wire w_wstb, w_stb;
  wire [(DW-1):0] w_data;
  wire [(AW-1):0] w_addr;
  wire [(DW/8-1):0] w_sel;

  // Declare the memory itselfMEf
  reg [(DW-1):0] mem[0:((1<<AW)-1)];
  reg [DW-1:0] reset_val;
  // }}}

  ////////////////////////////////////////////////////////////////////////
  //
  // Add a clock cycle to memory accesses (if required)
  // {{{
  ////////////////////////////////////////////////////////////////////////
  //
  //


  reg last_wstb, last_stb;
  reg [  (AW-1):0] last_addr;
  reg [  (DW-1):0] last_data;
  reg [(DW/8-1):0] last_sel;

  initial last_wstb = 0;
  always @(posedge i_clk)
    if (i_reset) last_wstb <= 0;
    else last_wstb <= (i_wb_stb) && (i_wb_we);

  initial last_stb = 1'b0;
  always @(posedge i_clk)
    if (i_reset) last_stb <= 1'b0;
    else last_stb <= (i_wb_stb);

  always @(posedge i_clk) last_data <= i_wb_data;
  always @(posedge i_clk) last_addr <= i_wb_addr;
  always @(posedge i_clk) last_sel <= i_wb_sel;

  assign w_wstb = last_wstb;
  assign w_stb  = last_stb;
  assign w_addr = last_addr;
  assign w_data = last_data;
  assign w_sel  = last_sel;
  // }}}


  ////////////////////////////////////////////////////////////////////////
  //
  // Read from memory
  // {{{
  ////////////////////////////////////////////////////////////////////////
  //
  //
  always @(posedge i_clk) o_wb_data <= mem[w_addr];

  //Reset 
  always @(posedge i_reset) begin
    for (int i = 0; i <= DW - 1; i++) reset_val[i] = 1'b1;
    for (int i = 0; i < 2 ** AW; i++) mem[i] = reset_val;
  end

  begin : WRITE_TO_MEMORY

    // {{{
    integer ik;

    always @(posedge i_clk)
      if (w_wstb) begin
        for (ik = 0; ik < DW / 8; ik = ik + 1)
          if (w_sel[ik]) mem[w_addr][ik*8+:8] <= w_data[ik*8+:8];
      end

    // }}}
  end
  // }}}
  ////////////////////////////////////////////////////////////////////////
  //
  // Wishbone return signaling
  // {{{
  ////////////////////////////////////////////////////////////////////////
  //
  //

  initial o_wb_ack = 1'b0;
  always @(posedge i_clk)
    if (i_reset) o_wb_ack <= 1'b0;
    else o_wb_ack <= (w_stb) && (i_wb_cyc);

  assign o_wb_stall = 1'b0;
  // }}}



endmodule
