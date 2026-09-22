class seq_item extends uvm_sequence_item;
  rand logic ARESETn;

  rand logic [31:0] AWADDR;
  rand logic [2:0] AWPROT;
  rand logic AWVALID;
  logic AWREADY;

  rand logic [31:0] WDATA;
  rand logic [3:0]  WSTRB;
  rand logic WVALID;
  logic WREADY;

  logic [1:0] BRESP;
  logic BVALID;
  logic BREADY;

  rand logic[31:0]ARADDR;
  rand logic [2:0]ARPROT;
  rand logic ARVALID;
  logic ARREADY;

  logic [31:0]RDATA;
  logic [1:0]RRESP;
  logic RVALID;
  rand logic RREADY;
  
  rand bit [2:0] aw_delay,w_delay,rready_delay,bready_delay;
  
  
  function new(string name = "seq_item");
    super.new(name);
  endfunction


  `uvm_object_utils_begin(seq_item)
  `uvm_field_int(AWADDR, UVM_ALL_ON)
  `uvm_field_int(AWPROT, UVM_ALL_ON)
  `uvm_field_int(AWVALID, UVM_ALL_ON)
  `uvm_field_int(AWREADY, UVM_ALL_ON)
  `uvm_field_int(WDATA, UVM_ALL_ON)
  `uvm_field_int(WSTRB, UVM_ALL_ON)
  `uvm_field_int(WVALID, UVM_ALL_ON)
  `uvm_field_int(WREADY, UVM_ALL_ON)
  `uvm_field_int(BRESP, UVM_ALL_ON)
  `uvm_field_int(BVALID, UVM_ALL_ON)
  `uvm_field_int(BREADY, UVM_ALL_ON)
  `uvm_field_int(ARADDR, UVM_ALL_ON)
  `uvm_field_int(ARPROT, UVM_ALL_ON)
  `uvm_field_int(ARVALID, UVM_ALL_ON)
  `uvm_field_int(ARREADY, UVM_ALL_ON)
  `uvm_field_int(RDATA, UVM_ALL_ON)
  `uvm_field_int(RRESP, UVM_ALL_ON)
  `uvm_field_int(RVALID, UVM_ALL_ON)
  `uvm_field_int(RREADY, UVM_ALL_ON)
  `uvm_field_int(ARESETn, UVM_ALL_ON)
  `uvm_object_utils_end
  
  constraint c4 {aw_delay != w_delay;
                 aw_delay inside {[1:3]};
                 w_delay inside {[1:3]};}
  constraint c5 {
    soft rready_delay == 0;
    soft bready_delay == 0;
  }

  constraint c6{
      soft ARESETn == 1;
  }

endclass
