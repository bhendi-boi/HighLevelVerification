//Define the enumerated types for packet payload size type
`define SMALL 0
`define MEDIUM 1
`define LARGE 2
`define GOOD 0
`define BAD 1


module pktgen();
integer payload_size;//Control field for the payload size
integer parity_type;// Control feild for the parity type.
reg [0:7] uid; // Unique id field to identify the packet

reg [7:0] len;
reg [7:0] Da;
reg [7:0] Sa;
reg [0:7] pkt [0:64];//Size = MAX pkt size
reg [0:7] parity;

integer seed2 = 2;
integer seed3 = 3;
integer seed4 = 4;

initial
uid = 0;

task randomize();
begin

uid = uid +1;


// generate parity_type randomly as either 0 or 1
// generate payload_size randomly as 0, 1 or 2
// generate Destination address "Da" randomly based address 0 to 3 of mem array in module top
// generate soure address "Sa" randomly without any constraints

// If payload_size is small, length (len) should be constrainted between 0 to 10
// If payload_size is medium, length should between 10 to 20
// If payload_size is large, lenght should be between 20 and 30
// default payload_size is 0 to 10
// assign parity to 0 if parity_type is 0, else 1.
/// solun here **********************
parity_type= {$random}%2;// 0 and 1 are selected randomly
payload_size={$random}%3;// 0,1,2 are selected randomly
Da = top.mem[({$random}%3)];//{$random}%3;// 0,1,2,3 are selected randomly
Sa = $random;
if(payload_size== `SMALL)
len = {$random}%10;
else if(payload_size== `MEDIUM)
len = 10+{$random}%10;
else if(payload_size==`LARGE)
len = 20+{$random(seed2)}%10;
else len = {$random(seed2)}%10;
if(parity_type==0)
parity=8'b0;
else
parity=8'b1;
//******************************
end

endtask


task packing();
integer i;
begin
pkt[0]=Da;
pkt[1]=Sa;
pkt[2]=len;
$display("[PACKING] pkt[0] is Da %b %d Sa %b %d len %b %d ",pkt[0],Da,Sa,Sa,len,len);
for (i = 0;i<len+3;i=i+1)
pkt[i+3]=$random(seed4);
pkt[3] = uid;
pkt[i+3]=parity ^ parity_cal(0);
end
endtask



// parity_calc()
//
// Return the byte resulting from xor-ing among all data bytes
// and the byte resulting from concatenating addr and len
//////////////////////////////////////////////////////////////
function [0:7] parity_cal(input dummy);
integer i;
reg [0:7] result ;
begin
result = 8'hff;
for (i = 0;i<len+4;i=i+1)
begin
result = result ^ pkt[i];
end
parity_cal=result;
end
endfunction

endmodule