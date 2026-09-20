`timescale 1ns/1ps
module fifo_tb;
integer error_count;
    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire full;
    wire empty;
    // Instantiate FIFO
    fifo uut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    // Waveform generation
    initial begin
        $dumpfile("sim/fifo.vcd");
        $dumpvars(0, fifo_tb);
    end
    // Main test
    initial begin
        // Initial values
        rst     = 1;
        wr_en   = 0;
        rd_en   = 0;
        data_in = 8'h00;
        error_count = 0;
        // RESET TEST
        $display("================================");
        $display("TEST 1: RESET");
        $display("================================");
        @(posedge clk);
        #1;
        rst = 0;
        if (empty == 1 && full == 0)
            $display("PASS: Reset successful");
        else begin
            $display("FAIL: Reset failed");
            error_count = error_count + 1;
        end
        // WRITE TEST
        $display("");
        $display("================================");
        $display("TEST 2: WRITE");
        $display("================================");
        write_data(8'h11);
        write_data(8'h22);
        write_data(8'h33);
        write_data(8'h44);
        if (empty == 0)
          $display("PASS: FIFO contains data");
        else begin
           $display("FAIL: FIFO incorrectly empty");
           error_count = error_count + 1;
        end
        // READ TEST
        $display("");
        $display("================================");
        $display("TEST 3: READ");
        $display("================================");
        read_data(8'h11);
        read_data(8'h22);
        read_data(8'h33);
        read_data(8'h44);
        // EMPTY TEST
        $display("");
        $display("================================");
        $display("TEST 4: EMPTY CONDITION");
        $display("================================");
        if (empty == 1)
            $display("PASS: EMPTY flag asserted");
        else begin
            $display("FAIL: EMPTY flag not asserted");
            error_count = error_count + 1;
        end
        // FILL FIFO
        $display(" ");
        $display("================================");
        $display("TEST 5: FULL CONDITION");
        $display("================================");
        write_data(8'hA0);
        write_data(8'hA1);
        write_data(8'hA2);
        write_data(8'hA3);
        write_data(8'hA4);
        write_data(8'hA5);
        write_data(8'hA6);
        write_data(8'hA7);
        if (full == 1)
            $display("PASS: FULL flag asserted");
        else begin
            $display("FAIL: FULL flag not asserted");
            error_count = error_count + 1;
        end    
        // WRITE WHEN FULL
        $display("");
        $display("================================");
        $display("TEST 6: WRITE WHEN FULL");
        $display("================================");
        @(negedge clk);
        wr_en   = 1;
        data_in = 8'hFF;
        @(posedge clk);
        #1;
        wr_en = 0;
        if (full == 1)
            $display("PASS: Write blocked when FULL");
        else begin
            $display("FAIL: FIFO full protection failed");
            error_count = error_count + 1;
        end    
        // READ AFTER FULL
        $display("");
        $display("================================");
        $display("TEST 7: READ AFTER FULL");
        $display("================================");
        read_data(8'hA0);
        if (full == 0)
            $display("PASS: FULL cleared after read");
        else begin
            $display("FAIL: FULL did not clear"); 
            error_count = error_count + 1;
        end    
// SIMULTANEOUS READ/WRITE
$display("");
$display("================================");
$display("TEST 8: SIMULTANEOUS READ/WRITE");
$display("================================");
@(negedge clk);
wr_en   = 1;
rd_en   = 1;
data_in = 8'h55;
@(posedge clk);
#1;
wr_en = 0;
rd_en = 0;
if (data_out == 8'hA1)
    $display("PASS: Simultaneous read returned correct data 0xA1");
else begin
    $display(
        "FAIL: Simultaneous read expected 0xA1, got 0x%h",
        data_out
    );
    error_count = error_count + 1;
end    
if (uut.count == 7)
    $display("PASS: FIFO count remains 7");
else begin
    $display(
        "FAIL: FIFO count expected 7, got %0d",
        uut.count
    );
    error_count = error_count + 1;
    end
    $display("================================");
        $display("TEST 9: RESET DURING OPERATION");
        $display("================================");
        write_data(8'h99);
        write_data(8'h88);
        rst = 1;
        @(posedge clk);
        #1;
        rst = 0;
        if (empty == 1 && full == 0)
            $display("PASS: Reset during operation successful");
        else begin
            $display("FAIL: Reset during operation failed");
            error_count = error_count + 1;
        end    
        // FINISH
       $display("");
$display("========================================");
$display("       FIFO VERIFICATION SUMMARY");
$display("========================================");
if (error_count == 0) begin
    $display("RESULT : PASS");
    $display("ERRORS : %0d", error_count);
end
else begin
    $display("RESULT : FAIL");
    $display("ERRORS : %0d", error_count);
end
$display("========================================");
$display("FIFO VERIFICATION COMPLETED");

#10;
$finish;
    end
    // WRITE TASK
    task write_data;
        input [7:0] data;
        begin
            @(negedge clk);
            if (!full) begin
                wr_en   = 1;
                rd_en   = 0;
                data_in = data;
                @(posedge clk);
                #1;
                wr_en = 0;
                $display("WRITE: 0x%h", data);
            end
            else begin
                $display("WRITE BLOCKED: FIFO FULL");
            end
        end
    endtask
    // READ TASK
    task read_data;
        input [7:0] expected_data;
        begin
            @(negedge clk);
            if (!empty) begin
                wr_en = 0;
                rd_en = 1;
                @(posedge clk);
                #1;
                rd_en = 0;
                if (data_out == expected_data)
                    $display(
                        "READ PASS: Expected=0x%h Actual=0x%h",
                        expected_data,
                        data_out
                    );
                else
                    $display(
                        "READ FAIL: Expected=0x%h Actual=0x%h",
                        expected_data,
                        data_out
                    );
            end
            else begin
                $display("READ BLOCKED: FIFO EMPTY");
            end
        end
    endtask
endmodule