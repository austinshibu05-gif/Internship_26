module top(
    input        clk,
    input        reset,
    input        data_in,
    
    input  [7:0] seed_in,
    input        load_seed,
    output       scrambled,
    output       scrambled_valid,
    output       recovered,
    output       recovered_valid
);

reg scrambled_en,descrambled_en;
wire scrambled_valid_wire;
reg data_valid;
scrambler scr (
    .clk        (clk),
    .reset      (reset),
    .data_in    (data_in),
    .data_valid (data_valid),
    .seed_in    (seed_in),
    .load_seed  (load_seed),
    .data_out   (scrambled_en),
    .valid_out  (scrambled_valid_wire)
);

descrambler dscr (
    .clk        (clk),
    .reset      (reset),
    .data_in    (scrambled_en),
    .data_valid (scrambled_valid_wire),
    .seed_in    (seed_in),
    .load_seed  (load_seed),
    .data_out   (recovered),
    .valid_out  (recovered_valid)
);

assign scrambled       = scrambled_wire;
assign scrambled_valid = scrambled_valid_wire;
reg [1:0]state_reg;
localparam idle    =2'b00;
localparam state1 =2'b01;
localparam state2  =2'b10;


always@(posedge clk or posedge reset) begin
    if (reset) begin
        data_out  <= 0;
        valid_out <= 0;
        state_reg <= idle;
    end
    else begin
    case (state_reg)
    idle:begin
         data_out  <= 0;
        valid_out <= 0;
        state_reg <= state1;end
     state1 :begin
     scrambled_en <= 1;
     data_valid <= 1'b1;
     state_reg <= state2;end
     
    state2:begin
     descrambled_en <=1;
     data_valid <= 1'b1;
     state_reg <= state2;end
    endcase 
end
endmodule