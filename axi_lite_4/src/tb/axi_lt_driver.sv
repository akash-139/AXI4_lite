class axi_lt_driver extends uvm_driver#(seq_item);
    `uvm_component_utils(axi_lt_driver)
    uvm_seq_item_pull_port #(seq_item) seq_item_rd_port;
 	virtual axi_lt_if vif;
  	seq_item rd_req;

    function new(string name = "axi_lt_driver",uvm_component parent);
        super.new(name,parent);
      seq_item_rd_port = new("seq_item_rd_port",this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual axi_lt_if)::get(this,"","vif",vif))
            `uvm_error("get_type_name()",$sformatf("vif isn't set for driver"))
    endfunction

    task run_phase(uvm_phase phase);
      fork
        forever begin
          seq_item_port.get_next_item(req);
                    fork
                        AW_drive(req);
                        W_drive(req);
                    join
          			B_drive(req);
          //`uvm_info("DRV",$sformatf("drv data %h",req.sprint()),UVM_NONE)
            seq_item_port.item_done();
        end
      
      forever begin
        seq_item_rd_port.get_next_item(rd_req);
                    fork
                      AR_drive(rd_req);
                      R_drive(rd_req);
                    join
            seq_item_rd_port.item_done();
        end
      join
    endtask

    task AW_drive(seq_item tr);
      repeat(tr.aw_delay)@(vif.drv_cb);
      vif.drv_cb.AWADDR <= tr.AWADDR;
      vif.drv_cb.AWPROT <= tr.AWPROT;
      vif.drv_cb.AWVALID <= tr.AWVALID;
      wait(vif.drv_cb.AWREADY == 1'b1);
      @(vif.drv_cb);
      vif.drv_cb.AWVALID <= 1'b0;
    endtask

    task W_drive(seq_item tr);
      repeat(tr.w_delay)@(vif.drv_cb);
      vif.drv_cb.WDATA <= tr.WDATA;
      vif.drv_cb.WSTRB <= tr.WSTRB;
      vif.drv_cb.WVALID <= tr.WVALID;
      wait(vif.drv_cb.WREADY == 1'b1);
      @(vif.drv_cb);
      vif.drv_cb.WVALID <= 1'b0;
    endtask

    task B_drive(seq_item tr);
      @(vif.drv_cb);
      wait(vif.drv_cb.BVALID == 1'b1);
      vif.drv_cb.BREADY <= 1'b1;
      @(vif.drv_cb);
      vif.drv_cb.BREADY <= 1'b1;
    endtask

    task AR_drive(seq_item tr);
        @(vif.drv_cb);
        vif.drv_cb.ARADDR <= tr.ARADDR;
        vif.drv_cb.ARPROT <= tr.ARPROT;
        vif.drv_cb.ARVALID <= tr.ARVALID;
      	wait(vif.drv_cb.ARREADY == 1'b1);
      	@(vif.drv_cb);
        vif.drv_cb.ARVALID <= 1'b0;
    endtask

    task R_drive(seq_item tr);
      @(vif.drv_cb);
      wait(vif.drv_cb.RVALID == 1'b1);
      vif.drv_cb.RREADY <= 1'b1;
      @(vif.drv_cb);
      vif.drv_cb.RREADY <= 1'b0;
    endtask

endclass


class axi_lt_error_driver extends axi_lt_driver;
    `uvm_component_utils(axi_lt_error_driver)

    function new(string name = "axi_lt_error_driver",uvm_component parent);
        super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
      fork
        forever begin
          seq_item_port.get_next_item(req);
                    fork
                        AW_drive(req);
                        W_drive(req);
                        vif.drv_cb.ARESETn <= req.ARESETn;
                    join
          			B_drive(req);
            seq_item_port.item_done();
        end
      
      forever begin
        seq_item_rd_port.get_next_item(rd_req);
                    fork
                      AR_drive(rd_req);
                      R_drive(rd_req);
                    join
            seq_item_rd_port.item_done();
        end
      join
    endtask

    task AW_drive(seq_item tr);
      repeat(tr.aw_delay)@(vif.drv_cb);
      vif.drv_cb.AWADDR <= tr.AWADDR;
      vif.drv_cb.AWPROT <= tr.AWPROT;
      vif.drv_cb.AWVALID <= tr.AWVALID;
    endtask

    task W_drive(seq_item tr);
      repeat(tr.w_delay)@(vif.drv_cb);
      vif.drv_cb.WDATA <= tr.WDATA;
      vif.drv_cb.WSTRB <= tr.WSTRB;
      vif.drv_cb.WVALID <= tr.WVALID;
    endtask

    task B_drive(seq_item tr);
      @(vif.drv_cb);
      vif.drv_cb.BREADY <= 1'b1;
    endtask

    task AR_drive(seq_item tr);
        @(vif.drv_cb);
        vif.drv_cb.ARADDR <= tr.ARADDR;
        vif.drv_cb.ARPROT <= tr.ARPROT;
        vif.drv_cb.ARVALID <= tr.ARVALID;
    endtask

    task R_drive(seq_item tr);
      @(vif.drv_cb);
      vif.drv_cb.RREADY <= 1'b1;
    endtask

endclass
