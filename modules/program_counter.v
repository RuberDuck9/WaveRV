// **************************************************
// Program Counter
// **************************************************

module program_counter(
	input wire clk,
	output reg[31:0] program_counter
);

always @(posedge clk) begin
	program_counter <= program_counter + 4;
end

endmodule
