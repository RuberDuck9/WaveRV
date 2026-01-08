// **************************************************
// WaveRV Core
// **************************************************

module next_pc(
	input wire [31:0] program_counter,
	output wire [31:0] next_pc
);

assign next_pc = program_counter + 4;

endmodule

module program_counter(
	input wire clk,
	input wire[31:0] next_pc,
	output reg [31:0] program_counter
);

always @(posedge clk) begin
	program_counter <= program_counter + next_pc;
end

endmodule

module instruction_register(
	input wire clk,
	input wire [31:0] instruction_memory_read_data,
	output wire [11:7] rd,
	output wire [19:15] rs1,
	output wire [24:20] rs2
);

reg [31:0] instruction_register;

always @(posedge clk) begin
	instruction_register <= instruction_memory_read_data;
	assign instruction_register[11:7] = rd;
	assign instruction_register[19:5] = rs1;
	assign instruction_register[24:20] = rs2;
end

endmodule

module alu(
	input wire [31:0] alu_in_1,
	input wire [31:0] alu_in_2,
	input wire [4:0] operation,
 	output reg [31:0] alu_out
);

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

module immediate_generator(
	input wire [31:0] instruction_register,
	output wire [31:0] Uimm,
	output wire [31:0] Iimm,
	output wire [31:0] Simm,
	output wire [31:0] Bimm,
	output wire [31:0] Jimm
);

assign Uimm = {    instruction_register[31],   instruction_register[30:12], {12{1'b0}}};                                                  // zero extend bits 11-0
assign Iimm = {{21{instruction_register[31]}}, instruction_register[30:20]};                                                              // sign extend bits 32-11
assign Simm = {{21{instruction_register[31]}}, instruction_register[30:25], instruction_register[11:7]};                                  // sign extend bits 31-11 
assign Bimm = {{20{instruction_register[31]}}, instruction_register[7], instruction_register[30:25], instruction_register[11:8], 1'b0};   // sign extend bits 31-12, bit 0 = 0 
assign Jimm = {{12{instruction_register[31]}}, instruction_register[19:12], instruction_register[20], instruction_register[30:21], 1'b0}; // sign extend bits 31-20, bit 0 = 0

endmodule 

module control_unit(
	input wire [31:0] instruction_register,
	output wire [3:0] alu_operation
);

// Instruction
wire alu_register_operation           = (instruction_register[6:2] == 5'b01100); // rd <- rs1 OP rs2
wire alu_immediate_operation          = (instruction_register[6:2] == 5'b00100); // rd <- rs1 OP Iimm
wire branch_operation                 = (instruction_register[6:2] == 5'b11000); // (rs1 OP rs2) ? PC <- PC + Bimm : nothing
wire jump_and_link_pc_operation       = (instruction_register[6:2] == 5'b01111); // rd <- PC + 4; PC <- PC + Jimm
wire jump_and_link_register_operation = (instruction_register[6:2] == 5'b11001); // rd <- PC + 4; PC <- rs1 + Iimm
wire add_upper_immediate_pc_operation = (instruction_register[6:2] == 5'b00101); // rd <- PC + Uimm 
wire load_upper_immediate_operation   = (instruction_register[6:2] == 5'b01101); // rd <- Uimm
wire load_operation                   = (instruction_register[6:2] == 5'b00000); // rd <- memory[rs1 + Iimm]
wire store_operation                  = (instruction_register[6:2] == 5'b01000); // memory[rs1 + Simm] <- rs2
wire system_operation                 = (instruction_register[6:2] == 5'b11100); // witchcraft

wire [2:0] funct3 = instruction_register[14:12];
wire [6:0] funct7 = instruction_register[31:25];

case(funct3) 
	3'b000: alu_operation = (funct7[5] & instruction_register[5]) ? (4'b0001) : // sub
	(4'b0000); // add
	3'b001: alu_operation = 4'b0010; // register-shift left
	3'b010: alu_operation alu_operation = 4'b0011; // set less than
	3'b011: alu_operation alu_operation = 4'b0100; // set less than unsigned
	3'b100: alu_operation alu_operation = 4'b0101; // xor
	3'b101: alu_operation alu_operation = funct7[5] ? (4'b0110) : // register-shift right arithmetic
	(4'b0111); // register-shift right logical
	3'b110: alu_operation alu_operation = (4'b1000); // or
	3'b111: alu_operation alu_operation = (4'b1001); // and
endcase

endmodule
