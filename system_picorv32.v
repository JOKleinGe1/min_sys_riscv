//file : system_picorv32.v
`define MEMORYSIZE (1*1024)
// 1k = 0x400 = ram size = initial top of stack
`define  LEDR_ADDRESS (32'h8000)
`define  SW_ADDRESS   (32'h8004)

module system_picorv32 (input clk, resetn, output reg [7:0] LEDR, input  [7:0]SW) ;

	wire trap;

	wire mem_valid;
	wire mem_instr;
	reg mem_ready;
	wire [31:0] mem_addr;
	wire [31:0] mem_wdata;
	wire [3:0] mem_wstrb;
	reg  [31:0] mem_rdata;

	picorv32 uut (
		.clk         (clk        ),
		.resetn      (resetn     ),
		.trap        (trap       ),
		.mem_valid   (mem_valid  ),
		.mem_instr   (mem_instr  ),
		.mem_ready   (mem_ready  ),
		.mem_addr    (mem_addr   ),
		.mem_wdata   (mem_wdata  ),
		.mem_wstrb   (mem_wstrb  ),
		.mem_rdata   (mem_rdata  )
	);

	reg [31:0] memory [0:(`MEMORYSIZE>>2)-1]  /* synthesis ram_init_file = " test.mif" */ ; 

	initial begin
		$readmemh("test.mem32",memory);
	end

	always @(posedge clk) begin
		mem_ready <= 0;
		if (mem_valid && !mem_ready) begin
			if (mem_addr <= `MEMORYSIZE) begin
				mem_ready <= 1;
				/*if (mem_wstrb == 4'h0)*/ mem_rdata <= memory[mem_addr >> 2];
				if (mem_wstrb[0]) memory[mem_addr >> 2][ 7: 0] <= mem_wdata[ 7: 0];
				if (mem_wstrb[1]) memory[mem_addr >> 2][15: 8] <= mem_wdata[15: 8];
				if (mem_wstrb[2]) memory[mem_addr >> 2][23:16] <= mem_wdata[23:16];
				if (mem_wstrb[3]) memory[mem_addr >> 2][31:24] <= mem_wdata[31:24];
			end // end of memory
			/* add memory-mapped IO here */ 
			if (mem_addr  ==  `LEDR_ADDRESS) begin
				mem_ready <= 1;
				if (mem_wstrb[0]) LEDR <= mem_wdata[ 7: 0];
			end 
			if (mem_addr  ==  `SW_ADDRESS) begin
				mem_ready <= 1;
				mem_rdata <= SW; 
			end // end of IO
		end // end of 1st memory cycle
	end // end of process
endmodule
