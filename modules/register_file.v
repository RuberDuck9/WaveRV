// **************************************************
// 32 Wide (5 bit) 32 Bit Write-before-read Register File
// **************************************************

module register_file(
	input wire clk,
	input wire register_write_enable,
	input wire [4:0] register_write_address,
	input wire [4:0] register_read_address_a,
	input wire [4:0] register_read_address_b,
	input wire [31:0] register_write_data,
	output reg [31:0] register_read_data_a,
	output reg [31:0] register_read_data_b
);

// -------------- Register File --------------

reg [31:0] register_file [0:31];

// ---------------- W/R Logic ----------------

always @(posedge clk) begin
    register_read_data_a <= register_file[register_read_address_a];
    register_read_data_b <= register_file[register_read_address_b];

	if (register_write_enable) begin
		register_file[register_write_address] <= register_write_data;

		if (register_write_address == register_read_address_a) begin
		    register_read_data_a <= register_write_data; // Write-before-read explicit implementation
		end

		if (register_write_address == register_read_address_b) begin
		    register_read_data_b <= register_write_data; // Write-before-read explicit implementation
		end  

	end 
    
end

endmodule
