`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/05 15:50:09
// Design Name: 
// Module Name: alu
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


module alu(
    input clk,
    input rst_n,
    input en,
    input [7:0] accum,
    input [7:0] data,
    input [2:0] operation,
    output zero,
    output reg [7:0] alu_out
    );

    parameter HLT = 3'b000,
              SKZ = 3'b001,
              ADD = 3'b010,
              ANDD = 3'b011,
              XORR = 3'b100,
              LDA = 3'b101,
              STO = 3'b110,
              JMP = 3'b111;
    
    assign zero = !accum;
    
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) alu_out <= 8'bxxxx_xxxx;
        else
            casex(operation)
                HLT :alu_out <= accum;
                SKZ :alu_out <= accum;
                ADD :alu_out <= data + accum;
                ANDD:alu_out <= data & accum;
                XORR:alu_out <= data ^ accum;
                LDA :alu_out <= data;
                STO :alu_out <= accum;
                JMP :alu_out <= accum;
                default: alu_out <= 8'bxxxx_xxxx;
            endcase          

    end






endmodule
