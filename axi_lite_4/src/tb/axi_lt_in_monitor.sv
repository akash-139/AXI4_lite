class axi_lt_in_monitor extends uvm_monitor;
    `uvm_component_utils(axi_lt_in_monitor)
    uvm_analysis_port #(seq_item)in_wr_ap;
    uvm_analysis_port #(seq_item)in_rd_ap;

    seq_item in_item;
    virtual axi_lt_if vif;
    bit aw_done,w_done;

    function new(string name = "axi_lt_in_monitor",uvm_component parent);
        super.new(name,parent);
      in_wr_ap = new("in_wr_ap",this);
      in_rd_ap = new("in_rd_ap",this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual axi_lt_if)::get(this,"","vif",vif))
            `uvm_error("get_type_name()","vif isn't set for in monitor")
    endfunction

    task run_phase(uvm_phase phase);
        //in_item = seq_item::type_id::create("in_item");
        forever begin
          @(vif.in_mon_cb);
            
            collect();
        end
    endtask

    task collect();

        if(vif.in_mon_cb.ARESETn == 1'b0)begin
                in_item.AWADDR = vif.in_mon_cb.AWADDR;
                in_item.AWPROT = vif.in_mon_cb.AWPROT;
                in_item.WSTRB = vif.in_mon_cb.WSTRB;
                in_item.WDATA = vif.in_mon_cb.WDATA;
                in_item.ARADDR = vif.in_mon_cb.ARADDR;
                in_item.ARPROT = vif.in_mon_cb.ARPROT;
                in_wr_ap.write(in_item);
        end

      if(!aw_done && !w_done)
        in_item = seq_item::type_id::create("in_item");
        
      
      
        begin
            if(vif.in_mon_cb.AWVALID && vif.in_mon_cb.AWREADY && !aw_done)begin
                in_item.AWADDR = vif.in_mon_cb.AWADDR;
                in_item.AWPROT = vif.in_mon_cb.AWPROT;
                aw_done = 1'b1;
            end

            if(vif.in_mon_cb.WVALID && vif.in_mon_cb.WREADY && !w_done)begin
                in_item.WSTRB = vif.in_mon_cb.WSTRB;
                in_item.WDATA = vif.in_mon_cb.WDATA;
                w_done = 1'b1;
            end

            if(vif.in_mon_cb.ARVALID && vif.in_mon_cb.ARREADY)begin
              	in_item = seq_item::type_id::create("in_item");
                in_item.ARADDR = vif.in_mon_cb.ARADDR;
                in_item.ARPROT = vif.in_mon_cb.ARPROT;
              	in_item.ARVALID = vif.in_mon_cb.ARVALID;
              	in_rd_ap.write(in_item);
            end

            check_tr();
        end
    endtask

    task check_tr();
        if(aw_done && w_done)begin
          in_wr_ap.write(in_item);
          //`uvm_info("IN_MON",$sformatf("in_mon data sent %0b",in_item.sprint),UVM_NONE)
          aw_done = 1'b0;
          w_done = 1'b0;
        end
    endtask


endclass
