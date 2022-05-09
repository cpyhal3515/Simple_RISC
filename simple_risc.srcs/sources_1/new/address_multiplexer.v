`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/05 15:37:47
// Design Name: 
// Module Name: address_multiplexer
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


module address_multiplexer(
    input fetch,
    input [12:0] ir_addr,
    input [12:0] pc_addr,
    output [12:0] addr
    );

    assign addr = fetch ? pc_addr:ir_addr;

endmodule
