module control(clk, reset, start, m_d, data_in, alu_sel, ready, wr, initial_wr, sh_right, sh_left); // Module declaration with inputs and outputs
    input clk, reset, start, m_d; // Inputs: clock, reset, start signal, mode select (m_d)
    input [1:0] data_in; // 2-bit input data
    
    output ready, wr, initial_wr, sh_right, sh_left, alu_sel; // Outputs: ready signal, write signal, initial write signal, shift right signal, shift left signal, ALU selection signal

    // Internal wires for checking conditions
    wire ready_check;
    wire wr_check;
    wire initial_wr_check;
    wire sh_right_check;
    wire sh_left_check;
    wire mul_wr;
    wire div_wr;

    // Internal registers for state and counter
    reg [1:0] state;
    reg [9:0] counter;

    // State machine behavior
    always @(posedge clk) begin
        if (reset) begin // Reset condition
            state <= 2'd0;
            counter <= 10'd0;
        end
        else begin // State transitions
            case (state) // State transitions based on current state
                2'b00: begin // Idle state
                    if (start == 1) state <= 2'b01; // Transition to load state when start signal is asserted
                end

                2'b01: begin // Load state
                    counter <= 0; // Reset counter
                    state <= 2'b10; // Transition to operation state
                end

                2'b10: begin // Operation state
                    if (counter == 63) state <= 2'b00; // Transition back to idle state after 64 cycles
                    counter <= counter + 1; // Increment counter
                end
            endcase
        end
    end
    
    // ALU selection
    assign alu_sel = m_d; // ALU selection based on m_d

    // Conditions for write signal
    assign mul_wr = data_in[0] && m_d; // Write signal for multiplication operation
    assign div_wr = !(data_in[1] || m_d); // Write signal for division operation
    assign wr_check = (state == 2'b10) && (mul_wr || div_wr); // We write when are at operation state and either mul_wr or div_wr is turned on
    assign wr = wr_check ? 1 : 0; // Write signal based on wr_check
    
    // Initial write signal condition
    assign initial_wr_check = (state == 2'b01); // Initial write when at load state
    assign initial_wr = initial_wr_check ? 1 : 0; // Initial write signal based on initial_wr_check
    
    // Shift right signal condition
    assign sh_right_check = (state == 2'b10) && m_d; // Shift right when at op state and when we multiply
    assign sh_right = sh_right_check ? 1 : 0; // Shift right signal based on sh_right_check

    // Shift left signal condition
    assign sh_left_check = (state == 2'b10) && (!m_d); // Shift left when at op state and when we divide
    assign sh_left = sh_left_check ? 1 : 0; // Shift left signal based on sh_left_check
    
    // Ready signal condition
    assign ready_check = (state == 2'b00); // Ready when on idle state
    assign ready = ready_check ? 1 : 0; // Ready signal based on ready_check
endmodule
