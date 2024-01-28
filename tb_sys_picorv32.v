//tb_sys_picorv32.v

`timescale 1 ns / 1 ps

module tb_sys_picorv32;
	reg clk = 1;
	reg resetn = 0;
	wire  [7:0] LEDR;
       reg [7:0] SW; 

	system_picorv32 dutsys (
		.clk         (clk        ),
		.resetn      (resetn     ), 
		. LEDR (LEDR) ,
		.SW (SW));

	always #5 clk = ~clk;

	initial begin
		//if ($test$plusargs("vcd")) begin
			$dumpfile("tb_sys_picorv32.vcd");
			$dumpvars(0, tb_sys_picorv32 );
		//end
		repeat (20) @(posedge clk);
		SW = 8'h00;
		resetn <= 1;
		repeat (200) @(posedge clk);
		SW = 8'hFF;
		repeat (200) @(posedge clk);
		SW = 8'h00;
		repeat (200) @(posedge clk);
		$finish;
	end
	
	always @(posedge clk) begin
		if (dutsys.mem_valid && dutsys.mem_ready) begin
			if (dutsys.mem_instr)
				$display("ifetch 0x%08x: 0x%08x PC:0x%08x", dutsys.mem_addr, dutsys.mem_rdata,dutsys.uut.reg_next_pc);
			else if (dutsys.mem_wstrb)
				$display("write  0x%08x: 0x%08x (wstrb=%b)",dutsys. mem_addr,dutsys. mem_wdata, dutsys.mem_wstrb);
			else
				$display("read   0x%08x: 0x%08x", dutsys.mem_addr, dutsys.mem_rdata);
		end
	end
endmodule
