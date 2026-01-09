// **************************************************
// Immediate Generator
// **************************************************

module immediate_generator(
	input wire [31:0] instruction_register,
	input wire [2:0] immediate_select,
	output wire [4:0] alu_shamt,
	output reg [31:0] immediate_data
);

// ---------- Parse Instruction Data ---------

wire Uimm = {    instruction_register[31],   instruction_register[30:12], {12{1'b0}}};                                                  // zero extend bits 11-0
wire Iimm = {{21{instruction_register[31]}}, instruction_register[30:20]};                                                              // sign extend bits 32-11
wire Simm = {{21{instruction_register[31]}}, instruction_register[30:25], instruction_register[11:7]};                                  // sign extend bits 31-11 
wire Bimm = {{20{instruction_register[31]}}, instruction_register[7], instruction_register[30:25], instruction_register[11:8], 1'b0};   // sign extend bits 31-12, bit 0 = 0 
wire Jimm = {{12{instruction_register[31]}}, instruction_register[19:12], instruction_register[20], instruction_register[30:21], 1'b0}; // sign extend bits 31-20, bit 0 = 0

// --------- Generate Immediate Data --------

always @(*) begin
	case(immediate_select)
		3'b000: immediate_data = Uimm; 
		3'b001: immediate_data = Iimm;
		3'b010: immediate_data = Simm;
		3'b011: immediate_data = Bimm;
		3'b100: immediate_data = Jimm;
		default: immediate_data = 8'h0; //Undefined Behavior
	endcase
end

// ------- ALU Shift Amount Calculator -------

assign alu_shamt = immediate_data[4:0];

endmodule 


