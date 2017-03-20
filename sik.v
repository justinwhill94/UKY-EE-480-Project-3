/*
*   Assignment 2
*   Team 29
*   Justin Hill, Noah Pierre, Abdullah Alosail
*/

// -----------------------------Size parameters----------------------------------

`define WORDSIZE [15:0]		// Stack Register Size
`define OPCODE [15:12]		// Instruction OpCode Location
`define ARG [11:0]			// Instruction Argument location
`define REGSIZE [255:0]		// Stack Size
`define MEMSIZE [65535:0]	// Main Memory Size
`define SPSIZE [7:0]      	// Stack Pointer Size
`define PCSIZE [15:0]     	// Process Counter Size
`define STATESIZE [3:0]		// State Variable Size

// -----------------------------Opcode Values-------------------------------------

`define NoArg 4'd1
`define Call 4'd2
`define Get 4'd3
`define JumpF 4'd4
`define Jump 4'd5
`define JumpT 4'd6
`define Pop 4'd7
`define Pre 4'd8
`define Push 4'd9
`define Put 4'd10

// ----------------------------No Arg Opcode---------------------------------------
//	These values are contained in the instruction argument and act as
//	a secondary opcode
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
`define Start 4'd11


// -----------------------------Main Processor Module-----------------------------
module processor(halt, reset, clk);
output reg halt;
input reset, clk;

// -----------------------------Initialize Processor Registers--------------------
reg `PCSIZE pc =0;
reg `SPSIZE sp = 0;
reg `STATESIZE s = `Start;
reg `WORDSIZE stack `REGSIZE;
reg `WORDSIZE mainmem `MEMSIZE;
reg [3:0] preReg;
reg preLoaded;
reg torf;
reg `WORDSIZE ir;
reg `WORDSIZE dest;
reg `WORDSIZE src;


