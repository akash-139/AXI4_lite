`include "axi_lt_if.sv"

module axi_lt_top;
  import uvm_pkg::*;
  
bit ACLK;
bit ARESETn;
axi_lt_if dut_if(ACLK);

axi4_lite_slave DUT(.ACLK(ACLK),
.ARESETn(ARESETn),
.AWADDR(dut_if.AWADDR),
.AWPROT(dut_if.AWPROT),
.AWVALID(dut_if.AWVALID),
.AWREADY(dut_if.AWREADY),
.WDATA(dut_if.WDATA),
.WSTRB(dut_if.WSTRB),
.WVALID(dut_if.WVALID),
.WREADY(dut_if.WREADY),
.BRESP(dut_if.BRESP),
.BVALID(dut_if.BVALID),
.BREADY(dut_if.BREADY),
.ARADDR(dut_if.ARADDR),
.ARPROT(dut_if.ARPROT),
.ARVALID(dut_if.ARVALID),
.ARREADY(dut_if.ARREADY),
.RDATA(dut_if.RDATA),
.RRESP(dut_if.RRESP),
.RVALID(dut_if.RVALID),
.RREADY(dut_if.RREADY));
  
  bind axi4_lite_slave axi_lt_sva sva(
  .ACLK(ACLK),
  .ARESETn(ARESETn),
  .AWADDR(dut_if.AWADDR),
  .AWPROT(dut_if.AWPROT),
  .AWVALID(dut_if.AWVALID),
  .AWREADY(dut_if.AWREADY),
  .WDATA(dut_if.WDATA),
  .WSTRB(dut_if.WSTRB),
  .WVALID(dut_if.WVALID),
  .WREADY(dut_if.WREADY),
  .BRESP(dut_if.BRESP),
  .BVALID(dut_if.BVALID),
  .BREADY(dut_if.BREADY),
  .ARADDR(dut_if.ARADDR),
  .ARPROT(dut_if.ARPROT),
  .ARVALID(dut_if.ARVALID),
  .ARREADY(dut_if.ARREADY),
  .RDATA(dut_if.RDATA),
  .RRESP(dut_if.RRESP),
  .RVALID(dut_if.RVALID),
  .RREADY(dut_if.RREADY)
);

  
  
initial begin
    forever #5 ACLK = ~ACLK;
end

initial begin
    uvm_config_db#(virtual axi_lt_if)::set(null,"*","vif",dut_if);
    run_test("axi_lt_test");
end

initial begin
    ARESETn = 1;
    @(posedge ACLK);
    ARESETn = 0;
    repeat(3)@(posedge ACLK);
    ARESETn = 1;
  $display("------------RESET--------------");
end
  
initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, axi_lt_top);
end

endmodule
