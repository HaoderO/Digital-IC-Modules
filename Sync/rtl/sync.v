module sync 
(
    input   wire aclk,
    input   wire rst_n,
    input   wire bclk,
    input   wire level_in,
    input   wire pulse_in,
    output  wire level_out,
    output  wire pulse_out
);
    
reg pulse_in_sync;
reg[1:0] level_in_bclk;
reg[2:0] pulse_in_sync_bclk;
reg[1:0] pulse_in_sync_aclk;

always @(posedge aclk or negedge rst_n) 
begin
    if (!rst_n)
        pulse_in_sync <= 1'b0;
    else
        pulse_in_sync <= (~pulse_in_sync_aclk[1])&(pulse_in | pulse_in_sync);
end

always @(posedge bclk or negedge rst_n) 
begin
    if (!rst_n) begin
        pulse_in_sync_bclk <= 3'b0;
        level_in_bclk <= 2'b0;        
    end
    else begin
        pulse_in_sync_bclk <= {pulse_in_sync_bclk[1:0],pulse_in_sync};
        level_in_bclk <= {level_in_bclk[0],level_in};        
    end
end

always @(posedge aclk or negedge rst_n) 
begin
    if (!rst_n)
        pulse_in_sync_aclk <= 2'b0;
    else
        pulse_in_sync_aclk <= {pulse_in_sync_aclk[0],pulse_in_sync_bclk[2]};
end

assign pulse_out = pulse_in_sync_bclk[1]&(~pulse_in_sync_bclk[2]);
assign level_out = level_in_bclk[1];

endmodule