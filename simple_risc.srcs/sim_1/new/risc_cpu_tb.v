`timescale 1ns / 100ps
`define period 100
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/07 10:36:14
// Design Name: 
// Module Name: risc_cpu_tb
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


module risc_cpu_tb();
    reg rst_n, clk;
    integer test;
    reg [(3*8):0] mnemonic;
    reg [12:0] pc_addr, ir_addr;
    wire [7:0] data;
    wire [12:0] addr;
    wire rd, wr, halt, ram_en, rom_en;

    risc_cpu t_cpu(
        .clk(clk),
        .rst_n(rst_n),
        .rd(rd),
        .wr(wr),
        .addr(addr),
        .data(data)
    ); 

    ram_test t_ram(
        .en(ram_en),
        .rd(rd),
        .wr(wr),
        .addr(addr),
        .data(data)
    );
    rom_test t_rom(
        .rd(rd),
        .en(rom_en),
        .addr(addr),
        .data(data)
    );

    addr_decode t_addr_decode  (
        .addr(addr),
        .rom_en(rom_en),
        .ram_en(ram_en)
    );

    initial begin 
        clk=1; 
        $timeformat(-9,1,"ns",12); //display time in nanoseconds 
        display_debug_message; 
        sys_reset; 
        test1;
        $stop;
        test2;
        $stop;
        test3;
        $stop;
    end 
    
    task display_debug_message;
    begin
        $display("\n****************************************");
        $display("*THE FOLLOWING DEBUG TASK ARE AVAILABLE:*");
        $display("*\"testl;\"to load the lst diagnostic progran.*");
        $display("*\"test2;\"to load the2 nd diagnostic program,*");
        $display("*\"test3;\"to load the Fibonacci program.*");
        $display("****************************************\n");

    end 
    endtask

    task test1; 
    begin 
        test = 0; 
        disable MONITOR;
        $readmemb("E:/FPGA_Workspace/Simple RISC/simple_risc.srcs/sim_1/new/test1_rom.dat",t_rom.mem); 
        $display("rom loaded successfully!");
        $readmemb("E:/FPGA_Workspace/Simple RISC/simple_risc.srcs/sim_1/new/test1_ram.dat", t_ram.mem);
        $display("ram loaded successfully!");
    #1 test = 1;
    #14800;
    sys_reset; 
    end 
    endtask

     task test2; 
     begin 
        test = 0; 
        disable MONITOR;
        $readmemb("E:/FPGA_Workspace/Simple RISC/simple_risc.srcs/sim_1/new/test2_rom.dat",t_rom.mem); 
        $display("rom loaded successfully!");
        $readmemb("E:/FPGA_Workspace/Simple RISC/simple_risc.srcs/sim_1/new/test2_ram.dat", t_ram.mem);
        $display("ram loaded successfully!");
     #1 test = 2;
     #11300;
     sys_reset; 
     end 
     endtask

     task test3; 
     begin 
        test = 0; 
        disable MONITOR;
        $readmemb("E:/FPGA_Workspace/Simple RISC/simple_risc.srcs/sim_1/new/test3_rom.dat",t_rom.mem); 
        $display("rom loaded successfully!");
        $readmemb("E:/FPGA_Workspace/Simple RISC/simple_risc.srcs/sim_1/new/test3_ram.dat", t_ram.mem);
        $display("ram loaded successfully!");
     #1 test = 3;
     #94000;
     sys_reset; 
     end 
     endtask

    task sys_reset; 
    begin 
        rst_n = 1;
        #(`period*0.7) rst_n = 0;
        #(1.5 * `period) rst_n = 1; 
        # 300;
    end 
    endtask

    always @(test) begin:MONITOR 
    case(test)
        1:begin
        //display results when running test 1
        $display("\n ** RUNNING CPUtest1 -The Basic CPU Diagnostic Program ***");
        $display("\n TIME PC INSTR ADDR DATA");
        $display("------------------------------------");
        while(test == 1)
            @(t_cpu.m_adr.pc_addr)//fixed 
            if((t_cpu.m_adr.pc_addr%2 == 1)&&(t_cpu.m_adr.fetch == 1)) //fixed 
            begin
                #60
                pc_addr <= t_cpu.m_adr.pc_addr-1; 
                ir_addr <= t_cpu.m_adr.ir_addr;
                #340
                $display("%t %h %s %h %h", $time, pc_addr, mnemonic, ir_addr, data);
                //HERE DATA HAS BEEN CHANGED T-CPU-M-REGISTER. DATA endend
            end
        end

         2:begin
         //display results when running test 2
         $display("\n ** RUNNING CPUtest2 -The Basic CPU Diagnostic Program ***");
         $display("\n TIME PC INSTR ADDR DATA");
         $display("------------------------------------");
         while(test == 2)
             @(t_cpu.m_adr.pc_addr)//fixed 
             if((t_cpu.m_adr.pc_addr%2 == 1)&&(t_cpu.m_adr.fetch == 1)) //fixed 
             begin
                 #60
                 pc_addr <= t_cpu.m_adr.pc_addr-1; 
                 ir_addr <=t_cpu.m_adr.ir_addr;
                 #340
                 $display("%t %h %s %h %h", $time, pc_addr, mnemonic, ir_addr, data);
                 //HERE DATA HAS BEEN CHANGED T-CPU-M-REGISTER. DATA endend
             end
         end

         3:begin
         //display results when running test 3
         $display("\n ** RUNNING CPUtest3 -The Basic CPU Diagnostic Program ***");
         $display("***This program should calculate the fibonacci***");
         $display("\n TIME FIBONACCI NUMBER");
         $display("------------------------------------");
         while (test ==3)begin 
             wait(t_cpu.m_alu.operation == 3'h1)//display Fib. No. at end of program loop
             $display("%t %d",$time,t_ram.mem[10'h2]); 
             wait(t_cpu.m_alu.operation != 3'h1); 
         end
         end
    endcase
    end

    //STOP when HALI instruction decoded
    always@(posedge halt) begin
        #500
        $display("\n****************************************");
        $display("*A HALT INSTRUCTION WAS PROCESSED !!!*");
        $display("****************************************\n");
    end 
    always#(`period/2) clk = ~clk;
    always@(t_cpu.m_alu.operation)
        //get an ASCII mnemonic for each opcode 
        case(t_cpu.m_alu.operation)
        3'b000: mnemonic="HLT";
        3'h1: mnemonic="SKZ";
        3'h2: mnemonic="ADD";
        3'h3: mnemonic="AND";
        3'h4: mnemonic="XOR";
        3'h5: mnemonic="LDA";
        3'h6: mnemonic="STO";
        3'h7: mnemonic="JMP"; 
        default: mnemonic="???"; 
        endcase






endmodule
