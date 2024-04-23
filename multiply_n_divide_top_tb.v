`timescale 1ps/1ps

module multiply_n_divide_top_tb;
    reg [63:0] a_in, b_in; // Input operands
    reg clk, reset, start, m_d; // Control signals

    wire ready; // Ready signal from the multiply_n_divide_top module
    wire [128:0] result; // Result output from the multiply_n_divide_top module
    wire [63:0] quotient; // Quotient output derived from the result
    wire [64:0] remainder; // Remainder output derived from the result

    integer i; // Integer for loop iteration

    // Instantiate the multiply_n_divide_top module
    multiply_n_divide_top mlndu1(clk, reset, a_in, b_in, m_d, start, result, ready);
    
    // Assign the quotient and remainder from the result
    assign quotient = result[63:0];
    assign remainder = result[128:64];

    // Toggle clock every time unit
    always #1 clk = ~clk;

    initial begin
        // Initialize signals
        reset = 1; clk = 1; a_in = 64'd0; b_in = 64'd0; start = 0; m_d = 1'b0;
        #2;
        // Release reset
        reset = 0;
        // Set initial values for operands
        a_in = 3;
        b_in = 7;

        // Start computation
        start = 1;
        m_d = 1;
        #4;

        // Main test loop
        for (i = 0; i < 200; i = i + 1) begin
            // Toggle mode every 100 iterations
            if (i == 100) m_d = !m_d;
            // Wait until ready signal is asserted
            while (ready == 0) begin
                #2;
            end
            
            // Display result based on mode
            if (m_d) begin
                $display("%d. \t time = %d \t a_in = %d \t b_in = %d \t result = %d", i+1, $time, a_in, b_in, result);
                // Check correctness of result for multiplication
                if (a_in * b_in != result) begin
                    $display("Wrong!!!");
                end
                else $display("Right!!!");
            end
            else begin
                $display("%d. \t time = %d \t a_in = %d \t b_in = %d \t quotient = %h \t remainder = %d", i+1, $time, a_in, b_in, quotient, remainder);
                // Check correctness of result for division
                if ((a_in / b_in != quotient) && (a_in % b_in != remainder)) $display("Wrong!!!");
                else $display("Right!!!");
            end
            // Prepare for next iteration
            start = 1;
            a_in = a_in * 7;
            b_in = b_in * 3;
            #2;
        end 
        // Finish simulation after 10 time units
        #10 $finish;
    end
endmodule
