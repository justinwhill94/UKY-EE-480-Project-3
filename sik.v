/*
*   Assignment 2
*   Team 29
*   Justin Hill, Noah Pierre, Abdullah Alosail
*/

// -----------------------------Size parameters----------------------------------

//N.S.
`define WORDSIZE [15:0]
`define OPCODE [15:12]
//`define DST [11:6]
`define REGSIZE [255:0]
`define SP [7:0]      //stack pointer, i point to one of 256 words in the MEM
`define PC [15:0]     // i point to one of 16 bits in the addressed WORD
`define TorF          // im a 0bit boolean that keeps track of conditionals (TRUE OR FALSE)
`define PRE [3:0]     // like in P2 i alow for 16 bit imeds
`define isPREld       // im a 1 bit bolean keeping track if PRE is loaded
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

`define Add 8'd1
`define And 8'd2
`define Dup 8'd4
`define Load 8'd8
`define Lt 8'd16
`define Or 8'd32
`define Ret 8'd64
`define Store 8'd128
`define Sub 8'd256
`define Sys 8'd512
`define Test 8'd1024
`define Xor 8'd2048

// -----------------------------State #'s-----------------------------------------
`define Start 4'd10


// -----------------------------Main Processor Module-----------------------------
module processor(halt, reset, clk);
output reg halt;
input reset, clk;

reg `WORD pc =0;
reg `STATE s = `START;


always @(reset)
begin
	halt = 0;
	pc = 0;
	s = `START;
end

always @(posedge clk)
begin
	case (s)
		`Start
		`NoArg: 
			begin
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

