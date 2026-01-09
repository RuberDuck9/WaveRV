// **************************************************
// Root/Instantiator Module
// **************************************************

module waverv (
	input clk,
	input rst
);

// ------ Wire Declaration By Originator -----

// Program Counter
wire [31:0] program_counter;

// Memory
wire [31:0] instruction_memory_read_data;
wire [31:0] data_memory_read_data;

// Instruction Register
wire [31:0] instruction_register;

// Instruction Decoder
wire register_write_enable;
wire alu_immediate_enable;
wire [2:0] immediate_select;
wire [4:0] register_write_address;
wire [4:0] register_read_address_a;
wire [4:0] register_read_address_b;
wire data_memory_write_enable;
wire data_memory_write_back_enable;
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
	.rst(rst),
	.program_counter(program_counter)
);

instruction_memory instruction_memory_inst (
	.clk(clk),
	.instruction_memory_write_enable(1'b0),
	.instruction_memory_access_address(program_counter),
	.instruction_memory_write_data(32'b0),
	.instruction_memory_read_data(instruction_memory_read_data)
);

data_memory data_memory_inst (
	.clk(clk),
	.rst(rst),
	.data_memory_write_enable(data_memory_write_enable),
	.data_memory_access_address(alu_out),
	.data_memory_write_data(register_read_data_b),
	.data_memory_read_data(data_memory_read_data)
);

instruction_register instruction_register_inst (
	.clk(clk),
	.rst(rst),
	.instruction_memory_read_data(instruction_memory_read_data),
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
	.data_memory_write_enable(data_memory_write_enable),
	.data_memory_write_back_enable(data_memory_write_back_enable),
	.alu_operation(alu_operation)
);

register_file register_file_inst (
	.clk(clk),
	.rst(rst),
	.register_write_enable(register_write_enable),
	.register_write_address(register_write_address),
	.register_read_address_a(register_read_address_a),
	.register_read_address_b(register_read_address_b),
	.data_memory_write_back_enable(data_memory_write_back_enable),
	.alu_out(alu_out),
	.data_memory_read_data(data_memory_read_data),
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
	.rst(rst),
	.alu_immediate_enable(alu_immediate_enable),
	.register_read_data_a(register_read_data_a),
	.register_read_data_b(register_read_data_b),
	.immediate_data(immediate_data),
	.alu_operation(alu_operation),
	.alu_shamt(alu_shamt),
	.alu_out(alu_out)
);

endmodule
