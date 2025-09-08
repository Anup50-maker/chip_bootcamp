module tt_um_stone_paper_scissors (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output reg  [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: input path
    output wire [7:0] uio_out,  // IOs: output path (unused)
    output wire [7:0] uio_oe,   // IOs: enable path (0 = input, 1 = output)

    input  wire clk,      // clock
    input  wire rst_n,    // reset
    input  wire ena       // enable
);

    // **NEW**: Registers to safely capture the inputs
    reg [1:0] p1_move_reg;
    reg [1:0] p2_move_reg;

    // Combinational logic to determine the winner based on STABLE registered inputs
    wire [1:0] winner; // 00 = Tie, 01 = P1 wins, 10 = P2 wins, 11 = Invalid
    
    // This logic now uses the stable "_reg" versions
    assign winner = (p1_move_reg == p2_move_reg) ? 2'b00 : // Tie
                  (p1_move_reg == 2'b00 && p2_move_reg == 2'b10) ? 2'b01 : // P1: Stone beats Scissors
                  (p1_move_reg == 2'b01 && p2_move_reg == 2'b00) ? 2'b01 : // P1: Paper beats Stone
                  (p1_move_reg == 2'b10 && p2_move_reg == 2'b01) ? 2'b01 : // P1: Scissors beats Paper
                  (p2_move_reg == 2'b00 && p1_move_reg == 2'b10) ? 2'b10 : // P2: Stone beats Scissors
                  (p2_move_reg == 2'b01 && p1_move_reg == 2'b00) ? 2'b10 : // P2: Paper beats Stone
                  (p2_move_reg == 2'b10 && p1_move_reg == 2'b01) ? 2'b10 : // P2: Scissors beats Paper
                  2'b11; // Any other combination is invalid

    // Main synchronous block
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers to a known state
            uo_out <= 8'd0;
            p1_move_reg <= 2'b0;
            p2_move_reg <= 2'b0;
        end else if (ena) begin
            // **Step 1: On the first clock cycle, capture the inputs**
            p1_move_reg <= ui_in[1:0];
            p2_move_reg <= ui_in[3:2];

            // **Step 2: On the second clock cycle, the output reflects the result of the previously captured inputs**
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
