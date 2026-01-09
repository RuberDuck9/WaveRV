// **************************************************
// Program Counter
// **************************************************

module program_counter(
	input wire clk,
	input wire rst,
	output reg[31:0] program_counter
);

always @(posedge clk) begin

	if (rst) begin
			program_counter <= 32'b0;
	end
	else begin 
		program_counter <= program_counter + 1;
	end
	
end

endmodule
