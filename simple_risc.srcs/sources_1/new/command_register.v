`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/05 15:21:32
// Design Name: 
// Module Name: command_register
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


module command_register(
    input clk,
    input rst_n,
    input en,
    input [7:0] data,
    output [2:0] operation,
    output [12:0] ir_addr
    );

    reg [15:0] cmd_reg, state;

    assign operation = cmd_reg[15:13];
    assign ir_addr = cmd_reg[12:0];

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= 1'b0;
            cmd_reg <= 16'd0;
        end
        else begin
            if(en)
                casex(state)
                    1'b0: begin
                            cmd_reg[15:8] <= data;
                            state <= 1'b1;
                    end
                    1'b1: begin
                            cmd_reg[7:0] <= data;
                            state <= 1'b0;
                    end
                    default: begin
                            cmd_reg <= 16'bxxxx_xxxx_xxxx_xxxx;
                            state <= 1'bx;
                    end
                endcase
            else state <= 1'b0;

        end
    end
endmodule
