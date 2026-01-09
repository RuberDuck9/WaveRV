`timescale 1ps/1ps

module test_bench;

reg clk;

waverv waverv_inst (
    .clk(clk)
);

initial begin 
    $dumpfile("counter.vcd");
    $dumpvars(0, tb_counter);

    #1000;
    $finish;
end

initial clk = 0;
always #5 clk = ~clk;

endmodule