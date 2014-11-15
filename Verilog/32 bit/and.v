/* ========================================================= */
/*                 32BIT BITWISE AND MODULE                 */
/* ========================================================= */
module bitwiseand(x,y,f);
	input [31:0] x, y;
	output [31:0] f;
	
	and(f[0],x[0],y[0]);
	and(f[1],x[1],y[1]);
	and(f[2],x[2],y[2]);
	and(f[3],x[3],y[3]);
	and(f[4],x[4],y[4]);
	and(f[5],x[5],y[5]);
	and(f[6],x[6],y[6]);
	and(f[7],x[7],y[7]);
	and(f[8],x[8],y[8]);
	and(f[9],x[9],y[9]);
	and(f[10],x[10],y[10]);
	and(f[11],x[11],y[11]);
	and(f[12],x[12],y[12]);
	and(f[13],x[13],y[13]);
	and(f[14],x[14],y[14]);
	and(f[15],x[15],y[15]);
	and(f[16],x[16],y[16]);
	and(f[17],x[17],y[17]);
	and(f[18],x[18],y[18]);
	and(f[19],x[19],y[19]);
	and(f[20],x[20],y[20]);
	and(f[21],x[21],y[21]);
	and(f[22],x[22],y[22]);
	and(f[23],x[23],y[23]);
	and(f[24],x[24],y[24]);
	and(f[25],x[25],y[25]);
	and(f[26],x[26],y[26]);
	and(f[27],x[27],y[27]);
	and(f[28],x[28],y[28]);
	and(f[29],x[29],y[29]);
	and(f[30],x[30],y[30]);
	and(f[31],x[31],y[31]);
	
	/* FOR TESTING:
	assign x = 4'b1001;
	assign y = 4'b0011;
	
	initial
		begin
			$monitor($time,,"x=%b, y=%b, f=%b",x,y,f);
		end
	*/
endmodule