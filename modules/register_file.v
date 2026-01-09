// **************************************************
// 32 Wide (5 bit) 32 Bit Write-before-read Register File
// **************************************************

module register_file(
	input wire clk,
	input wire rst,
	input wire register_write_enable,
	input wire data_memory_write_back_enable,
	input wire [4:0] register_write_address,
	input wire [4:0] register_read_address_a,
	input wire [4:0] register_read_address_b,
	input wire [31:0] alu_out,
	input wire [31:0] data_memory_read_data,
	output wire [31:0] register_read_data_a,
	output wire [31:0] register_read_data_b
);

// -------- Memory Write Back Control --------

wire [31:0] register_write_data = data_memory_write_back_enable ? data_memory_read_data : alu_out;

// -------------- Register File --------------

reg [31:0] register_file [0:31];

// ---------------- W/R Logic ----------------

assign register_read_data_a = register_file[register_read_address_a];
assign register_read_data_b = register_file[register_read_address_b];

always @(posedge clk) begin

	if (~rst) begin
		for (integer i = 0; i < 32; i = i + 1)
			register_file[i] <= 32'b0;
	end else begin

		if (register_write_enable) begin
			register_file[register_write_address] <= register_write_data;
		end

	end 
    
end

endmodule
