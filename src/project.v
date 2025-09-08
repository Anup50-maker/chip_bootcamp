module tt_um_stone_paper_scissors (
    input  wire clk,
    input  wire reset,
    input  wire start,
    input  wire mode,
    input  wire [1:0] p1_move,
    input  wire [1:0] p2_move,
    output reg  [1:0] winner,   // 00 = Tie, 01 = P1 wins, 10 = P2 wins
    output reg  [2:0] state,
    output reg  [2:0] debug
`ifdef USE_POWER_PINS
    , input  wire VPWR,
      input  wire VGND
`endif
);

    // Example state encoding
    localparam IDLE  = 3'b000,
               PLAY  = 3'b001,
               CHECK = 3'b010,
               DONE  = 3'b011;

    // Reset + FSM
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state   <= IDLE;
            winner  <= 2'b00;
            debug   <= 3'b000;
        end else begin
            case (state)
                IDLE: begin
                    winner <= 2'b00;
                    if (start)
                        state <= PLAY;
                end

                PLAY: begin
                    state <= CHECK;
                end

                CHECK: begin
                    // Game logic
                    if (p1_move == p2_move)
                        winner <= 2'b00; // Tie
                    else if ((p1_move == 2'b00 && p2_move == 2'b10) ||  // Rock beats Scissors
                             (p1_move == 2'b01 && p2_move == 2'b00) ||  // Paper beats Rock
                             (p1_move == 2'b10 && p2_move == 2'b01))    // Scissors beats Paper
                        winner <= 2'b01; // P1 wins
                    else
                        winner <= 2'b10; // P2 wins

                    state <= DONE;
                end

                DONE: begin
                    if (!start)
                        state <= IDLE;
                end

                default: state <= IDLE;
            endcase

            // Debug bus (for mode use or extra info)
            debug <= {mode, start, state[0]};
        end
    end

endmodule
