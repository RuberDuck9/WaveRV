`timescale 1ps/1ps

module test_bench;

reg clk;
reg rst;

waverv waverv_inst (
    .clk(clk),
    .rst(rst)
);

initial begin 

    $dumpfile("counter.vcd");
    $dumpvars(0, test_bench);

    rst = 0;
    #5;
    rst = 1;

    #1000;
    $finish;

end

initial clk = 0;
always #1 clk = ~clk;

endmodule
