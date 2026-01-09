// **************************************************
// Instruction Memory (12 bit block)
// **************************************************

module instruction_memory (
	input clk,
	input instruction_memory_write_enable,
	input [31:0] instruction_memory_access_address,
	input [31:0] instruction_memory_write_data,
	output wire [31:0] instruction_memory_read_data
);

// -------------- Memory Block --------------

parameter memory_size = 4095;
reg [31:0] memory[0:memory_size];

initial $readmemh("mem.hex", memory);

// ---------------- IO Control ----------------

assign instruction_memory_read_data = instruction_memory_write_enable ? instruction_memory_write_data : memory[instruction_memory_access_address];

always @(posedge clk) begin

    if (instruction_memory_write_enable) begin
        memory[instruction_memory_access_address] <= instruction_memory_write_data;
    end

end

endmodule
