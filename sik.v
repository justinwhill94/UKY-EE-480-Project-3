/*
*   Assignment 2
*   Team 29
*   Justin Hill, Noah Pierre, Abdullah Alosail
*/

// Basic Sizes
`define WORD [15:0]
`define OPCODE [15:12]
`define ARG [11:0]

/*
`define DEST 
`define SRC 
`define STATE 
`define REGSIZE 
`define MEMSIZE 
*/

// Opcode Values
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

// No Arg Opcode
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

