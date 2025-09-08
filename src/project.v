module tt_um_stone_paper_scissors (
    input  wire [7:0] ui_in,    // **FIXED**: Correct vector syntax [7:0]
    output reg  [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: input path
    output wire [7:0] uio_out,  // IOs: output path (unused)
    output wire [7:0] uio_oe,   // IOs: enable path (0 = input, 1 = output)

    input  wire clk,      // clock
    input  wire rst_n,    // reset
    input  wire ena       // enable
);

    // Registers to safely capture the inputs
    reg [1:0] p1_move_reg;
    reg [1:0] p2_move_reg;
    
    // Main synchronous block
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers to a known state
            uo_out <= 8'd0;
            p1_move_reg <= 2'b0;
            p2_move_reg <= 2'b0;
        end else if (ena) begin
            // **Step 1: On the first clock cycle, capture the inputs.**
            p1_move_reg <= ui_in[1:0];
            p2_move_reg <= ui_in[3:2];

            // **Step 2: On the next cycle, calculate the result based on PREVIOUSLY captured inputs and update the output.**
            // A temporary variable to hold the calculated winner for this cycle.
            reg [1:0] winner; 

            // All logic is now inside the clocked block.
            if (p1_move_reg > 2'b10 || p2_move_reg > 2'b10) begin
                winner = 2'b11; // Invalid move
            end else if (p1_move_reg == p2_move_reg) begin
                winner = 2'b00; // Tie
            end else if ((p1_move_reg == 2'b00 && p2_move_reg == 2'b10) || // Stone vs Scissors
                         (p1_move_reg == 2'b01 && p2_move_reg == 2'b00) || // Paper vs Stone
                         (p1_move_reg == 2'b10 && p2_move_reg == 2'b01)) begin // Scissors vs Paper
                winner = 2'b01; // Player 1 wins
            end else begin
                winner = 2'b10; // Player 2 wins
            end

            // Assign the final output value based on the calculated winner.
            case (winner)
                2'b00: uo_out <= 8'd0;    // Tie
                2'b01: uo_out <= 8'd49;   // '1' -> Player 1 wins
                2'b10: uo_out <= 8'd50;   // '2' -> Player 2 wins
                2'b11: uo_out <= 8'd63;   // '?' -> Invalid
                default: uo_out <= 8'd0;
            endcase
        end
    end

    // No bidirectional IOs used
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
