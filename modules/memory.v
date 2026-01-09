// **************************************************
// Full Dual-Port Memory (12 bit block)
// **************************************************

module memory (
	input clk_a,
	input memory_write_enable_a,
	input [31:0] memory_access_address_a,
	input [31:0] memory_write_data_a,
	output reg [31:0] memory_read_data_a,
	
	input clk_b,
	input memory_write_enable_b,
	input [31:0] memory_access_address_b,
	input [31:0] memory_write_data_b,
	output reg [31:0] memory_read_data_b
);

// -------------- Memory Block --------------

reg [31:0] memory[0:4095];

initial $readmemh("mem.hex", memory);

// ----------------- Port A -----------------

always @(posedge clk_a) begin
    memory_read_data_a <= memory[memory_access_address_a];

    if (memory_write_enable_a) begin
        memory_read_data_a <= memory_write_data_a; // Write-before-read explicit implementation
        memory[memory_access_address_a] <= memory_write_data_a;
    end

end

// ----------------- Port B -----------------

always @(posedge clk_b) begin
    memory_read_data_b <= memory[memory_access_address_b];

    if (memory_write_enable_b) begin
        memory_read_data_b <= memory_write_data_b; // Write-before-read explicit implementation
        memory[memory_access_address_b] <= memory_write_data_b;
    end
    
end

endmodule
