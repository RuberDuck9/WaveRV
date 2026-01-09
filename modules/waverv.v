// **************************************************
// Root/Instantiator Module
// **************************************************

module waverv (
	input clk
);

// ------ Wire Declaration By Originator -----

// Program Counter
wire [31:0] program_counter;

// Memory
wire [31:0] memory_read_data_a;
wire [31:0] memory_read_data_b;

// Instruction Register
wire [31:0] instruction_register;

// Instruction Decoder
wire register_write_enable;
wire alu_immediate_enable;
wire [2:0] immediate_select;
wire [4:0] register_write_address;
wire [4:0] register_read_address_a;
wire [4:0] register_read_address_b;
wire [3:0] alu_operation;

// Register File
wire [31:0] register_read_data_a;
wire [31:0] register_read_data_b;

// Immediate Generator
wire [4:0] alu_shamt;
wire [31:0] immediate_data;

// ALU
wire [31:0] alu_out;

// ----------- Module Instantiation ----------

program_counter program_counter_inst(
	.clk(clk),
	.program_counter(program_counter)
);

memory memory_inst (
	.clk_a(clk),
	.memory_write_enable_a(1'b0),
	.memory_access_address_a(program_counter),
	.memory_write_data_a(32'b0),
	.memory_read_data_a(memory_read_data_a)
);

instruction_register instruction_register_inst (
	.clk(clk),
	.memory_read_data_a(memory_read_data_a),
	.instruction_register(instruction_register)
);

instruction_decoder instruction_decoder_inst (
	.instruction_register(instruction_register),
	.register_write_enable(register_write_enable),
	.alu_immediate_enable(alu_immediate_enable),
	.immediate_select(immediate_select),
	.register_write_address(register_write_address),
	.register_read_address_a(register_read_address_a),
	.register_read_address_b(register_read_address_b),
	.alu_operation(alu_operation)
);

register_file register_file_inst (
	.clk(clk),
	.register_write_enable(register_write_enable),
	.register_write_address(register_write_address),
	.register_read_address_a(register_read_address_a),
	.register_read_address_b(register_read_address_b),
	.register_write_data(alu_out),
	.register_read_data_a(register_read_data_a),
	.register_read_data_b(register_read_data_b)
);

immediate_generator immediate_generator_inst (
	.instruction_register(instruction_register),
	.immediate_select(immediate_select),
	.alu_shamt(alu_shamt),
	.immediate_data(immediate_data)
);

alu alu_inst (
	.alu_immediate_enable(alu_immediate_enable),
	.register_read_data_a(register_read_data_a),
	.register_read_data_b(register_read_data_b),
	.immediate_data(immediate_data),
	.alu_operation(alu_operation),
	.shamt(shamt),
	.alu_out(alu_out)
);

endmodule