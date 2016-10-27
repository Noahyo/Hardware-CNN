`include "../network_params.h"
module nh_shift_reg_ctrl(
  input clock,
  input reset,
  
  input shift_in_rdy,
  input [`nh_bitwidth:0] shift_in,
  
  output dval,
  output [`NH_WIDTH*NH_SIZE-1:0] current_nh
);

// wire declarations
wire [`NH_BITWIDTH:0] shift_ins [`NH_DIM-1:0]; 

// reg declarations
reg [`NH_BITWIDTH:0] nh_reg [`NH_DIM-1:0][`NH_DIM-1:0]

// assign statments

// instantiate the shift registers to hold the current nh
genvar i;
genvar j;
generate 
for (j=0; j<`NH_DIM-1; j=j+1) begin : nh_row_loop
  for (i=0; i<`NH_DIM-1; i=i+1) begin : le_sr_inst 
    always@(posedge clock or negedge reset) begin
      if(reset == 1'b0) begin
        nh_reg[i][j] <= `NH_WIDTH'd0;
      end else begin
        nh_reg[i][j] <= nh_reg[i+1][j];
      end // reset
    end // always
  end // for i
end // for j 
endgenerate


// instantiate shift register to buffer the part of the line not in nh
genvar k;
generate
for( k=0; k<`NH_DIM-1; i=i+1) begin : ram_sr_inst
  ram_sr sr_inst(
    .clock(clock),
    .shift_in({shift_in_rdy, nh_reg[`NH_DIM-1][k]}),
    .shift_out(nh_reg[0][k+1])
  );
end // for
endgenerate


endmodule
