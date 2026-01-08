// **************************************************
// Root/Instantiator Module
// **************************************************

module waverv (
	input clk
);

// ------------- Wire Declaration ------------

// ALU
wire alu_immediate_enable;
wire [31:0] register_read_data_a;
wire [31:0] register_read_data_b;
wire [31:0] immediate_data;
wire [3:0] operation;
wire [31:0] alu_out;

// Program Counter
wire program_counter;

// ----------- Module Instantiation ----------

program_counter program_counter_inst (

endmodule
