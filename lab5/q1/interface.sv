interface ahb_if (
    input HCLK,
    input HRESETn
);
  // ?  AHB signals
  logic [20:0] HADDR;
  logic [7:0] HWDATA;
  logic [7:0] HRDATA;
  logic HWRITE;
  logic [1:0] HTRANS;
  logic HREADY;

  // * Error checking on negative edge of HCLK
  always @(negedge HCLK) begin
    if (!(HTRANS == 2'b00 || HTRANS == 2'b10) && HREADY) begin
      $display("Error: HTRANS is not IDLE or NONSEQ at negedge of HCLK.");
    end else begin
      $display("No Error");
    end
  end

endinterface

