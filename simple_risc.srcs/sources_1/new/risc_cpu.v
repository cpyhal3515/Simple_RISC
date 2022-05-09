`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/07 10:19:10
// Design Name: 
// Module Name: risc_cpu
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


module risc_cpu(
    input clk,
    input rst_n,
    output rd,
    output wr,
    output [12:0] addr,
    inout [7:0] data
    );

    wire alu_en, fetch, module_clk;
    wire [2:0] operation;
    wire [12:0] pc_addr, ir_addr;
    wire zero;
    wire load_ir, load_acc, pc_inc, datacontrol_en, halt;
    wire [7:0] accum, alu_out;

    clock_manager clock_manager1(
        .clk(clk),
        .rst_n(rst_n),
        .alu_en(alu_en),
        .fetch(fetch),
        .module_clk(module_clk)
    );

    command_register command_register1(
        .clk(module_clk),
        .rst_n(rst_n),
        .en(load_ir),
        .data(data),
        .operation(operation),
        .ir_addr(ir_addr)
    );

    accumulator accumulator1(
        .clk(module_clk),
        .rst_n(rst_n),
        .en(load_acc),
        .data(alu_out),
        .accum(accum)
    );

    alu m_alu(
        .clk(module_clk),
        .rst_n(rst_n),
        .en(alu_en),
        .accum(accum),
        .data(data),
        .operation(operation),
        .zero(zero),
        .alu_out(alu_out)
    );

    condition_control condition_control1(
        .clk(module_clk),
        .rst_n(rst_n),
        .zero(zero),
        .operation(operation),
        .en(fetch),
        .pc_inc(pc_inc),
        .rd(rd),
        .wr(wr),
        .load_acc(load_acc),
        .load_ir(load_ir),
        .load_pc(load_pc),
        .datacontrol_en(datacontrol_en),
        .halt(halt)
    );

    data_controller data_controller1(
        .en(datacontrol_en),
        .data_in(alu_out),
        .data_out(data)
    );

    address_multiplexer m_adr(
        .fetch(fetch),
        .ir_addr(ir_addr),
        .pc_addr(pc_addr),
        .addr(addr)
    );

    program_counter program_counter1(
        .rst_n(rst_n),
        .load_pc(load_pc),
        .pc_inc(pc_inc),
        .ir_addr(ir_addr),
        .pc_addr(pc_addr)
    );




endmodule
