`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/05 11:22:14
// Design Name: 
// Module Name: condition_control
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


module condition_control(
    input clk,
    input rst_n,
    input zero,
    input [2:0] operation,
    input en,
    output reg pc_inc,
    output reg rd,
    output reg wr,
    output reg load_acc,
    output reg load_ir,
    output reg load_pc,
    output reg datacontrol_en,
    output reg halt
    );

    parameter HLT = 3'b000,
              SKZ = 3'b001,
              ADD = 3'b010,
              ANDD = 3'b011,
              XORR = 3'b100,
              LDA = 3'b101,
              STO = 3'b110,
              JMP = 3'b111;
    parameter IDLE = 8'b0000_0000,
              S1 = 8'b0000_0001,
              S2 = 8'b0000_0010,
              S3 = 8'b0000_0100,
              S4 = 8'b0000_1000,
              S5 = 8'b0001_0000,
              S6 = 8'b0010_0000,
              S7 = 8'b0100_0000,
              S8 = 8'b1000_0000;          
    
    reg ena;
    reg [7:0] state, next_state;


    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) ena <= 1'b0;
        else
            if(en) ena <= 1'b1;
    end


    
    always @(state) begin
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

    always@(posedge clk) begin
        if(!ena) state <= S1;
        else
            state <= next_state;
    end


    always@(posedge clk) begin
        if(!ena) begin
            {pc_inc, rd, wr, load_acc} <= 4'b0000;
            {load_ir, load_pc, datacontrol_en, halt} <= 4'b0000;
        end
        else 
            ctl_cycle;

    end

    task ctl_cycle;
    begin
         case(state)
                S1:begin
                    {pc_inc, rd, wr, load_acc} <= 4'b0100;
                    {load_ir, load_pc, datacontrol_en, halt} <= 4'b1000;
                end
                S2:begin
                    {pc_inc, rd, wr, load_acc} <= 4'b1100;
                    {load_ir, load_pc, datacontrol_en, halt} <= 4'b1000;
                end
                S3:begin
                    {pc_inc, rd, wr, load_acc} <= 4'b0000;
                    {load_ir, load_pc, datacontrol_en, halt} <= 4'b0000;
                end
                S4:begin
                    if(operation == HLT) begin
                        {pc_inc, rd, wr, load_acc} <= 4'b1000;
                        {load_ir, load_pc, datacontrol_en, halt} <= 4'b0001;
                    end
                    else begin
                        {pc_inc, rd, wr, load_acc} <= 4'b1000;
                        {load_ir, load_pc, datacontrol_en, halt} <= 4'b0000;
                    end
                end
                S5:begin
                    if(operation == JMP) begin
                        {pc_inc, rd, wr, load_acc} <= 4'b0000;
                        {load_ir, load_pc, datacontrol_en, halt} <= 4'b0100;
                    end
                    else if(operation == ADD || operation == ANDD || operation == XORR || operation == LDA) begin
                        {pc_inc, rd, wr, load_acc} <= 4'b0100;
                        {load_ir, load_pc, datacontrol_en, halt} <= 4'b0000;
                    end
                    else if(operation == STO) begin
                        {pc_inc, rd, wr, load_acc} <= 4'b0000;
                        {load_ir, load_pc, datacontrol_en, halt} <= 4'b0010;
                    end
                    else begin
                        {pc_inc, rd, wr, load_acc} <= 4'b0000;
                        {load_ir, load_pc, datacontrol_en, halt} <= 4'b0000;
                    end
                end
                S6:begin
                    if(operation == ADD || operation == ANDD || operation == XORR || operation == LDA) begin
                        {pc_inc, rd, wr, load_acc} <= 4'b0101;
                        {load_ir, load_pc, datacontrol_en, halt} <= 4'b0000;
                    end
                    else if(operation == SKZ && zero) begin
                        {pc_inc, rd, wr, load_acc} <= 4'b1000;
                        {load_ir, load_pc, datacontrol_en, halt} <= 4'b0000;
                    end
                    else if(operation == JMP) begin
                        {pc_inc, rd, wr, load_acc} <= 4'b1000;
                        {load_ir, load_pc, datacontrol_en, halt} <= 4'b0100;
                    end
                    else if(operation == STO) begin
                        {pc_inc, rd, wr, load_acc} <= 4'b0010;
                        {load_ir, load_pc, datacontrol_en, halt} <= 4'b0010;
                    end
                    else begin
                        {pc_inc, rd, wr, load_acc} <= 4'b0000;
                        {load_ir, load_pc, datacontrol_en, halt} <= 4'b0000;
                    end

                end
                S7:begin
                    if(operation == ADD || operation == ANDD || operation == XORR || operation == LDA) begin
                        {pc_inc, rd, wr, load_acc} <= 4'b0100;
                        {load_ir, load_pc, datacontrol_en, halt} <= 4'b0000;
                    end
                    else if(operation == STO) begin
                        {pc_inc, rd, wr, load_acc} <= 4'b0000;
                        {load_ir, load_pc, datacontrol_en, halt} <= 4'b0010;
                    end
                    else begin
                        {pc_inc, rd, wr, load_acc} <= 4'b0000;
                        {load_ir, load_pc, datacontrol_en, halt} <= 4'b0000;
                    end
                end
                S8:begin
                    if(operation == SKZ && zero) begin
                        {pc_inc, rd, wr, load_acc} <= 4'b1000;
                        {load_ir, load_pc, datacontrol_en, halt} <= 4'b0000;
                    end
                    else begin
                        {pc_inc, rd, wr, load_acc} <= 4'b0000;
                        {load_ir, load_pc, datacontrol_en, halt} <= 4'b0000;
                    end
                end
                
                default:begin
                    {pc_inc, rd, wr, load_acc} <= 4'b0000;
                    {load_ir, load_pc, datacontrol_en, halt} <= 4'b0000;
                end

        endcase
    end
    endtask

    





    
endmodule
