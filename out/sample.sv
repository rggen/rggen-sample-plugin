`ifndef rggen_connect_bit_field_if
  `define rggen_connect_bit_field_if(RIF, FIF, LSB, WIDTH) \
  assign  FIF.valid                 = RIF.valid; \
  assign  FIF.read_mask             = RIF.read_mask[LSB+:WIDTH]; \
  assign  FIF.write_mask            = RIF.write_mask[LSB+:WIDTH]; \
  assign  FIF.write_data            = RIF.write_data[LSB+:WIDTH]; \
  assign  RIF.read_data[LSB+:WIDTH] = FIF.read_data; \
  assign  RIF.value[LSB+:WIDTH]     = FIF.value;
`endif
`ifndef rggen_tie_off_unused_signals
  `define rggen_tie_off_unused_signals(WIDTH, VALID_BITS, RIF) \
  if (1) begin : __g_tie_off \
    genvar  __i; \
    for (__i = 0;__i < WIDTH;++__i) begin : g \
      if ((((VALID_BITS) >> __i) % 2) == 0) begin : g \
        assign  RIF.read_data[__i]  = 1'b0; \
        assign  RIF.value[__i]      = 1'b0; \
      end \
    end \
  end
`endif
module sample
  import rggen_rtl_pkg::*;
