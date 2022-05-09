`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/05 15:44:37
// Design Name: 
// Module Name: accumulator
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


module accumulator(
    input clk,
    input rst_n,
    input en,
    input [7:0] data,
    output reg [7:0] accum
    );

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) accum <= 8'd0;
        else
            if(en) accum <= data;
            else accum <= accum; 
    end


endmodule
