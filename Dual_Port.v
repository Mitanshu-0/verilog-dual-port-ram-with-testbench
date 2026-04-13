
module dual_port #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 5
)(
    input  wire                   clk,
    input  wire                   rst,

    input  wire                   we_a,
    input  wire [ADDR_WIDTH-1:0]  add_a,
    input  wire [DATA_WIDTH-1:0]  data_a,
    output reg  [DATA_WIDTH-1:0]  read_a,

    input  wire                   we_b,
    input  wire [ADDR_WIDTH-1:0]  add_b,
    input  wire [DATA_WIDTH-1:0]  data_b,
    output reg  [DATA_WIDTH-1:0]  read_b
);

    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    integer i;

    always @(posedge clk) begin
        if (rst) begin
            read_a <= {DATA_WIDTH{1'b0}};
            for (i = 0; i < (1<<ADDR_WIDTH); i = i + 1)
                mem[i] <= {DATA_WIDTH{1'b0}};
        end else begin
            if (we_a) begin
                if (we_b && (add_a == add_b)) begin
                    mem[add_a] <= data_a;
                   
                end else begin
                    mem[add_a] <= data_a;
                    
                end
            end else begin
                if (we_b && (add_a == add_b)) begin
                    read_a <= mem[add_a];
                end else begin
                    read_a <= mem[add_a];
                end
            end
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            read_b <= {DATA_WIDTH{1'b0}};
        end else begin
            if (we_b) begin
                if (we_a && (add_a == add_b)) begin
                    
                end else begin
                    mem[add_b] <= data_b;
                    
                end
            end else begin
                if (we_a && (add_a == add_b)) begin
                    read_b <= mem[add_b];
                end else begin
                    read_b <= mem[add_b];
                end
            end
        end
    end

endmodule