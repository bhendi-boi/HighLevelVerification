
//gets the packet from monitor, Generated the expected result and compares with the //actual result recived from Monitor

class scoreboard;

  //creating mailbox handle
  mailbox mon2scb;

  //used to count the number of transactions
  int no_transactions;
  logic [3:0] prev_data_out;

  //constructor
  function new(mailbox mon2scb);
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
  endfunction

  function void check_loading(transaction trans);
    if (trans.data_in == trans.data_out) $display("Load successful");
    else $error("Load failed. Trying to load %d and %d got loaded", trans.data_in, trans.data_out);
  endfunction

  function void check_up_counting(transaction trans);
    if ((prev_data_out == 4'd12) && (trans.data_out == 4'd0)) begin
      $display("Result is as expected\n");
      return;
    end
    if ((prev_data_out == 4'd0) && (trans.data_out == 4'd12)) begin
      $display("Result is as expected\n");
      return;
    end
    if (trans.data_out == prev_data_out + 4'b1) begin
      $display("Result is as expected\n");
    end else begin
      $error("Wrong Result. Expected %d and got %d\n", prev_data_out + 4'b1, trans.data_out);
    end
  endfunction

  function void check_down_counting(transaction trans);
    if ((prev_data_out == 4'd0) && (trans.data_out == 4'd12)) begin
      $display("Result is as expected\n");
      return;
    end
    if ((prev_data_out == 4'd12) && (trans.data_out == 4'd0)) begin
      $display("Result is as expected\n");
      return;
    end
    if (trans.data_out == prev_data_out - 4'b1) begin
      $display("Result is as expected\n");
    end else begin
      $display("%d, %d", prev_data_out, trans.data_out);
      $error("Wrong Result. Expected %d and got %d\n", prev_data_out - 4'b1, trans.data_out);
    end
  endfunction

  //Compares the Actual result with the expected result
  task main;
    transaction trans;
    forever begin
      mon2scb.get(trans);
      if (prev_data_out !== 'x) begin

        if (trans.load) begin
          check_loading(trans);
        end else begin
          if (trans.up_down) begin
            check_up_counting(trans);
          end else begin
            check_down_counting(trans);
          end
        end
      end

      prev_data_out = trans.data_out;
      no_transactions++;
      trans.display("[ Scoreboard ]");
    end
  endtask

endclass
