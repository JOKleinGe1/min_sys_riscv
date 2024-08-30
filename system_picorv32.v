//file : system_picorv32.v

module system_picorv32 (input sys_clk,sys_resetn,output reg [7:0] LEDR,input [7:0] SW);
	wire 		cpu_trap;
	wire 		cpu_rw_cycle;
	wire 		cpu_instr_fetch;
	reg 		sys_rw_is_done;
	wire [31:0] cpu_address;
	wire [31:0] cpu_write_data;
	wire [3:0] 	cpu_write_strobe;
	wire [31:0] cpu_read_data;
	reg   [31:0] io_read_data;

	wire 		sys_write_enable = (| cpu_write_strobe); // if one or more byte written
	wire 		sys_read_enable = cpu_rw_cycle & (! sys_write_enable);

	wire [31:0] ram_read_data; 

	//	individual read_enable and write_enable
	wire sys_RAM_read, sys_RAM_write; //RAM-1KB:0-0x3FF(byte) = 0-FF(32-bit-word)
	wire sys_LED_read, sys_LED_write;
	wire sys_SWITCH_read;

	reg [4:0] sys_rw_bus ; // grouping 5 individual read_enable and write_enable in a bus
	wire global_rw =  |(sys_rw_bus) ;  // if any individual r/w is enable 

	// degrouping individual read_enable and write_enable
	assign {sys_SWITCH_read, sys_LED_write,sys_LED_read, sys_RAM_write, sys_RAM_read} 
			= sys_rw_bus;
	
	// select if data bus is read from RAM or IO		
	assign cpu_read_data =   (sys_RAM_read) ? ram_read_data :  io_read_data ;
	
	// Acknowkledge read/write request cpu one cycle after cpu_rw_cycle using 
	// sys_rw_is_done if cpu address is in ram or for any I/O registers
	always @(posedge sys_clk) sys_rw_is_done <= (global_rw && !sys_rw_is_done) ;

	// instance of RISC-V
	picorv32 uut (
		.clk         (sys_clk        ),
		.resetn      (sys_resetn     ),
		.trap        (cpu_trap       ),
		.mem_valid   (cpu_rw_cycle  ),
		.mem_instr   (cpu_instr_fetch  ),
		.mem_ready   (sys_rw_is_done  ),
		.mem_addr    (cpu_address   ),
		.mem_wdata   (cpu_write_data  ),
		.mem_wstrb   (cpu_write_strobe  ),
		.mem_rdata   (cpu_read_data )
	);

	// instance RAM (1KB)  
	ram1port	ram1port_inst (
		.address 	( cpu_address[9:2] ),   
		.byteena 	( cpu_write_strobe ),
		.data 		( cpu_write_data ),
		.clock 		( sys_clk ),
		.rden 		( sys_RAM_read ),
		.wren 		( sys_RAM_write ),
		.q 			( ram_read_data )
	);

	// r/w individual signal generation from address decoding 
	always @({sys_read_enable,sys_write_enable,cpu_address}) 
	 casex ({sys_read_enable,sys_write_enable,cpu_address}) 	
	  //ram read 0-3FF :
	  {2'b10,32'b00000000_00000000_000000xx_xxxxxxxx}:sys_rw_bus <= 5'b00001; 
	  //ram write 0-3FF :
	  {2'b01,32'b00000000_00000000_000000xx_xxxxxxxx}:sys_rw_bus <= 5'b00010; 
	  {2'b10,32'h0000_8000}  : sys_rw_bus <= 5'b00100; //led read @ 8000
	  {2'b01,32'h0000_8000}  : sys_rw_bus <= 5'b01000; //led write @ 8000
	  {2'b10,32'h0000_8004}  : sys_rw_bus <= 5'b10000; //switch read @ 8004
	  default                : sys_rw_bus <= 5'b0000; 
	endcase
		
	always @(posedge sys_clk)	begin
		if (sys_LED_read)  io_read_data  <= { 24'd0 , LEDR }; 
		else if (sys_LED_write & cpu_write_strobe[0]) LEDR <= cpu_write_data[ 7: 0]; 
		else if (sys_SWITCH_read) io_read_data  <= { 24'd0 , SW }; 
	end

endmodule
