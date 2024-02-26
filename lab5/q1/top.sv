module tb_ahb ();

  bit HCLK, HRESETn;
  ahb_if ahb_bus (
      HCLK,
      HRESETn
  );

  ahb_master master (ahb_bus);
  ahb_slave slave (ahb_bus);

  initial begin
    HCLK = 0;
    forever #5 HCLK = ~HCLK;
  end

  initial begin
    HRESETn = 0;
    #15;
    HRESETn = 1;
  end

  initial begin
    #150;
    $finish;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end
endmodule

