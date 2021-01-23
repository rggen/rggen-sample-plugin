module rggen_bit_field_counter #(
  parameter int             WIDTH         = 8,
  parameter bit [WIDTH-1:0] INITIAL_VALUE = '0
)(
  input   logic                 i_clk,
  input   logic                 i_rst_n,
  rggen_bit_field_if.bit_field  bit_field_if,
  input   logic                 i_clear,
  input   logic                 i_up,
  input   logic                 i_down,
  output  logic [WIDTH-1:0]     o_count
);
  logic             access_valid;
  logic [WIDTH-1:0] write_mask;
  logic [WIDTH-1:0] write_data;
  logic [WIDTH-1:0] count;
  logic [1:0]       up_down;

  assign  bit_field_if.value      = count;
  assign  bit_field_if.read_data  = count;
  assign  o_count                 = count;

  assign  access_valid  = bit_field_if.valid;
  assign  write_mask    = bit_field_if.write_mask;
  assign  write_data    = bit_field_if.write_data;
  assign  up_down       = {i_up, i_down};

  always_ff @(posedge i_clk, negedge i_rst_n) begin
    if (!i_rst_n) begin
      count <= INITIAL_VALUE;
    end
    else if (i_clear) begin
      count <= INITIAL_VALUE;
    end
    else if (access_valid && (write_mask != '0)) begin
      count <= (write_data & write_mask) | (count & (~write_mask));
    end
    else begin
      case (up_down)
        2'b10:  count <= count + WIDTH'(1);
        2'b01:  count <= count - WIDTH'(1);
      endcase
    end
  end
endmodule
