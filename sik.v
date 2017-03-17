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
reg `WORDSIZE regfile `REGSIZE;
reg `WORDSIZE mainmem `MEMSIZE;
reg [3:0] preReg;
reg preLoaded;
reg


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
							reg `REGSIZE dest = sp-1;
							reg `REGSIZE src = sp;
							sp = sp-1;
							reg `WORDSIZE destV = regfile[dest];
							reg `WORDSIZE srcV = regfile[src];
							regfile[dest] = destV + srcV;
							*/
							regfile[sp-1] <= regfile[sp-1] + regfile[sp];
							sp <= sp-1;
							s <= `Start;
						end1
					`And:
						begin
							/*
							reg `REGSIZE dest = sp-1;
							reg `REGSIZE src = sp;
							sp = sp-1;
							reg `WORDSIZE destV = regfile[dest];
							reg `WORDSIZE srcV = regfile[src];
							regfile[dest] = destV & srcV;
							*/
							regfile[sp-1] <= regfile[sp-1] & regfile[sp];
							sp <= sp-1;
							s <= `Start;
						end
					`Dup:
						begin
							/*
							reg `REGSIZE dest = sp+1;
							reg `REGSIZE src = sp;
							sp = sp+1;
							reg `WORDSIZE srcV = regfile[src];
							regfile[dest] = srcV;
							*/
							regfile[sp + 1] <= regfile[sp];
							sp <= sp + 1;
							s <= `Start;
						end
					`Load:
						begin
							/*
							reg `REGSIZE dest = sp;
							reg `WORDSIZE destV = regfile[dest];
							regfile[dest] = mainmem[destV];
							*/
							regfile[sp] <= mainmem[regfile[sp]];
							sp <= sp+1;
							s <= `Start;
						end
					`Lt:
						begin
							/*
							reg `REGSIZE dest = sp-1;
							reg `REGSIZE src = sp;
							sp = sp-1;
							reg `WORDSIZE destV = regfile[dest];
							reg `WORDSIZE srcV = regfile[src];
							regfile[dest] = destV < srcV;
							*/
						   regfile[sp-1] <= regfile[sp-1] < regfile[sp];
						   sp <= sp-1;
						   s <= `Start;
						end
					`Or:
						begin
							/*
							reg `REGSIZE dest = sp-1;
							reg `REGSIZE src = sp;
							sp = sp-1;
							reg `WORDSIZE destV = regfile[dest];
							reg `WORDSIZE srcV = regfile[src];
							regfile[dest] = destV | srcV;
							*/
						   regfile[sp -1] <= regfile[sp -1] | regfile[sp];
						   sp <= sp -1;
						   s <= `Start;
						end
					`Ret:
						begin
							/*
							reg `REGSIZE src = sp;
							sp = sp-1;
							pc = regfile[src];
							*/
						   pc <= regfile[sp];
						   sp <= sp-1;
						   s <= `Start;
						end
					`Store:
						begin
						end
					`Sub:
						begin
							/*
							reg `REGSIZE dest = sp-1;
							reg `REGSIZE src = sp;
							sp = sp-1;
							reg `WORDSIZE destV = regfile[dest];
							reg `WORDSIZE srcV = regfile[src];
							regfile[dest] = destV - srcV;
							*/
						   regfile[sp -1] <= regfile[sp -1] - regfile[sp];
						   sp <= sp-1;
						   s <= `Start;
						end
					`Sys:
						begin
						end
					`Test:
						begin
						end
					`Xor:
						begin
							/*
							reg `REGSIZE dest = sp-1;
							reg `REGSIZE src = sp;
							sp = sp-1;
							reg `WORDSIZE destV = regfile[dest];
							reg `WORDSIZE srcV = regfile[src];
							regfile[dest] = destV ^ srcV;
							*/
						   regfile[sp -1] <= regfile[sp -1] ^ regfile[sp];
						   sp <= sp-1;
						   s <= `Start;
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
				preReg <= (s `ARG) >> 12;
				preLoaded <= 1;
			end
		`Push: 
			begin
			end
		`Put: 
			begin
			end
		default: halt <= 1;	
	endcase
end
end module

/*
module processor_tb;
	reg [15:0] A;
	reg [15:0] B;
	reg [16:0] result;
	reg [16:0] orc_result;
	reg error;
//------------------------
	reg halt;
	reg reset;
	reg clk;
//------------------------
	processor uut(halt,reset,clk);
	always begin	#10 clk = ~clk;	end

	initial begin;
		// make some word in MEM = A;
		// make some word in MEM = B;
		result = 0;
		orc_result = 0;
		error = 0;
	end

	initial begin 
		
		orc_result = 
*/

