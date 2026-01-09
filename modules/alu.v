// **************************************************
// ALU 
// **************************************************

module alu(
	input wire alu_immediate_enable,
	input wire [31:0] register_read_data_a,
	input wire [31:0] register_read_data_b,
	input wire [31:0] immediate_data,
	input wire [3:0] alu_operation,
	input wire [4:0] shamt,
 	output reg [31:0] alu_out
);

wire alu_input_1 = register_read_data_a; 
wire alu_input_2 = alu_immediate_enable ? immediate_data : register_read_data_b;

always @(*) begin
	case(alu_operation)
		4'b0001: alu_out = (alu_input_1 - alu_input_2); // sub
		4'b0000: alu_out = (alu_input_1 + alu_input_2); // add
		4'b0010: alu_out = alu_input_1 << shamt; // register-shift left
		4'b0011: alu_out = ($signed(alu_input_1) < $signed(alu_input_2)); // set less than
		4'b0100: alu_out = (alu_input_1 < alu_input_2); // set less than unsigned
		4'b0101: alu_out = (alu_input_1 ^ alu_input_2); // xor
		4'b0110: alu_out = ($signed(alu_input_1) >>> shamt); // register-shift right arithmetic
		4'b0111: alu_out = (alu_input_1 >> shamt); // register-shift right logical
		4'b1000: alu_out = (alu_input_1 | alu_input_2); // or
		4'b1001: alu_out = (alu_input_1 & alu_input_2); // and
	endcase
end

endmodule