module multiply_n_divide_top(clk, reset, a_in, b_in, m_d, start, result, ready);
    input [63:0] a_in, b_in; // Input operands
    input clk, reset, start, m_d; // Clock, reset, start, and mode select inputs

    output ready; // Output ready signal
    output [128:0] result; // Output result

    wire [63:0] mul_div_reg_out; // Output from the multiplicand_n_divider_register module

    wire [64:0] alu_out; // Output from the ALU module
    wire [128:0] res_reg_out; // Output from the result_register module
    wire control_wr; // Control signal for write operation
    wire control_initial_wr; // Control signal for initial write operation
    wire control_sh_right; // Control signal for right shift operation
    wire control_alu_sel; // Control signal for ALU selection

    // Instantiate multiplicand_n_divider_register module
    multiplicand_n_divider_register mndr1(
        .clk(clk),
        .reset(reset),
        .data_in(b_in),
        .data_out(mul_div_reg_out)
    );

    // Instantiate ALU module
    alu alu1(
        .multiply_top_in(res_reg_out[128:64]),
        .divide_top_in(res_reg_out[127:63]),
        .multiplicand_or_divider_in({1'b0,mul_div_reg_out}),
        .sel(control_alu_sel),
        .alu_out(alu_out)
    );

    // Instantiate result_register module
    result_register resr1(
        .clk(clk),
        .reset(reset),
        .data_in(alu_out),
        .wr(control_wr),
        .initial_data_in(a_in),
        .initial_wr(control_initial_wr),
        .sh_right(control_sh_right),
        .sh_left(control_sh_left),
        .result(res_reg_out)
    );

    // Instantiate control module
    control cu1(
        .clk(clk),
        .reset(reset),
        .start(start),
        .m_d(m_d),
        .data_in({alu_out[64], res_reg_out[0]}),
        .alu_sel(control_alu_sel),
        .ready(ready),
        .wr(control_wr),
        .initial_wr(control_initial_wr),
        .sh_right(control_sh_right),
        .sh_left(control_sh_left)
    );

    // Assign the output result
    assign result = res_reg_out;
endmodule
