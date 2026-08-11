`timescale 1ns/1ps

module vending_machine_tb;

    reg clk;
    reg rst;

    reg coin_5;
    reg coin_10;

    wire dispense;
    wire change_5;

    vending_machine dut (
        .clk(clk),
        .rst(rst),
        .coin_5(coin_5),
        .coin_10(coin_10),
        .dispense(dispense),
        .change_5(change_5)
    );

    // 50 MHz clock
    always #10 clk = ~clk;

    // Insert ₹5 coin
    task insert_5;
        begin
            coin_5 = 1'b1;
            coin_10 = 1'b0;

            @(posedge clk);
            #1;

            coin_5 = 1'b0;

            $display(
                "TIME=%0t ns | COIN=₹5  | DISPENSE=%b | CHANGE_₹5=%b",
                $time,
                dispense,
                change_5
            );
        end
    endtask

    // Insert ₹10 coin
    task insert_10;
        begin
            coin_5 = 1'b0;
            coin_10 = 1'b1;

            @(posedge clk);
            #1;

            coin_10 = 1'b0;

            $display(
                "TIME=%0t ns | COIN=₹10 | DISPENSE=%b | CHANGE_₹5=%b",
                $time,
                dispense,
                change_5
            );
        end
    endtask

    initial begin

        $dumpfile("vending_machine.vcd");
        $dumpvars(0, vending_machine_tb);

        clk = 1'b0;
        rst = 1'b1;

        coin_5  = 1'b0;
        coin_10 = 1'b0;

        $display("---------------------------------------------");
        $display("          VENDING MACHINE TEST");
        $display("        ITEM PRICE = ₹15");
        $display("---------------------------------------------");

        // Reset
        #25;

        rst = 1'b0;

        // ----------------------------------------
        // Test 1: ₹5 + ₹10 = ₹15
        // ----------------------------------------

        $display("");
        $display("TEST 1: INSERT ₹5 + ₹10");

        insert_5;
        insert_10;

        // ----------------------------------------
        // Test 2: ₹10 + ₹5 = ₹15
        // ----------------------------------------

        $display("");
        $display("TEST 2: INSERT ₹10 + ₹5");

        insert_10;
        insert_5;

        // ----------------------------------------
        // Test 3: ₹10 + ₹10 = ₹20
        // Expected: Item + ₹5 change
        // ----------------------------------------

        $display("");
        $display("TEST 3: INSERT ₹10 + ₹10");

        insert_10;
        insert_10;

        // ----------------------------------------
        // Test 4: ₹5 + ₹5 + ₹5 = ₹15
        // ----------------------------------------

        $display("");
        $display("TEST 4: INSERT ₹5 + ₹5 + ₹5");

        insert_5;
        insert_5;
        insert_5;

        $display("");
        $display("---------------------------------------------");
        $display("          SIMULATION COMPLETE");
        $display("---------------------------------------------");

        #20;

        $finish;

    end

endmodule