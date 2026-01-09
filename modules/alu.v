// **************************************************
// ALU 
// **************************************************

module alu(
	input wire rst,
	input wire alu_immediate_enable,
	input wire [31:0] register_read_data_a,
	input wire [31:0] register_read_data_b,
	input wire [31:0] immediate_data,
	input wire [3:0] alu_operation,
	input wire [4:0] alu_shamt,
 	output reg [31:0] alu_out
);

wire [31:0] alu_input_1 = register_read_data_a; 
wire [31:0] alu_input_2 = alu_immediate_enable ? immediate_data : register_read_data_b;

always @(*) begin
	if (~rst) begin
		alu_out <= 32'b0;
	end else begin
		case(alu_operation)
			4'b0001: alu_out <= (alu_input_1 - alu_input_2); // sub
			4'b0000: alu_out <= (alu_input_1 + alu_input_2); // add
			4'b0010: alu_out <= alu_input_1 << alu_shamt; // register-shift left
			4'b0011: alu_out <= ($signed(alu_input_1) < $signed(alu_input_2)); // set less than
			4'b0100: alu_out <= (alu_input_1 < alu_input_2); // set less than unsigned
			4'b0101: alu_out <= (alu_input_1 ^ alu_input_2); // xor
			4'b0110: alu_out <= ($signed(alu_input_1) >>> alu_shamt); // register-shift right arithmetic
			4'b0111: alu_out <= (alu_input_1 >> alu_shamt); // register-shift right logical
			4'b1000: alu_out <= (alu_input_1 | alu_input_2); // or
			4'b1001: alu_out <= (alu_input_1 & alu_input_2); // and
		endcase
	end
end

endmodule
