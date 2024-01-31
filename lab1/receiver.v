module receiver(clk,data, ready, read, port);
input ready;

input clk;
input [7:0]data;
input [31:0] port;
output read;
reg read;
reg [0:7] mem [0:65];
wire [31:0] port;
integer j,delay;

reg[7:0] rec_address;

integer seed6=6;

// Start collecting packet
initial begin
    while(1)begin

    begin
    @(posedge ready)
    delay= {$random(seed6)}%5+1;
    repeat(delay)@(negedge clk);

    j=0;
    @(negedge clk);
    read=1'b1;
    while(ready==1'b1)
    begin
    @(negedge clk);
    mem[j]=data;
    j=j+1;
    $display(" RECV BYTE at PORT[%d] %b",port,data);

    end//while
    read=1'b0;
    end
    // Do unpacking
    unpacking();
    // Call the checker task
    checker((j-1));
    end
end
// Do unpack of the packet recived.
task unpacking;
reg [7:0]rec_parity;
reg [7:0]rec_paclen;
reg [7:0]separate;
reg [7:0]rec_data[0:63];
begin
rec_paclen=mem[2];
rec_parity=mem[rec_paclen+3];
rec_address=mem[0];
$display("rec_parity=%b rec_paclen=%0d %b, rec_address=%b header %b",rec_parity,rec_paclen, rec_paclen, rec_address,mem[0]);
end
endtask

task checker(input integer size);
integer i;
begin
$display("[CHECKER] Checker started for pkt_no %d ",top.tb.sb.pkt_no );
if(rec_address!=top.mem[port])
begin
->top.tb.error;
// Check whether the packet is coming on the proper port or not
$display("[CHECKER] ERROR PKT RECIVED ON PORT %d,PKT ADDRESS is %d",top.mem[port],rec_address);
end
for(i=0;i<size;i=i+1)
// get the packet from score board and comare the recived packet with the sent packet.
if(top.tb.sb.sent_pkt[i][top.tb.sb.pkt_no]!== mem[i])
begin
$display("[CHECKER] ERROR at %d pkt no %d ",i,top.tb.sb.pkt_no);
$display("[CHECKER] at %d sentbyte %b rcevbyte %b",i,top.tb.sb.sent_pkt[i][top.tb.sb.pkt_no], mem[i]);
->top.tb.error;
end
else
begin
$display("[CHECKER] at %d sentbyte %b rcevbyte %b",i,top.tb.sb.sent_pkt[i][top.tb.sb.pkt_no], mem[i]);
end

top.tb.sb.pkt_no=top.tb.sb.pkt_no+1;

end
endtask

endmodule