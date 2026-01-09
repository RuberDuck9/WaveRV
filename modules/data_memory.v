// **************************************************
// Data Memory (12 bit block)
// **************************************************

module data_memory (
	input clk,
	input rst,
	input data_memory_write_enable,
	input [31:0] data_memory_access_address,
	input [31:0] data_memory_write_data,
	output wire [31:0] data_memory_read_data
);

// -------------- Memory Block --------------

parameter memory_size = 4095;
reg [31:0] memory[0:memory_size];

// ---------------- IO Control ----------------

assign data_memory_read_data = data_memory_write_enable ? data_memory_write_data : memory[data_memory_access_address];

always @(posedge clk) begin

    if (~rst) begin
    	for (integer i = 0; i < memory_size; i = i + 1) begin
		memory[i] <= 32'b0;
	end
    end else if (data_memory_write_enable) begin
        memory[data_memory_access_address] <= data_memory_write_data;
    end
    
end

endmodule
