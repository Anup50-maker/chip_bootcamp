`default_nettype none
`timescale 1ns/1ps  // Time unit = 1ns, precision = 1ps

module tb_stone_paper_scissors;

    // Testbench signals
    reg clk;
    reg reset;
    reg [1:0] p1_move;
    reg [1:0] p2_move;
    reg start;
    reg mode;  

    wire [1:0] winner;
    wire [2:0] state;
    wire [2:0] debug;

    
    stone_paper_scissors uut (
        .clk(clk),
        .reset(reset),
        .p1_move(p1_move),
        .p2_move(p2_move),
        .start(start),
        .mode(mode),
        .winner(winner),
        .state(state),
        .debug(debug)
    );

    // Fast clock generator
    initial begin
        clk = 0;
        forever #1 clk = ~clk;   // Clock period = 2ns (very short)
    end

    // Test sequence
    initial begin
        // Monitor signals
        $monitor("Time=%0t | State=%b | P1=%b | P2=%b | Winner=%b | Debug=%b",
                 $time, state, p1_move, p2_move, winner, debug);

        // Initialize
        reset = 1; start = 0; mode = 0;
        p1_move = 2'b00; p2_move = 2'b00;
        #5 reset = 0;

        // Test case 1: Stone vs Scissors
        #2 start = 1; p1_move = 2'b00; p2_move = 2'b10;  
        #4 start = 0;

        // Test case 2: Paper vs Stone
        #6 start = 1; p1_move = 2'b01; p2_move = 2'b00;  
        #4 start = 0;

        // Test case 3: Tie (Scissors vs Scissors)
        #6 start = 1; p1_move = 2'b10; p2_move = 2'b10;  
        #4 start = 0;

        // Test case 4: Invalid move
        #6 start = 1; p1_move = 2'b11; p2_move = 2'b00;  
        #4 start = 0;

        // Finish simulation
        #20 $finish;
    end

endmodule
