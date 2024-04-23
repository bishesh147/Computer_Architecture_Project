module alu(alu_out, multiply_top_in, divide_top_in, multiplicand_or_divider_in, sel); // Module declaration with inputs and output
    input [64:0] multiply_top_in; // Input for the top operand of multiplication
    input [64:0] divide_top_in; // Input for the top operand of division
    input [64:0] multiplicand_or_divider_in; // Input for either the multiplicand (in case of multiplication) or the divider (in case of division)
    input sel; // Selection input: 1 for multiplication, 0 for division

    output [64:0] alu_out; // Output of the ALU, which holds the result

    wire [64:0] sum; // Wire to hold the sum result
    wire [64:0] diff; // Wire to hold the difference result

    // Assigning the sum operation: multiplicand_or_divider_in + multiply_top_in
    assign sum = multiplicand_or_divider_in + multiply_top_in;
    // Assigning the difference operation: divide_top_in - multiplicand_or_divider_in
    assign diff = divide_top_in - multiplicand_or_divider_in;
    
    // Assigning the output of the ALU based on the selection input
    // If sel is 1, output the sum; otherwise, output the difference
    assign alu_out = sel ? sum : diff;
endmodule

