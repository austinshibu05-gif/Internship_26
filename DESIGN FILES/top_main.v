`timescale 1ns/1ps
module top_main(
    input        clk_pad,
    input        reset_pad,
    input        data_in_pad,
    input        data_valid_pad,        // ✅ added missing port
    input  [7:0] seed_in_pad,
    input        load_seed_pad,
    output       scrambled_pad,
    output       scrambled_valid_pad,
    output       recovered_pad,
    output       recovered_valid_pad
);

//=====================================
// ✅ All wire declarations at top
//=====================================
wire clk, reset, lfsr_clk;
wire data_in, data_valid;
wire [7:0] seed_in;
wire load_seed;
wire scrambled_wire, scrambled_valid_wire;
wire recovered_wire, recovered_valid_wire;

// FSM signals
reg [1:0] state_reg;
reg       fsm_data_valid;

localparam idle   = 2'b00;
localparam state1 = 2'b01;
localparam state2 = 2'b10;

//=====================================
// Clock Pads
//=====================================
pc3d01 pc3d01_1  (.PAD(clk_pad),   .CIN(lfsr_clk));
pc3c01 pc3c01_1  (.CCLK(lfsr_clk), .CP(clk));

//=====================================
// Input Pads
//=====================================
pc3d01 pc3d01_2  (.PAD(reset_pad),      .CIN(reset));
pc3d01 pc3d01_3  (.PAD(seed_in_pad[0]), .CIN(seed_in[0]));
pc3d01 pc3d01_4  (.PAD(seed_in_pad[1]), .CIN(seed_in[1]));
pc3d01 pc3d01_5  (.PAD(seed_in_pad[2]), .CIN(seed_in[2]));
pc3d01 pc3d01_6  (.PAD(seed_in_pad[3]), .CIN(seed_in[3]));
pc3d01 pc3d01_7  (.PAD(seed_in_pad[4]), .CIN(seed_in[4]));
pc3d01 pc3d01_8  (.PAD(seed_in_pad[5]), .CIN(seed_in[5]));
pc3d01 pc3d01_9  (.PAD(seed_in_pad[6]), .CIN(seed_in[6]));
pc3d01 pc3d01_10 (.PAD(seed_in_pad[7]), .CIN(seed_in[7]));
pc3d01 pc3d01_11 (.PAD(data_in_pad),    .CIN(data_in));
pc3d01 pc3d01_12 (.PAD(data_valid_pad), .CIN(data_valid));  // ✅ from pad
pc3d01 pc3d01_13 (.PAD(load_seed_pad),  .CIN(load_seed));

//=====================================
// Core Logic
//=====================================
scrambler scr (
    .clk        (clk),
    .reset      (reset),
    .data_in    (data_in),
    .data_valid (data_valid),           // ✅ from pad, not FSM
    .seed_in    (seed_in),
    .load_seed  (load_seed),
    .data_out   (scrambled_wire),       // ✅ wire, no multiple driver
    .valid_out  (scrambled_valid_wire)
);

descrambler dscr (
    .clk        (clk),
    .reset      (reset),
    .data_in    (scrambled_wire),
    .data_valid (scrambled_valid_wire),
    .seed_in    (seed_in),
    .load_seed  (load_seed),
    .data_out   (recovered_wire),       // ✅ separate wire
    .valid_out  (recovered_valid_wire)
);

//=====================================
// Output Pads
//=====================================
pc3o05 pc3o05_1 (.I(scrambled_wire),       .PAD(scrambled_pad));
pc3o05 pc3o05_2 (.I(scrambled_valid_wire), .PAD(scrambled_valid_pad));
pc3o05 pc3o05_3 (.I(recovered_wire),       .PAD(recovered_pad));
pc3o05 pc3o05_4 (.I(recovered_valid_wire), .PAD(recovered_valid_pad));

endmodule

