`timescale 1ns/1ps

module tb_traffic_light_4way;

    reg  clk, rst_n;
    wire ns_red, ns_yellow, ns_green;
    wire ew_red, ew_yellow, ew_green;

    traffic_light_4way dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .ns_red   (ns_red),
        .ns_yellow(ns_yellow),
        .ns_green (ns_green),
        .ew_red   (ew_red),
        .ew_yellow(ew_yellow),
        .ew_green (ew_green)
    );

    
    initial clk = 0;
    always #5 clk = ~clk;

    
    task print_state;
        $display("t=%0t | NS: R=%b Y=%b G=%b | EW: R=%b Y=%b G=%b",
            $time,
            ns_red, ns_yellow, ns_green,
            ew_red, ew_yellow, ew_green);
    endtask

    initial begin
        $dumpfile("traffic.vcd");
        $dumpvars(0, tb_traffic_light_4way);

        
        rst_n = 0;
        repeat(3) @(posedge clk);
        rst_n = 1;

        
        repeat(60) begin
            @(posedge clk);
            print_state;
        end

        $finish;
    end

endmodule
