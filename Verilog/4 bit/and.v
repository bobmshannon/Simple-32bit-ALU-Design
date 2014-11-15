/* ========================================================= */
/*                 32BIT BITWISE AND MODULE                 */
/* ========================================================= */
module bitwiseand(x,y,f);
	input [3:0] x, y;
	output [3:0] f;
	
	and(f[0],x[0],y[0]);
	and(f[1],x[1],y[1]);
	and(f[2],x[2],y[2]);
	and(f[3],x[3],y[3]);
	
	/* FOR TESTING:
	assign x = 4'b1001;
	assign y = 4'b0011;
	
	initial
		begin
			$monitor($time,,"x=%b, y=%b, f=%b",x,y,f);
		end
	*/
endmodule