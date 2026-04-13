`timescale 1ns/1ps

module tb_dual_port;

parameter ADDR_WIDTH = 5;
parameter DEPTH      = 32;

reg clk, rst;
reg we_a, we_b;
reg [7:0] data_a, data_b;
reg [ADDR_WIDTH-1:0] add_a, add_b;
wire [7:0] read_a, read_b;

integer errors = 0;
integer i;
reg [7:0] expected_mem [0:31];

dual_port #(
    .DATA_WIDTH(8),
    .ADDR_WIDTH(ADDR_WIDTH)
) dut (
    .clk(clk),
    .rst(rst),
    .we_a(we_a), .we_b(we_b),
    .data_a(data_a), .data_b(data_b),
    .add_a(add_a), .add_b(add_b),
    .read_a(read_a), .read_b(read_b)
);

initial clk = 0;
always #5 clk = ~clk;


// ---------------- FILE WRITE ----------------
task write_stimulus_files;
integer fa, fb;
begin
    fa = $fopen("port_a_stim.txt", "w");
    $fdisplay(fa, "1 00 AA");
    $fdisplay(fa, "1 01 BB");
    $fdisplay(fa, "1 02 CC");
    $fdisplay(fa, "1 03 DD");
    $fdisplay(fa, "1 04 EE");
    $fdisplay(fa, "1 0A 12");
    $fdisplay(fa, "1 0F 34");
    $fdisplay(fa, "1 1F FF");
    $fdisplay(fa, "0 00 00");
    $fdisplay(fa, "0 01 00");
    $fdisplay(fa, "0 02 00");
    $fdisplay(fa, "0 03 00");
    $fdisplay(fa, "0 04 00");
    $fdisplay(fa, "0 0A 00");
    $fdisplay(fa, "0 0F 00");
    $fdisplay(fa, "0 1F 00");
    $fclose(fa);

    fb = $fopen("port_b_stim.txt", "w");
    $fdisplay(fb, "1 05 55");
    $fdisplay(fb, "1 06 66");
    $fdisplay(fb, "1 07 77");
    $fdisplay(fb, "1 08 88");
    $fdisplay(fb, "1 09 99");
    $fdisplay(fb, "1 10 A1");
    $fdisplay(fb, "1 14 B2");
    $fdisplay(fb, "1 1E C3");
    $fdisplay(fb, "0 05 00");
    $fdisplay(fb, "0 06 00");
    $fdisplay(fb, "0 07 00");
    $fdisplay(fb, "0 08 00");
    $fdisplay(fb, "0 09 00");
    $fdisplay(fb, "0 10 00");
    $fdisplay(fb, "0 14 00");
    $fdisplay(fb, "0 1E 00");
    $fclose(fb);
end
endtask


// ---------------- RESET ----------------
task apply_reset;
integer j;
begin
    rst = 1;
    we_a = 0; we_b = 0;
    data_a = 0; data_b = 0;
    add_a = 0; add_b = 0;

    for (j = 0; j < 32; j = j + 1)
        expected_mem[j] = 0;

    @(posedge clk); @(posedge clk);
    rst = 0;
end
endtask


// ---------------- PORT A ----------------
task apply_port_a_from_file;
integer fd, scan_ret;
reg [7:0] f_we, f_addr, f_data;
begin
    fd = $fopen("port_a_stim.txt", "r");

    scan_ret = $fscanf(fd, "%h %h %h\n", f_we, f_addr, f_data);

    while (!$feof(fd) && scan_ret == 3) begin
        @(negedge clk);
        add_a  = f_addr;
        data_a = f_data;
        we_a   = f_we[0];
        we_b   = 0;
        add_b  = f_addr + 1;

        @(posedge clk);   // write
        @(posedge clk);   // wait

        if (f_we[0]) begin
            expected_mem[f_addr] = f_data;
        end else begin
            if (read_a !== expected_mem[f_addr]) begin
                errors = errors + 1;
                $display("FAIL A addr=%0d exp=%0h got=%0h",
                          f_addr, expected_mem[f_addr], read_a);
            end
        end

        we_a = 0;
        scan_ret = $fscanf(fd, "%h %h %h\n", f_we, f_addr, f_data);
    end

    $fclose(fd);
end
endtask


// ---------------- PORT B ----------------
task apply_port_b_from_file;
integer fd, scan_ret;
reg [7:0] f_we, f_addr, f_data;
begin
    fd = $fopen("port_b_stim.txt", "r");

    scan_ret = $fscanf(fd, "%h %h %h\n", f_we, f_addr, f_data);

    while (!$feof(fd) && scan_ret == 3) begin
        @(negedge clk);
        add_b  = f_addr;
        data_b = f_data;
        we_b   = f_we[0];
        we_a   = 0;
        add_a  = f_addr + 1;

        @(posedge clk);
        @(posedge clk);

        if (f_we[0]) begin
            expected_mem[f_addr] = f_data;
        end else begin
            if (read_b !== expected_mem[f_addr]) begin
                errors = errors + 1;
                $display("FAIL B addr=%0d exp=%0h got=%0h",
                          f_addr, expected_mem[f_addr], read_b);
            end
        end

        we_b = 0;
        scan_ret = $fscanf(fd, "%h %h %h\n", f_we, f_addr, f_data);
    end

    $fclose(fd);
end
endtask

task clear_signals;
begin
    we_a   = 0;
    we_b   = 0;
    data_a = 0;
    data_b = 0;
    add_a  = 0;
    add_b  = 0;
end
endtask

task cross_port_verify;
input [ADDR_WIDTH-1:0] addr;
input [7:0] data;
begin
    @(negedge clk);
    clear_signals;

    we_a = 1;
    add_a = addr;
    data_a = data;

    @(posedge clk);
    @(posedge clk);

    clear_signals;

    @(negedge clk);
    add_b = addr;

    @(posedge clk);
    @(posedge clk);

    if (read_b !== data) begin
        errors = errors + 1;
        $display("FAIL CROSS addr=%0d exp=%0h got=%0h",
                  addr, data, read_b);
    end
end
endtask


task collision_test;
input [ADDR_WIDTH-1:0] addr;
input [7:0] da;
input [7:0] db;
begin
    @(negedge clk);
    we_a = 1; add_a = addr; data_a = da;
    we_b = 1; add_b = addr; data_b = db;
    @(posedge clk);
    @(posedge clk);
    we_a = 0; we_b = 0;

    expected_mem[addr] = da;

    @(negedge clk);
    add_a = addr;
    @(posedge clk);
    @(posedge clk);

    if (read_a !== da) begin
        errors = errors + 1;
        $display("FAIL COLLISION addr=%0d exp=%0h got=%0h",
                  addr, da, read_a);
    end
end
endtask


task sim_rw_diff_addr;
input [ADDR_WIDTH-1:0] wr_addr;
input [7:0] wr_data;
input [ADDR_WIDTH-1:0] rd_addr;
input [7:0] expected;
begin
    @(negedge clk);
    we_a = 1; add_a = wr_addr; data_a = wr_data;
    we_b = 0; add_b = rd_addr;
    @(posedge clk);
    @(posedge clk);
    we_a = 0;

    expected_mem[wr_addr] = wr_data;

    if (read_b !== expected) begin
        errors = errors + 1;
        $display("FAIL RW addr=%0d exp=%0h got=%0h",
                  rd_addr, expected, read_b);
    end
end
endtask


task post_reset_check;
input [ADDR_WIDTH-1:0] a_addr;
input [ADDR_WIDTH-1:0] b_addr;
begin
    @(negedge clk);
    add_a = a_addr;
    add_b = b_addr;
    @(posedge clk);
    @(posedge clk);

    if (read_a !== 0) begin
        errors = errors + 1;
        $display("FAIL RESET A addr=%0d got=%0h", a_addr, read_a);
    end

    if (read_b !== 0) begin
        errors = errors + 1;
        $display("FAIL RESET B addr=%0d got=%0h", b_addr, read_b);
    end
end
endtask


// ---------------- MAIN ----------------
initial begin
    write_stimulus_files;
    apply_reset;

    apply_port_a_from_file;
    apply_port_b_from_file;

    
    cross_port_verify(5'h0B, 8'hDE);
    cross_port_verify(5'h0C, 8'hAD);

    collision_test(5'h0D, 8'h1A, 8'h2B);

    sim_rw_diff_addr(5'h0E, 8'hF0, 5'h0A, 8'h12);

    apply_reset;
    post_reset_check(5'h00, 5'h0F);
    post_reset_check(5'h10, 5'h1F);

    #20;

    $display("\nErrors = %0d", errors);

    if (errors == 0)
        $display("PASS");
    else
        $display("FAIL");

    $finish;
end


initial begin
    #200000;
    $display("timeout");
    $finish;
end

endmodule


