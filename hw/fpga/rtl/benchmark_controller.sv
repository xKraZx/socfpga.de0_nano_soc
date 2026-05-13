
module benchmark_controller
    import benchmark_regs_pkg::*;
(
    input  logic        clk,
    input  logic        rst_n,

    output logic        avalon_slave_waitrequest,
    output logic [1:0]  avalon_slave_response,
    output logic        avalon_slave_readdatavalid,
    output logic        avalon_slave_writeresponsevalid,
    output logic [31:0] avalon_slave_readdata,
    input logic [11:0]  avalon_slave_address,
    input logic         avalon_slave_read,
    input logic         avalon_slave_write,
    input logic [3:0]   avalon_slave_byteenable,
    input logic [31:0]  avalon_slave_writedata
);

logic [31:0] avalon_slave_readdata_nxt;
logic        avalon_slave_readdatavalid_nxt, avalon_slave_writeresponsevalid_nxt;

benchmark_regs u0 (
    .clk,
    .arst_n(rst_n),

    .avalon_read(avalon_slave_read),
    .avalon_write(avalon_slave_write),
    .avalon_waitrequest(avalon_slave_waitrequest),
    .avalon_address(avalon_slave_address[11:2]),
    .avalon_writedata(avalon_slave_writedata),
    .avalon_byteenable(avalon_slave_byteenable),
    .avalon_readdatavalid(avalon_slave_readdatavalid_nxt),
    .avalon_writeresponsevalid(avalon_slave_writeresponsevalid_nxt),
    .avalon_readdata(avalon_slave_readdata_nxt),
    .avalon_response(avalon_slave_response)
);

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        avalon_slave_readdatavalid <= 1'b0;
        avalon_slave_writeresponsevalid <= 1'b0;
        avalon_slave_readdata <= 32'b0;
    end else begin
        avalon_slave_readdatavalid <= avalon_slave_readdatavalid_nxt;
        avalon_slave_writeresponsevalid <= avalon_slave_writeresponsevalid_nxt;
        avalon_slave_readdata <= avalon_slave_readdata_nxt;
    end
end

endmodule