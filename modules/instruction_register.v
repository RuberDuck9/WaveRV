module instruction_register (
    input wire clk,
    input wire rst,
    input wire [31:0] instruction_memory_read_data,
    output reg [31:0] instruction_register
);

always @(posedge clk) begin

    if (~rst) begin
        instruction_register <= 32'b0;
    end 
    else begin
        instruction_register <= instruction_memory_read_data;
    end
    
end

endmodule
