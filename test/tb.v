`timescale 1ns/1ps
module tb_stone_paper_scissors;

    reg clk;
    reg reset;
    reg start;
    reg mode;
    reg [1:0] p1_move, p2_move;
    wire [1:0] winner;
    wire [2:0] state, debug;

`ifdef USE_POWER_PINS
    wire VPWR = 1'b1;
    wire VGND = 1'b0;
`endif

    // DUT instantiation
    tt_um_stone_paper_scissors dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .mode(mode),
        .p1_move(p1_move),
        .p2_move(p2_move),
        .winner(winner),
        .state(state),
        .debug(debug)
    `ifdef USE_POWER_PINS
        , .VPWR(VPWR),
          .VGND(VGND)
    `endif
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Init signals
        clk     = 0;
        reset   = 1;
        start   = 0;
        mode    = 0;
        p1_move = 2'b00;
        p2_move = 2'b00;

        // Reset pulse
        #20 reset = 0;

        // Test 1: Tie (both Rock)
        #10 start = 1; p1_move = 2'b00; p2_move = 2'b00;
        #20 start = 0;

        // Test 2: P1 wins (Rock vs Scissors)
        #20 start = 1; p1_move = 2'b00; p2_move = 2'b10;
        #20 start = 0;

        // Test 3: P2 wins (Paper vs Scissors)
        #20 start = 1; p1_move = 2'b01; p2_move = 2'b10;
        #20 start = 0;

        #50 $finish;
    end

endmodule
