
//gets the packet from monitor, Generated the expected result and compares with the //actual result recived from Monitor

class scoreboard;

  //creating mailbox handle
  mailbox mon2scb;

  //used to count the number of transactions
  int no_transactions;
  int no_of_erros;

  logic [31:0] prev_data;
  //constructor
  function new(mailbox mon2scb);
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
  endfunction


  //Compares the Actual result with the expected result
  task main;
    transaction trans;
    forever begin
      mon2scb.get(trans);
      trans.display("[ Scoreboard ]");

      if (no_transactions == 8) begin
        if (no_of_erros) begin
          $display("TEST FAILED");
        end else begin
          $display("TEST PASSED");
        end
      end
      no_transactions++;
    end

  endtask

endclass
