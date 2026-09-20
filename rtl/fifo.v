module fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 8
)(
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output full,
    output empty
);
    // FIFO memory: 8 locations, 8 bits each
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    // Read and write pointers
    reg [2:0] wr_ptr;
    reg [2:0] rd_ptr;
    // Number of data items currently stored
    reg [3:0] count;
    // Full and empty status flags
    assign full  = (count == DEPTH);
    assign empty = (count == 0);
    // FIFO sequential logic
    always @(posedge clk) begin
        // Synchronous reset
        if (rst) begin
            wr_ptr   <= 3'b000;
            rd_ptr   <= 3'b000;
            count    <= 4'b0000;
            data_out <= 8'b00000000;
        end
        else begin
            // Write operation
            if (wr_en && !full) begin
                mem[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1'b1;
            end
            // Read operation
            if (rd_en && !empty) begin
                data_out <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1'b1;
            end
            // Update FIFO count
            case ({wr_en && !full, rd_en && !empty})
                // Write only
                2'b10:
                    count <= count + 1'b1;
                // Read only
                2'b01:
                    count <= count - 1'b1;
                // No operation OR simultaneous read/write
                2'b00,
                2'b11:
                    count <= count;
            endcase
        end
    end
endmodule