/*
*   Assignment 2
*   Team 29
*   Justin Hill, Noah Pierre, Abdullah Alosail
*/

// -----------------------------Size parameters----------------------------------

//N.S.
`define WORDSIZE [15:0]
`define OPCODE [15:12]
`define ARG [11:0]
//`define DST [11:6]
`define REGSIZE [255:0]
`define MEMSIZE [65535:0]
`define SPSIZE [7:0]      //stack pointer, i point to one of 256 words in the MEM
`define PCSIZE [15:0]     // i point to one of 16 bits in the addressed WORD
//`define TorF          // im a 0bit boolean that keeps track of conditionals (TRUE OR FALSE)
//`define PRE [3:0]     // like in P2 i alow for 16 bit imeds
//`define isPREld       // im a 1 bit bolean keeping track if PRE is loaded
`define STATESIZE [3:0]
//N.S

// -----------------------------Opcode Values-------------------------------------

`define NoArg 4'd0
`define Call 4'd1
`define Get 4'd2
`define JumpF 4'd3
`define Jump 4'd4
`define JumpT 4'd5
`define Pop 4'd6
`define Pre 4'd7
`define Push 4'd8
`define Put 4'd9

// ----------------------------No Arg Opcode---------------------------------------

`define Add 12'd1
`define And 12'd2
`define Dup 12'd4
`define Load 12'd8
`define Lt 12'd16
`define Or 12'd32
`define Ret 12'd64
`define Store 12'd128
`define Sub 12'd256
`define Sys 12'd512
`define Test 12'd1024
`define Xor 12'd2048

// -----------------------------State #'s-----------------------------------------
`define Start 4'd10


// -----------------------------Main Processor Module-----------------------------
module processor(halt, reset, clk);
output reg halt;
input reset, clk;

reg `PCSIZE pc =0;
reg `SPSIZE sp = 0;
reg `STATESIZE s = `Start;
reg `WORDSIZE stack `REGSIZE;
reg `WORDSIZE mainmem `MEMSIZE;
reg [3:0] preReg;
reg preLoaded;
//reg `REGSIZE dest;
//reg `REGSIZE src;


always @(reset)
begin
	halt <= 0;
	pc <= 0;
	s <= `Start;
	preLoaded <= 0;
end

always @(posedge clk)
begin
	case (s)
		`Start:
			begin
			end
		`NoArg: 
			begin
				//reg `WORDSIZE ArgOp = s `ARG;
				case (s `ARG)
					`Add:
						begin
							/*
							dest = sp-1;
							src = sp;
							sp = sp-1;
							stack[dest] = stack[dest] + stack[src];
							*/
							stack[sp-1] = stack[sp-1] + stack[sp];
							sp = sp-1;
							s = `Start;
						end
					`And:
						begin
							/*
							dest = sp-1;
							src = sp;
							sp = sp-1;
							stack[dest] = stack[dest] & stack[src];
							*/
							stack[sp-1] = stack[sp-1] & stack[sp];
							sp = sp-1;
							s = `Start;
						end
					`Dup:
						begin
							/*
							dest = sp+1;
							src = sp;
							sp = sp+1;
							stack[dest] = stack[src];
							*/
							stack[sp + 1] = stack[sp];
							sp = sp + 1;
							s = `Start;
						end
					`Load:
						begin
							/*
							dest = sp;
							sp = sp + 1;
							stack[dest] = mainmem[stack[dest]];
							*/
							stack[sp] = mainmem[stack[sp]];
							sp = sp+1;
							s = `Start;
						end
					`Lt:
						begin
							/*
							dest = sp-1;
							src = sp;
							sp = sp-1;
							stack[dest] = stack[dest] < stack[src];
							*/
						   stack[sp-1] = stack[sp-1] < stack[sp];
						   sp = sp-1;
						   s = `Start;
						end
					`Or:
						begin
							/*
							dest = sp-1;
							src = sp;
							sp = sp-1;
							stack[dest] = stack[dest] | stack[src];
							*/
						   stack[sp -1] = stack[sp -1] | stack[sp];
						   sp = sp -1;
						   s = `Start;
						end
					`Ret:
						begin
							/*
							src = sp;
							sp = sp-1;
							pc = stack[src];
							*/
						   pc = stack[sp];
						   sp = sp-1;
						   s = `Start;
						end
					`Store:
						begin
						end
					`Sub:
						begin
							/*
							dest = sp-1;
							src = sp;
							sp = sp-1;
							stack[dest] = stack[dest] - stack[src];
							*/
						   stack[sp -1] = stack[sp -1] - stack[sp];
						   sp = sp-1;
						   s = `Start;
						end
					`Sys:
						begin
							halt = 1;
						end
					`Test:
						begin
						end
					`Xor:
						begin
							/*
							dest = sp-1;
							src = sp;
							sp = sp-1;
							stack[dest] = stack[dest] ^ stack[src];
							*/
						   stack[sp -1] = stack[sp -1] ^ stack[sp];
						   sp = sp-1;
						   s = `Start;
						end
				endcase

			end
		`Call: 
			begin
			end
		`Get: 
			begin
			end
		`JumpF: 
			begin
			end
		`Jump: 
			begin
			end
		`JumpT: 
			begin
			end
		`Pop: 
			begin
			end
		`Pre: 
			begin
				preReg = (s `ARG) >> 12;
				preLoaded = 1;
				s = `Start;
			end
		`Push: 
			begin
			end
		`Put: 
			begin
			end
		default: halt = 1;	
	endcase
end
endmodule

module testbench;
reg reset = 0;
reg clk = 0;
reg halt;
processor Proc(halt, reset, clk);

initial begin
	$dumpfile
end
endmodule



//===========================TEST BENCH====================================
module processor_tb;
//------------------------
	reg reset = 0,clk = 0;
//------------------------
	wire halt;
	always begin #20 clk = ~clk end; // clock change every 20 somthings
	processor uut(halt,reset,clk); // instantiate the verilog module
	initial begin;
		$dumpfile;
		$dumpfile(0,uut);
		//------------
		#20 reset = 0;
		#20 reset = 1;
		//------------
	end
endmodule
//==========================END TEST BENCH=================================
//N.S

