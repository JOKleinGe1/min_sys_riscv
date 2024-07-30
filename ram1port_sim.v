// File : ram1port_sim.v
// Only for simulation. not for synthesis

`define MEMORYSIZE (1*1024)

module ram1port (
	input	[7:0] 	address,
	input	[3:0] 	byteena,
	input	  		clock,
	input	[31:0] 	data,
	input	  		rden,
	input	  		wren,
	output 	reg [31:0] 	q
	);
 
	reg [31:0] 	memory [0:(`MEMORYSIZE>>2)-1];
	wire [3:0] 	wstrb;
	assign wstrb  = byteena & {wren,wren,wren,wren}; 
	initial begin
		$readmemh("test.mem32",memory);
	end

	always @(posedge clock) begin
 		 q <= memory[address];
		if (wstrb[0]) memory[address][ 7: 0] <=   data[ 7: 0];
		if (wstrb[1]) memory[address][15: 8] <=  data[15: 8];
		if (wstrb[2]) memory[address][23:16] <= data[23:16];
		if (wstrb[3]) memory[address][31:24] <= data[31:24];
	end
endmodule
