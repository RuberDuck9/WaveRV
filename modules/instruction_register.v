module instruction_register (
    input wire clk,
    input wire rst,
    input wire [31:0] memory_read_data_a,
    output reg [31:0] instruction_register
);

always @(posedge clk) begin

    if (rst) begin
        instruction_register <= 32'b0;
    end 
    else begin
        instruction_register <= memory_read_data_a;
    end
    
end

endmodule