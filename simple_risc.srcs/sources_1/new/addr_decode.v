`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/06 18:44:59
// Design Name: 
// Module Name: addr_decode
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

// Address decoder is used to generate optional communication signals, and toggle ROM and RAM
// 1FFFH---1800H RAM
// 17FFH---0000H ROM
module addr_decode(
    input [12:0] addr,
    output reg rom_en,
    output reg ram_en
    );

    always@(addr) 
        casex(addr)
            13'b1_0xxx_xxxx_xxxx: {rom_en, ram_en} <= 2'b10;
            13'b0_0xxx_xxxx_xxxx: {rom_en, ram_en} <= 2'b10;
            13'b1_1xxx_xxxx_xxxx: {rom_en, ram_en} <= 2'b01;
            default: {rom_en, ram_en} <= 2'b00;
        endcase







endmodule
