module result_register(clk, reset, data_in, wr, initial_data_in, initial_wr, sh_right, sh_left, result);
    input [64:0] data_in; // Input data
    input [63:0] initial_data_in; // Initial data input
    input clk, reset, wr, initial_wr, sh_right, sh_left; // Clock, reset, write, initial write, shift right, and shift left inputs

    output [128:0] result; // Output result

    reg [128:0] result_reg; // Internal register to hold result

    // Sequential logic to update result register on positive edge of clock
    always @(posedge clk) begin
        if (reset) // Reset condition
            result_reg <= 129'd0; // Reset result register to zero
        else begin
            if (initial_wr == 1) // Initial write condition
                result_reg <= {65'd0, initial_data_in}; // Load initial data into result register
            else begin
                if (wr && sh_right) // Write and shift right condition
                    result_reg <= {1'd0, data_in, result_reg[63:1]}; 
                else if (wr && sh_left) // Write and shift left condition
                    result_reg <= {data_in, result_reg[62:0], 1'b1};
                else if (sh_right) // Shift right condition
                    result_reg <= {1'd0, result_reg[128:1]};
                else if (sh_left) // Shift left condition
                    result_reg <= {result_reg[127:0], 1'b0};
            end
        end
    end

    // Output result is the content of the result register
    assign result = result_reg;
endmodule
