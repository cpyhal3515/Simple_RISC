`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/06 18:54:07
// Design Name: 
// Module Name: ram_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ram_test(
    input en,
    input rd,
    input wr,
    input [9:0] addr,
    inout [7:0] data
    );

    reg [7:0] mem [10'h3ff:0];

    assign data = (rd & en)? mem[addr] : 8'bzzzz_zzzz;

    always@(posedge wr) begin
        mem[addr] <= data;
    end




endmodule
