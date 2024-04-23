module multiplicand_n_divider_register(clk, reset, data_in, data_out);
    input [63:0] data_in; // Input data
    input clk, reset; // Clock and reset inputs
    output [63:0] data_out; // Output data
    reg [63:0] mul_div_reg; // Internal register to hold data

    // Sequential logic to update register on positive edge of clock
    always @(posedge clk) begin
        if (reset) // Reset condition
            mul_div_reg <= 64'd0; // Reset register to zero
        else 
            mul_div_reg <= data_in; // Update register with input data
    end
    
    // Output data is the content of the register
    assign data_out = mul_div_reg;
endmodule

