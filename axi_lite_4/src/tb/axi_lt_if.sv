interface axi_lt_if(input bit ACLK);
    logic [31:0] AWADDR;
    logic [2:0] AWPROT;
    logic AWVALID;
    logic AWREADY;

    logic [31:0] WDATA;
    logic [3:0]  WSTRB;
    logic WVALID;
    logic WREADY;

    logic [1:0] BRESP;
    logic BVALID;
    logic BREADY;

    logic[31:0]ARADDR;
    logic [2:0]ARPROT;
    logic ARVALID;
    logic ARREADY;

    logic [31:0]RDATA;
    logic [1:0]RRESP;
    logic RVALID;
    logic RREADY;

    logic ARESETn;

    clocking drv_cb@(posedge ACLK);
        default input #1 output #1;
        input AWREADY,WREADY,BRESP,BVALID,ARREADY,RVALID;
        output AWADDR,AWPROT,AWVALID,WDATA,WSTRB,WVALID,BREADY,ARADDR,ARPROT,ARVALID,RREADY,ARESETn;
    endclocking

    clocking in_mon_cb@(posedge ACLK);
        default input #1 output #1;
        input AWADDR,AWPROT,AWVALID,AWREADY,WDATA,WSTRB,WVALID,WREADY,BRESP,BVALID,BREADY,ARADDR,ARPROT,ARVALID,ARREADY,RDATA,RRESP,RVALID,RREADY,ARESETn;
    endclocking

    clocking out_mon_cb@(posedge ACLK);
        default input #1 output #1;
        input AWADDR,AWPROT,AWVALID,AWREADY,WDATA,WSTRB,WVALID,WREADY,BRESP,BVALID,BREADY,ARADDR,ARPROT,ARVALID,ARREADY,RDATA,RRESP,RVALID,RREADY,ARESETn;
    endclocking

    modport DRV(clocking drv_cb);
    modport IN_MON(clocking in_mon_cb);
    modport OUT_MON(clocking out_mon_cb);

endinterface
