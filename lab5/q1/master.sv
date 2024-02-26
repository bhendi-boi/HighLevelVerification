module ahb_master (
    ahb_if ahb_bus
);

  initial begin
    // Reset sequence
    @(posedge ahb_bus.HCLK);
    ahb_bus.HTRANS <= 2'b00;  // ? IDLE
    @(posedge ahb_bus.HCLK);
    ahb_bus.HTRANS <= 2'b10;  // ? NONSEQ
  end

endmodule

