`timescale 1ns/1ps

module vending_machine (
    input  wire clk,
    input  wire rst,

    // Coin inputs
    input  wire coin_5,
    input  wire coin_10,

    // Outputs
    output reg  dispense,
    output reg  change_5
);

    // States represent amount inserted
    localparam S0  = 2'b00;   // ₹0
    localparam S5  = 2'b01;   // ₹5
    localparam S10 = 2'b10;   // ₹10

    reg [1:0] state;
    reg [1:0] next_state;

    // Next-state logic
    always @(*) begin

        next_state = state;

        case (state)

            // ₹0 inserted
            S0: begin
                if (coin_5)
                    next_state = S5;
                else if (coin_10)
                    next_state = S10;
            end

            // ₹5 inserted
            S5: begin
                if (coin_5)
                    next_state = S10;
                else if (coin_10)
                    next_state = S0;
            end

            // ₹10 inserted
            S10: begin
                if (coin_5)
                    next_state = S0;
                else if (coin_10)
                    next_state = S0;
            end

            default:
                next_state = S0;

        endcase

    end

    // State register
    always @(posedge clk) begin

        if (rst)
            state <= S0;
        else
            state <= next_state;

    end

    // Output logic
    always @(*) begin

        dispense = 1'b0;
        change_5 = 1'b0;

        case (state)

            // ₹10 + ₹5 = ₹15
            S10: begin
                if (coin_5) begin
                    dispense = 1'b1;
                    change_5 = 1'b0;
                end

                // ₹10 + ₹10 = ₹20
                // Item = ₹15, change = ₹5
                else if (coin_10) begin
                    dispense = 1'b1;
                    change_5 = 1'b1;
                end
            end

            default: begin
                dispense = 1'b0;
                change_5 = 1'b0;
            end

        endcase

    end

endmodule