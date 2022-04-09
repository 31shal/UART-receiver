//input frequency =25 MHZ, baud rate =115200
//clks_per_bit = 25000000/115200 = 217
typedef enum {IDLE,RX_START, RX_DATA,RX_STOP} state;
module uart_receiver_dut();
parameter clks_per_bit =217;
input clk;
input rx_data_valid;
logic [7:0] LED_DATA;
input rx_serial_data;
logic [7:0] rx_clk_count;
logic [2:0] rx_bit_index;
always@(posedge clk) begin
case(state)begin
IDLE: begin
if(!rx_serial_data)
state <= RX_START;
end
RX_START: begin
if(rx_clk_count == clks_per_bit/2)begin
 if(!rx_start)begin
 state <= RX_DATA;
 rx_clk_count <=0;
 else begin
 rx_clk_count = rx_clk_count +1;
state <= RX_START;
end
end
RX_DATA: begin
if(rx_clk_count == clks_per_bit)begin
if(rx_data_valid)begin
LED_DATA[rx_bit_index] <= rx_serial_data;
rx_bit_index =rx_bit_index +1;
rx_clk_count = 0;
if(rx_bit_index == 8)
state <= RX_STOP;
end
end
else
rx_clk_count ==  rx_clk_count +1;
state <= RX_DATA;
end
end
RX_STOP:begin
if((rx_clk_count == clks_per_bit)begin
if(rx_serial_data)begin
state <= IDLE;
rx_clk_count <= 0;
else
rx_clk_count = rx_clk_count +1;
state < = RX_STOP;
end
end
default :state<=IDLE
endcase
endmodule
