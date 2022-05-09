`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/05 11:24:32
// Design Name: 
// Module Name: clock_manager
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


module clock_manager(
    input clk,
    input rst_n,
    output reg alu_en,
    output reg fetch,
    output module_clk
    );
    
    parameter S1 = 8'b0000_0001,
              S2 = 8'b0000_0010,
              S3 = 8'b0000_0100,
              S4 = 8'b0000_1000,
              S5 = 8'b0001_0000,
              S6 = 8'b0010_0000,
              S7 = 8'b0100_0000,
              S8 = 8'b1000_0000,
              IDLE = 8'b0000_0000;
    
    reg [7:0] state, next_state;
    
    assign module_clk = clk;
    
    always@(state) begin
        case(state)
            IDLE: next_state = S1;
            S1: next_state = S2;
            S2: next_state = S3;
            S3: next_state = S4;
            S4: next_state = S5;
            S5: next_state = S6;
            S6: next_state = S7;
            S7: next_state = S8;
            S8: next_state = S1;
            default: next_state = IDLE;
        endcase   
    end

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) state <= IDLE;
        else state <= next_state;
    end

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            alu_en <= 1'b0;
            fetch <= 1'b0;
        end
        else
            if(state == S1) alu_en <= 1'b1;
            else if(state == S2) alu_en <= 1'b0;
            else if(state == S3) fetch <= 1'b1;
            else if(state == S7) fetch <= 1'b0;
            else begin
                alu_en <= alu_en;
                fetch <= fetch;
            end
    end
    
endmodule
