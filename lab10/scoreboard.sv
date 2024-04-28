
//gets the packet from monitor, Generated the expected result and compares with the //actual result recived from Monitor

class scoreboard;

  //creating mailbox handle
  mailbox mon2scb;

  //used to count the number of transactions
  int no_transactions;
  int no_of_erros;

  //constructor
  function new(mailbox mon2scb);
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
  endfunction

  int cans = 10;
  int nickels = 5;
  int dimes = 5;
  int quarters = 0;
  int money_in = 0;

  task is_empty(transaction tr);
    if (cans == 0) begin
      if (tr.empty) $display("empty signal is asserted");
      else $error(1, "error signal is not asserted when all cans are dispensed");
    end
  endtask

  task dispensing_a_can(transaction tr);
    if (tr.dispense) begin
      cans = cans - 1;
    end
  endtask

  task cashier(transaction tr);
    if (tr.nickel_in) begin
      money_in += 5;
      nickels++;
    end else if (tr.dime_in) begin
      money_in += 10;
      dimes++;
    end else if (tr.quarter_in) begin
      money_in += 25;
      quarters++;
    end

    if (tr.dispense) begin
      if (money_in == 50) begin
        money_in = 0;
      end else if (money_in == 55) begin
        if (tr.nickel_out) begin
          if (nickels) begin
            $display("giving a nickel as change");
            nickels--;
            money_in -= 5;
          end else $error("nickel_out is asserted when nickels are not in the machine");
        end else $error("nickel_out is not asserted!");
      end else if (money_in == 60) begin
        if (tr.dime_out) begin
          if (dimes) begin
            $display("giving a dime as change");
            dimes--;
            money_in -= 10;
          end else $error("dime_out is asserted when dimes are not in the machine");
        end else $error("dime_out is not asserted!");
      end else if (money_in == 70) begin
        if (tr.two_dime_out) begin
          if (dimes >= 2) begin
            $display("giving 2 dimes as change");
            dimes -= 2;
            money_in -= 20;
          end else $error("two_dime_out is asserted when 2 dimes are not in the machine");
        end else $error("two_dime_out is not asserted!");
      end
      money_in = money_in >= 50 ? money_in - 50 : money_in;
    end
  endtask

  //Compares the Actual result with the expected result
  task main;
    transaction trans;
    forever begin
      mon2scb.get(trans);

      is_empty(trans);

      cashier(trans);

      dispensing_a_can(trans);

      trans.display("[ Scoreboard ]");
      no_transactions++;
    end

  endtask

endclass