// Non-blocking assignments are used because the order of the assignments does
// not matter
always @(reset)
begin
	halt <= 0;
	pc <= 0;
	s <= `Start;
	preLoaded <= 0;
	torf = 0;
	$readmemh0(stack);
	$readmemh1(mainmem);
end

// Blocking assignments are used to ensure the order of assignments is linear

// This state machine implements the processor, where each state implements
// a specific operation.
always @(posedge clk)
begin
	case (s)
		// Fetch the next instruction from memory
		`Start:
			begin
				ir = mainmem[pc];
				s = ir `OPCODE;
				pc = pc+1;
			end
		// Perform the specified NoArg operation
		`NoArg: 
			begin
				//reg `WORDSIZE ArgOp = s `ARG;
				
				// Use the argument as a secondary opcode which specifies
				// which instruction to perform
				case (ir `ARG)
					`Add:
						begin
							
							dest = sp-1;
							src = sp;
							sp = sp-1;
							stack[dest] = stack[dest] + stack[src];
							s = `Start;
							/*
							stack[sp-1] = stack[sp-1] + stack[sp];
							sp = sp-1;
							s = `Start;
							*/
						end
					`And:
						begin
							
							dest = sp-1;
							src = sp;
							sp = sp-1;
							stack[dest] = stack[dest] & stack[src];
							s = `Start;
							/*
							stack[sp-1] = stack[sp-1] & stack[sp];
							sp = sp-1;
							s = `Start;
							*/
						end
					`Dup:
						begin
							
							dest = sp+1;
							src = sp;
							sp = sp+1;
							stack[dest] = stack[src];
							s = `Start;
							/*
							stack[sp + 1] = stack[sp];
							sp = sp + 1;
							s = `Start;
							*/
						end
					`Load:
						begin
							
							dest = sp;
							sp = sp + 1;
							stack[dest] = mainmem[stack[dest]];
							s = `Start;
							/*
							stack[sp] = mainmem[stack[sp]];
							sp = sp+1;
							s = `Start;
							*/
						end
					`Lt:
						begin
							
							dest = sp-1;
							src = sp;
							sp = sp-1;
							stack[dest] = stack[dest] < stack[src];
							s = `Start;
							/*
						   stack[sp-1] = stack[sp-1] < stack[sp];
						   sp = sp-1;
						   s = `Start;
						   */
						end
					`Or:
						begin
							
							dest = sp-1;
							src = sp;
							sp = sp-1;
							stack[dest] = stack[dest] | stack[src];
							s = `Start;
							/*
						   stack[sp -1] = stack[sp -1] | stack[sp];
						   sp = sp -1;
						   s = `Start;
						   */
						end
					`Ret:
						begin
							
							src = sp;
							sp = sp-1;
							pc = stack[src];
							s = `Start;
							/*
						   pc = stack[sp];
						   sp = sp-1;
						   s = `Start;
						   */
						end
					`Store:
						begin
							
							dest = sp - 1;
							src = sp;
							sp = sp - 1;
							mainmem[stack[dest]] = stack[src];
							s = `Start;
							/*
						   mainmem[stack[sp-1]] = stack[sp];
						   sp = sp -1;
						   s = `Start;
						   */
						end
					`Sub:
						begin
							
							dest = sp-1;
							src = sp;
							sp = sp-1;
							stack[dest] = stack[dest] - stack[src];
							s = `Start;
							/*
						   stack[sp -1] = stack[sp -1] - stack[sp];
						   sp = sp-1;
						   s = `Start;
						   */
						end
					`Sys:
						begin
							halt = 1;
						end
					`Test:
						begin
							
							src = sp;
							sp = sp -1;
							torf = (stack[src] != 0);
							s = `Start;
							/*
							torf = (stack[sp] != 0);
							sp = sp -1;
							*/
						end
					`Xor:
						begin
							
							dest = sp-1;
							src = sp;
							sp = sp-1;
							stack[dest] = stack[dest] ^ stack[src];
							s = `Start;
							/*
						   stack[sp -1] = stack[sp -1] ^ stack[sp];
						   sp = sp-1;
						   s = `Start;
						   */
						end
				endcase
			end

		`Call: 
			begin
				
				dest = sp+1;
				sp = sp+1;
				stack[dest] = pc +1;
				/*
			  	stack[sp+1] = pc +1;
				sp = sp + 1;
				*/
				if (preLoaded)
				begin
					pc = {preReg, ir `ARG};
					preLoaded = 0;
				end
				else
				begin
					pc = (pc & 16'hf000) | (ir `ARG & 16'h0fff);
				end
				preLoaded = 0;
				s = `Start;
			end
		`Get: 
			begin
				
				dest = sp + 1;
				src = sp - s `ARG;
				sp = sp + 1;
				stack[dest] = stack[src];
				s = `Start;
				/*
				stack[sp + 1] = stack[sp - ir `ARG];
				sp = sp + 1;
				*/
			end
		`JumpF: 
			begin
				if(~torf)
				begin
					if(preLoaded)
					begin
						pc = {preReg, ir `ARG};
						preLoaded = 0;
					end
					else
					begin
						pc = (pc & 16'hf000) | (ir `ARG & 16'h0fff);
					end
				end
				s = `Start;
			end
		`Jump: 
			begin
				if(preLoaded)
				begin
					pc = {preReg, ir `ARG};
					preLoaded = 0;
				end
				else
				begin
					pc = (pc & 16'hf000) | (ir `ARG & 16'h0fff);
				end
				s = `Start;
			end
		`JumpT: 
			begin
				if(torf)
				begin
					if(preLoaded)
					begin
						pc = {preReg, ir `ARG};
						preLoaded = 0;
					end
					else
					begin
						pc = (pc & 16'hf000) | (ir `ARG & 16'h0fff);
					end
				end
				s = `Start;
			end
		`Pop: 
			begin
				if(ir `ARG > sp)
				begin
					sp = 0;
				end
				else
				begin
					sp = sp - ir `ARG;
				end
				s = `Start;
			end
		`Pre: 
			begin
				preReg = (ir `ARG) >> 12;
				preLoaded = 1;
				s = `Start;
			end
		`Push: 
			begin
				
				dest = sp+1;
				sp = sp+1;
				if(preLoaded)
				begin 
					stack[dest] = {preReg, ir `ARG};
					preLoaded = 0;
				end
				else
				begin
					stack[dest] = ir `ARG;
				end
				s = `Start;
			end
		`Put: 
			begin
				
				dest = sp - ir `ARG;
				src = sp;
				stack[dest] = stack[src];
				s = `Start;
				
				//stack[sp - ir `ARG] = stack[sp];
			end
		default: halt = 1;	
	endcase
end
endmodule

// -----------------------------Processor Testbench Module-------------------------
module processor_tb;
wire halt;
reg reset;
reg clk;

processor uut(halt,reset,clk); // instantiate the verilog module

// Initially reset the processor
initial 
begin
	$dumpfile;
	$dumpvars(0,uut);
	//------------
	clk = 0;
	#5 reset = 0;
	#5 reset = 1;
	//------------
	while(~halt)
		#5 clk = ~ clk;
end
endmodule
