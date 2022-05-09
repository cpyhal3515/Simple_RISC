`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/06 18:49:42
// Design Name: 
// Module Name: rom_test
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


module rom_test(
    input rd,
    input en,
    input [12:0] addr,
    output [7:0] data
    );

    reg [7:0] mem [13'h1ff:0];
    assign data = (en & rd)?mem[addr]:8'bzzzz_zzzz;
endmodule