#(
  parameter int ADDRESS_WIDTH = 8,
  parameter bit PRE_DECODE = 0,
  parameter bit [ADDRESS_WIDTH-1:0] BASE_ADDRESS = '0,
  parameter bit ERROR_STATUS = 0,
  parameter bit [31:0] DEFAULT_READ_DATA = '0,
  parameter bit INSERT_SLICER = 0
)(
  input logic i_clk,
  input logic i_rst_n,
  rggen_apb_if.slave apb_if,
  input logic i_register_0_bit_field_0_clear,
  input logic i_register_0_bit_field_0_up,
  input logic i_register_0_bit_field_0_down,
  output logic [3:0] o_register_0_bit_field_0_count,
  input logic i_register_0_bit_field_1_up,
  input logic i_register_0_bit_field_1_down,
  output logic [3:0] o_register_0_bit_field_1_count,
  input logic [1:0][1:0][3:0] i_register_1_bit_field_0_clear,
  input logic [1:0][1:0][3:0] i_register_1_bit_field_0_up,
  input logic [1:0][1:0][3:0] i_register_1_bit_field_0_down,
  output logic [1:0][1:0][3:0][3:0] o_register_1_bit_field_0_count,
  output logic o_register_2_bit_field_0_trigger
);
  rggen_register_if #(8, 32, 32) register_if[6]();
  rggen_apb_adapter #(
    .ADDRESS_WIDTH        (ADDRESS_WIDTH),
    .LOCAL_ADDRESS_WIDTH  (8),
    .BUS_WIDTH            (32),
    .REGISTERS            (6),
    .PRE_DECODE           (PRE_DECODE),
    .BASE_ADDRESS         (BASE_ADDRESS),
    .BYTE_SIZE            (256),
    .ERROR_STATUS         (ERROR_STATUS),
    .DEFAULT_READ_DATA    (DEFAULT_READ_DATA),
    .INSERT_SLICER        (INSERT_SLICER)
  ) u_adapter (
    .i_clk        (i_clk),
    .i_rst_n      (i_rst_n),
    .apb_if       (apb_if),
    .register_if  (register_if)
  );
  generate if (1) begin : g_register_0
    rggen_bit_field_if #(32) bit_field_if();
    `rggen_tie_off_unused_signals(32, 32'h00000f0f, bit_field_if)
    rggen_default_register #(
      .READABLE       (1),
      .WRITABLE       (1),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h00),
      .BUS_WIDTH      (32),
      .DATA_WIDTH     (32),
      .VALUE_WIDTH    (32)
    ) u_register (
      .i_clk        (i_clk),
      .i_rst_n      (i_rst_n),
      .register_if  (register_if[0]),
      .bit_field_if (bit_field_if)
    );
    if (1) begin : g_bit_field_0
      localparam bit [3:0] INITIAL_VALUE = 4'h0;
      rggen_bit_field_if #(4) bit_field_sub_if();
      `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 4)
      rggen_bit_field_counter #(
        .WIDTH          (4),
        .INITIAL_VALUE  (INITIAL_VALUE)
      ) u_bit_field (
        .i_clk        (i_clk),
        .i_rst_n      (i_rst_n),
        .bit_field_if (bit_field_sub_if),
        .i_clear      (i_register_0_bit_field_0_clear),
        .i_up         (i_register_0_bit_field_0_up),
        .i_down       (i_register_0_bit_field_0_down),
        .o_count      (o_register_0_bit_field_0_count)
      );
    end
    if (1) begin : g_bit_field_1
      localparam bit [3:0] INITIAL_VALUE = 4'h0;
      rggen_bit_field_if #(4) bit_field_sub_if();
      `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 8, 4)
      rggen_bit_field_counter #(
        .WIDTH          (4),
        .INITIAL_VALUE  (INITIAL_VALUE)
      ) u_bit_field (
        .i_clk        (i_clk),
        .i_rst_n      (i_rst_n),
        .bit_field_if (bit_field_sub_if),
        .i_clear      (register_if[5].value[0+:1]),
        .i_up         (i_register_0_bit_field_1_up),
        .i_down       (i_register_0_bit_field_1_down),
        .o_count      (o_register_0_bit_field_1_count)
      );
    end
  end endgenerate
  generate if (1) begin : g_register_1
    genvar i;
    genvar j;
    for (i = 0;i < 2;++i) begin : g
      for (j = 0;j < 2;++j) begin : g
        rggen_bit_field_if #(32) bit_field_if();
        `rggen_tie_off_unused_signals(32, 32'h0f0f0f0f, bit_field_if)
        rggen_default_register #(
          .READABLE       (1),
          .WRITABLE       (1),
          .ADDRESS_WIDTH  (8),
          .OFFSET_ADDRESS (8'h04+8'(4*(2*i+j))),
          .BUS_WIDTH      (32),
          .DATA_WIDTH     (32),
          .VALUE_WIDTH    (32)
        ) u_register (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .register_if  (register_if[1+2*i+j]),
          .bit_field_if (bit_field_if)
        );
        if (1) begin : g_bit_field_0
          genvar k;
          for (k = 0;k < 4;++k) begin : g
            localparam bit [3:0] INITIAL_VALUE = 4'h0;
            rggen_bit_field_if #(4) bit_field_sub_if();
            `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0+8*k, 4)
            rggen_bit_field_counter #(
              .WIDTH          (4),
              .INITIAL_VALUE  (INITIAL_VALUE)
            ) u_bit_field (
              .i_clk        (i_clk),
              .i_rst_n      (i_rst_n),
              .bit_field_if (bit_field_sub_if),
              .i_clear      (i_register_1_bit_field_0_clear[i][j][k]),
              .i_up         (i_register_1_bit_field_0_up[i][j][k]),
              .i_down       (i_register_1_bit_field_0_down[i][j][k]),
              .o_count      (o_register_1_bit_field_0_count[i][j][k])
            );
          end
        end
      end
    end
  end endgenerate
  generate if (1) begin : g_register_2
    rggen_bit_field_if #(32) bit_field_if();
    `rggen_tie_off_unused_signals(32, 32'h00000001, bit_field_if)
    rggen_default_register #(
      .READABLE       (0),
      .WRITABLE       (1),
      .ADDRESS_WIDTH  (8),
      .OFFSET_ADDRESS (8'h18),
      .BUS_WIDTH      (32),
      .DATA_WIDTH     (32),
      .VALUE_WIDTH    (32)
    ) u_register (
      .i_clk        (i_clk),
      .i_rst_n      (i_rst_n),
      .register_if  (register_if[5]),
      .bit_field_if (bit_field_if)
    );
    if (1) begin : g_bit_field_0
      rggen_bit_field_if #(1) bit_field_sub_if();
      `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 1)
      rggen_bit_field_w01trg #(
        .TRIGGER_VALUE  (1'b1),
        .WIDTH          (1)
      ) u_bit_field (
        .i_clk        (i_clk),
        .i_rst_n      (i_rst_n),
        .bit_field_if (bit_field_sub_if),
        .i_value      ('0),
        .o_trigger    (o_register_2_bit_field_0_trigger)
      );
    end
  end endgenerate
endmodule
