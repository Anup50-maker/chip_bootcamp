`default_nettype none
`timescale 1ns/1ps

module tb;

    reg clk;
    reg rst_n;
    reg ena;
    reg [7:0] ui_in;     // Inputs to DUT
    reg [7:0] uio_in;
    wire [7:0] uo_out;   // Outputs from DUT
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    // Instantiate DUT
    tt_um_stone_paper_scissors uut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),     // not used
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Task to apply moves
    task play_round(input [1:0] p1, input [1:0] p2);
    begin
        ui_in[1:0] = p1;   // Player 1 move
        ui_in[3:2] = p2;   // Player 2 move
        ui_in[4]   = 1'b1; // Start
        #10;               // Wait 1 cycle
        ui_in[4]   = 1'b0; // Stop
        #20;
        $display("P1=%b P2=%b -> Winner=%b (00=Tie,01=P1,10=P2,11=Invalid)", p1, p2, uo_out[1:0]);
    end
    endtask

    // Test sequence
    initial begin
        $dumpfile("stone_paper_scissors_tb.vcd");
        $dumpvars(0, uut);

        clk = 0;
        ena = 1;
        ui_in = 0;

        // Reset
        rst_n = 0;
        #10;
        rst_n = 1;

        // Run some test cases
        play_round(2'b00, 2'b10); // Stone vs Scissors -> P1 wins
        play_round(2'b01, 2'b00); // Paper vs Stone -> P1 wins
        play_round(2'b10, 2'b01); // Scissors vs Paper -> P1 wins
        play_round(2'b00, 2'b01); // Stone vs Paper -> P2 wins
        play_round(2'b01, 2'b01); // Paper vs Paper -> Tie
        play_round(2'b11, 2'b00); // Invalid P1 move

        #50;
        $finish;
    end

endmodule
