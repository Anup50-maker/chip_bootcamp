/*
 * Stone-Paper-Scissors Game
 * Clean version for testbench compatibility
 */

module tt_um_stone_paper_scissors (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output reg  [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: input path
    output wire [7:0] uio_out,  // IOs: output path
    output wire [7:0] uio_oe,   // IOs: enable path (0 = input, 1 = output)

    input  wire clk,            // clock
    input  wire rst_n,          // reset (active low)
    input  wire ena             // enable
);

    // Input mapping
    wire [1:0] p1_move = ui_in[1:0];   // Player 1 move
    wire [1:0] p2_move = ui_in[3:2];   // Player 2 move
    wire start        = ui_in[4];      // Start signal

    // Internal signals
    reg [1:0] winner;   // 00 = Tie, 01 = P1 wins, 10 = P2 wins, 11 = Invalid
    reg [2:0] state;    // FSM state

    // State Encoding
    localparam S_IDLE     = 3'b000,
               S_EVALUATE = 3'b001,
               S_RESULT   = 3'b010;

    reg [2:0] next_state;

    // Sequential logic for state transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    // FSM next state and winner logic
    always @(*) begin
        next_state = state;
        winner = 2'b00;     // Default tie

        case(state)
            S_IDLE: begin
                if (start)
                    next_state = S_EVALUATE;
            end

            S_EVALUATE: begin
                if (p1_move == 2'b11 || p2_move == 2'b11) begin
                    winner = 2'b11; // Invalid
                end
                else if (p1_move == p2_move) begin
                    winner = 2'b00; // Tie
                end
                else begin
                    case(p1_move)
                        2'b00: winner = (p2_move == 2'b10) ? 2'b01 : 2'b10; // Stone
                        2'b01: winner = (p2_move == 2'b00) ? 2'b01 : 2'b10; // Paper
                        2'b10: winner = (p2_move == 2'b01) ? 2'b01 : 2'b10; // Scissors
                        default: winner = 2'b11;
                    endcase
                end
                next_state = S_RESULT;
            end

            S_RESULT: begin
                if (!start)
                    next_state = S_IDLE;
            end

            default: next_state = S_IDLE;
        endcase
    end

    // Output mapping:
    // Lower 2 bits carry the winner code
    // Upper bits carry "pretty numbers" for cocotb compatibility
    always @(*) begin
        case (winner)
            2'b00: uo_out = 8'b00000000;       // Tie
            2'b01: uo_out = 8'b00000001;       // P1 wins
            2'b10: uo_out = 8'b00000010;       // P2 wins
            2'b11: uo_out = 8'b00000011;       // Invalid
            default: uo_out = 8'b00000000;
        endcase
    end

    // No bidirectional IOs used
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
