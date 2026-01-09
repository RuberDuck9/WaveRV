// **************************************************
// Core Control Unit
// **************************************************

module instruction_decoder(
	input wire [31:0] instruction_register,
	output wire register_write_enable,
	output wire alu_immediate_enable,
	output wire [2:0] immediate_select,
	output wire [4:0] register_write_address,
	output wire [4:0] register_read_address_a,
	output wire [4:0] register_read_address_b,
	output reg [3:0] alu_operation
);

// ------------- Wire Declaration ------------

wire [2:0] funct3 = instruction_register[14:12];
wire [6:0] funct7 = instruction_register[31:25];

// ---------- Parse Instruction Data ---------

wire alu_register_operation           = (instruction_register[6:2] == 5'b01100); // rd <- rs1 OP rs2
wire alu_immediate_operation          = (instruction_register[6:2] == 5'b00100); // rd <- rs1 OP Iimm
wire branch_operation                 = (instruction_register[6:2] == 5'b11000); // (rs1 OP rs2) ? PC <- PC + Bimm : nothing
wire jump_and_link_pc_operation       = (instruction_register[6:2] == 5'b01111); // rd <- PC + 4; PC <- PC + Jimm
wire jump_and_link_register_operation = (instruction_register[6:2] == 5'b11001); // rd <- PC + 4; PC <- rs1 + Iimm
wire add_upper_immediate_pc_operation = (instruction_register[6:2] == 5'b00101); // rd <- PC + Uimm 
wire load_upper_immediate_operation   = (instruction_register[6:2] == 5'b01101); // rd <- Uimm
wire load_operation                   = (instruction_register[6:2] == 5'b00000); // rd <- memory[rs1 + Iimm]
wire store_operation                  = (instruction_register[6:2] == 5'b01000); // memory[rs1 + Simm] <- rs2
wire system_operation                 = (instruction_register[6:2] == 5'b11100); // reserved

// ---------- ALU Operation Control ----------

always @(*) begin
	case(funct3) 
		3'b000: alu_operation = (funct7[5] & instruction_register[5]) ? (4'b0001) : // sub
		(4'b0000); // add
		3'b001: alu_operation = 4'b0010; // register-shift left
		3'b010: alu_operation = 4'b0011; // set less than
		3'b011: alu_operation = 4'b0100; // set less than unsigned
		3'b100: alu_operation = 4'b0101; // xor
		3'b101: alu_operation = funct7[5] ? (4'b0110) : // register-shift right arithmetic
		(4'b0111); // register-shift right logical
		3'b110: alu_operation = (4'b1000); // or
		3'b111: alu_operation = (4'b1001); // and
	endcase
end

// ------ ALU Immediate Select Control ------

assign alu_immediate_enable = alu_immediate_operation ? 1'b1 : 1'b0;

// --------- Register Write Control ---------

assign register_write_address = instruction_register[11:7];
assign register_read_address_a = instruction_register[19:15];
assign register_read_address_b = instruction_register[24:20];

assign register_write_enable = alu_register_operation ? 1'b1 : 
	alu_immediate_operation ? 1'b1 :
	jump_and_link_pc_operation ? 1'b1 :
	add_upper_immediate_pc_operation ? 1'b1 :
	load_operation ? 1'b1 :
	1'b0;

// ------- Immediate Generator Control -------

assign immediate_select = alu_register_operation ? 3'b111 : // Unused 
	alu_immediate_operation ? 3'b001 : // Iimm
	branch_operation ? 3'b011 : // Bimm
	jump_and_link_register_operation ? 3'b001 : // Iimm
	add_upper_immediate_pc_operation ? 3'b000 : // Uimm
	load_upper_immediate_operation ? 3'b000 : // Uimm
	load_operation ? 3'b001 : // Iimm
	store_operation ? 3'b010 : // Simm
	system_operation ? 3'b111 : // Unused
	3'b111; // Base Case

endmodule
