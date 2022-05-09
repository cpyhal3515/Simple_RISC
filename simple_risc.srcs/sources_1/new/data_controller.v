`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/06 17:03:14
// Design Name: 
// Module Name: data_controller
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


module data_controller(
    input en,
    input [7:0] data_in,
    output [7:0] data_out
    );

    assign data_out = (en)? data_in:8'bzzzz_zzzz;
endmodule
