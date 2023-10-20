// 一位全加器真值表
//  A   B   Ci  S   Co
//  0   0   0   0   0
//  0   0   1   1   0
//  0   1   0   1   0
//  0   1   1   0   1
//  1   0   0   1   0
//  1   0   1   0   1
//  1   1   0   1   0
//  1   1   1   1   1

// 由上述真值表易知，可由A、B、Ci中1的数量来确定S
// 奇数个1时S为1，其余情况S为0
// 当1的个数大于等于2时Co为1，其余情况Co为0

module adder 
#(
    parameter N = 32
) 
(
    input               ci  ,
    input       [N-1:0] x   ,
    input       [N-1:0] y   ,

    output  reg [N-1:0] s   ,
    output  reg         co
);

    reg     [N-1:0]     c   ;
    integer             k   ;

always @(*) begin
    c[0] = ci;
    for (k = 0 ; k<N ; k=k+1) begin
        s[k]   = x[k] ^ y[k] ^ c[k];
        c[k+1] = (x[k] & y[k]) | (x[k] & c[k]) | (y[k] & c[k]);
    end
    co = c[N];
end

endmodule