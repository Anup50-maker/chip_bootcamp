

module tt_um_stone_paper_scissors (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output reg  [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: input path (unused)
    output wire [7:0] uio_out,  // IOs: output path (unused)
    output wire [7:0] uio_oe,   // IOs: enable path (0 = input, 1 = output)

    input  wire clk,            // clock (unused in this version)
    input  wire rst_n,          // reset (unused in this version)
    input  wire ena,             // enable (unused in this version)

    input  wire vccd1,          // User area 1 1.8V supply
    input  wire vssd1           // User area 1 digital ground

);

    // -------------------
    // Input mapping
    // -------------------
    wire [1:0] p1_move = ui_in[1:0];   // Player 1 move
    wire [1:0] p2_move = ui_in[3:2];   // Player 2 move

    // -------------------
    // Winner logic
    // -------------------
    reg [1:0] winner;   // 00 = Tie, 01 = P1 wins, 10 = P2 wins, 11 = Invalid

    always @(*) begin
        winner = 2'b00; // default Tie
        case (p1_move)
            2'b00: begin // Stone
                if (p2_move == 2'b10) winner = 2'b01; // P1 wins (Stone beats Scissors)
                else if (p2_move == 2'b01) winner = 2'b10; // P2 wins (Paper beats Stone)
            end
            2'b01: begin // Paper
                if (p2_move == 2'b00) winner = 2'b01; // P1 wins (Paper beats Stone)
                else if (p2_move == 2'b10) winner = 2'b10; // P2 wins (Scissors beats Paper)
            end
            2'b10: begin // Scissors
                if (p2_move == 2'b01) winner = 2'b01; // P1 wins (Scissors beats Paper)
                else if (p2_move == 2'b00) winner = 2'b10; // P2 wins (Stone beats Scissors)
            end
            default: winner = 2'b11; // Invalid
        endcase
    end

    // -------------------
    // Output mapping
    // -------------------
    always @(*) begin
        case (winner)
            2'b00: uo_out = 8'd0;   // Tie
            2'b01: uo_out = 8'd49;  // '1' → Player 1 wins
            2'b10: uo_out = 8'd50;  // '2' → Player 2 wins
            2'b11: uo_out = 8'd63;  // '?' Invalid
            default: uo_out = 8'd0;
        endcase
    end

    // -------------------
    // No bidirectional IOs used
    // -------------------
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
