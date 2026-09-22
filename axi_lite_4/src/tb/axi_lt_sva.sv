module axi_lt_sva(
  input logic ACLK,
  input logic ARESETn,
  input  logic [31:0] AWADDR,
  input  logic [2:0] AWPROT,
  input logic AWVALID,
  input logic AWREADY,
  input  logic [31:0] WDATA,
  input  logic [3:0] WSTRB,
  input logic WVALID,
  input logic WREADY,
  input logic [1:0] BRESP,
  input logic  BVALID,
  input logic BREADY,
  input logic [31:0] ARADDR,
  input logic [2:0]  ARPROT,
  input logic ARVALID,
  input logic  ARREADY,
  input logic  [31:0] RDATA,
  input logic  [1:0] RRESP,
  input logic  RVALID,
  input logic RREADY
);

  property p1;
    @(posedge ACLK) disable iff (!ARESETn)
    (AWVALID && !AWREADY) |=> AWVALID;
  endproperty
 
  assert property (p1)
        else $error("handshake in complete");

 property p2;
    @(posedge ACLK) disable iff (!ARESETn)
    (WVALID && !WREADY) |=> WVALID;
  endproperty
 
  assert property (p2)
      else $error("handshake in complete");

 property p3;
    @(posedge ACLK) disable iff (!ARESETn)
    (ARVALID && !ARREADY) |=> ARVALID;
  endproperty
 
  assert property (p3)
      else $error("handshake in complete");

 property p4;
    @(posedge ACLK) disable iff (!ARESETn)
    (RVALID && !RREADY) |=> RVALID;
  endproperty
 
  assert property (p4)
      else $error("handshake in complete");

 property p5;
    @(posedge ACLK) disable iff (!ARESETn)
    (BVALID && !BREADY) |=> BVALID;
  endproperty
 
  assert property (p5)
      else $error("handshake in complete");

  

endmodule
