<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project implements a Finite State Machine (FSM) in Verilog for the classic Stone–Paper–Scissors game between two players.
The design evaluates both players’ moves, checks for invalid inputs, determines the winner, and outputs the result along with the FSM state and debug information.

game options
00 : Stone

01 : Paper

10 : Scissors

11 : Invalid move
## Inputs

 Signal          Description                                     

 clk           Clock signal (synchronizes FSM transitions)     
 reset         Resets the FSM to Idle state                    
 start         Start signal to begin evaluation                
 mode          Debug mode (reserved, not used in this version) 
 p1_move[1:0]  Player 1 move (2-bit encoding)                  
 p2_move[1:0]  Player 2 move (2-bit encoding) 
 
## Outputs
Signal        Description                                                                                         

winner[1:0]`  Game result <br> `00` = Tie <br> `01` = Player 1 wins <br> `10` = Player 2 wins <br> `11` = Invalid 
state[2:0]`   FSM state (Idle, Evaluate, Result, Reset)                                                           
debug[2:0]`   Debug info showing last moves 

## Modes

Idle (000) → Waiting for start signal

Evaluate (001) → Checks player moves and determines winner

Result (010) → Displays winner until reset or next start

Reset (011) → Returns FSM to Idle


## How to test

using the "Project.v" as the base you can use the following test bench code to test this project using xilinx software 

Here the codes and respective outputs:
Testbench code :
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

and the simulation results are :
<img width="1568" height="219" alt="image" src="https://github.com/user-attachments/assets/20d5ba4a-9edc-4883-b808-24bf857532c3" />




