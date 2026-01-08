// **************************************************
// ALU 
// **************************************************

module alu(
	input wire alu_immediate_enable,
	input wire [31:0] register_read_data_a,
	input wire [31:0] register_read_data_b,
	input wire [31:0] immediate_data,
	input wire [3:0] operation,
 	output reg [31:0] alu_out
);

wire alu_input_1 = register_read_data_a; 
wire alu_input_2 = alu_immediate_enable ? immediate_data : register_read_data_b;

always @(*) begin
	case(funct3)
		3'b000: alu_out = (funct7[5] & instruction_register[5]) ? (alu_in_1 - alu_in_2) : (alu_in_1 + alu_in_2); // if bit 5 of funct7 and the instruction register are high it must be a reg-reg operation, otherwise it must be a reg-imm operation (and also and add)
		3'b001: alu_out = alu_in_1 << shamt; // register-shift left
		3'b010: alu_out = ($signed(alu_in_1) < $signed(alu_in_2)); // set less than
		3'b011: alu_out = (alu_in_1 < alu_in_2); // set less than unsigned
		3'b100: alu_out = (alu_in_1 ^ alu_in_2); // xor
		3'b101: alu_out = funct7[5] ? ($signed(alu_in_1) >>> shamt) : (alu_in_1 >> shamt); // register-shift right logical or arthimetic depdning on funct7 bit 5
		3'b110: alu_out = (alu_in_1 | alu_in_2); // or
		3'b111: alu_out = (alu_in_1 & alu_in_2); // and
	endcase
end

endmodule


