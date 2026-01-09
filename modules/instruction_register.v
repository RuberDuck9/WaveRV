module instruction_register (
    input wire clk,
    input wire [31:0] memory_read_data_a,
    output reg [31:0] instruction_register
);

always @(posedge clk) begin
    instruction_register <= memory_read_data_a;
end

endmodule