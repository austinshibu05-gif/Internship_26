`timescale 1ns/1ps

//======================================
// Galois LFSR - inlined for synthesis
//======================================
module galois_lfsr_d(
    input         clk,
    input         reset,
    input  [7:0]  seed_in,
    input         load_seed,
    input         enable,
    output reg [7:0] lfsr_out
);

always @(posedge clk or posedge reset) begin
    if (reset)
        lfsr_out <= 8'hFF;
    else if (load_seed)
        lfsr_out <= (seed_in == 8'h00) ? 8'hFF : seed_in;
    else if (enable) begin
        lfsr_out[7] <= lfsr_out[0];
        lfsr_out[6] <= lfsr_out[7];
        lfsr_out[5] <= lfsr_out[6] ^ lfsr_out[0];
        lfsr_out[4] <= lfsr_out[5] ^ lfsr_out[0];
        lfsr_out[3] <= lfsr_out[4] ^ lfsr_out[0];
        lfsr_out[2] <= lfsr_out[3];
        lfsr_out[1] <= lfsr_out[2];
        lfsr_out[0] <= lfsr_out[1];
    end
end

endmodule


//======================================
// Descrambler
//======================================
module descrambler(
    input         clk,
    input         reset,
    input         data_in,
    input         data_valid,
    input  [7:0]  seed_in,
    input         load_seed,
    output reg    data_out,
    output reg    valid_out
);

wire [7:0] lfsr_out;

galois_lfsr_d lfsr_inst (
    .clk       (clk),
    .reset     (reset),
    .seed_in   (seed_in),
    .load_seed (load_seed),
    .enable    (data_valid),
    .lfsr_out  (lfsr_out)
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_out  <= 1'b0;
        valid_out <= 1'b0;
    end
    else begin
        if (data_valid) begin
            data_out  <= data_in ^ lfsr_out[0];
            valid_out <= 1'b1;
        end
        else begin
            data_out  <= 1'b0;
            valid_out <= 1'b0;
        end
    end
end

endmodule
