class axi_lt_out_monitor extends uvm_monitor;
    `uvm_component_utils(axi_lt_out_monitor)
    uvm_analysis_port #(seq_item)out_ap;
    seq_item out_item;
    virtual axi_lt_if vif;
  	bit ar_done,r_done;

    function new(string name = "axi_lt_out_monitor",uvm_component parent);
        super.new(name,parent);
      out_ap = new("out_ap",this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual axi_lt_if)::get(this,"","vif",vif))
            `uvm_error("get_type_name()","vif isn't set for out_monitor")
    endfunction

    task run_phase(uvm_phase phase);
       // out_item = seq_item::type_id::create("out_item");
        forever begin
          @(vif.out_mon_cb);
          
          collect();
        end
    endtask

    task collect();
       
    if(vif.out_mon_cb.ARESETn == 1'b0)begin
        $display("/////////////reset/////////");
        out_item.ARADDR = vif.out_mon_cb.ARADDR;
        out_item.ARPROT = vif.out_mon_cb.ARPROT;
        out_item.RDATA = vif.out_mon_cb.RDATA;
        out_item.RRESP = vif.out_mon_cb.RRESP;
        out_item.BRESP = vif.out_mon_cb.BRESP;
        out_ap.write(out_item);
    end

      if(!ar_done && !r_done)
        out_item = seq_item::type_id::create("out_item");
      
      if(vif.out_mon_cb.ARVALID && vif.out_mon_cb.ARREADY && !ar_done)begin
        out_item.ARADDR = vif.out_mon_cb.ARADDR;
        out_item.ARPROT = vif.out_mon_cb.ARPROT;
       	ar_done = 1'b1;
        //`uvm_info("OUT_MON",$sformatf("araddr %0h arprot %0h",out_item.ARADDR,out_item.ARPROT),UVM_NONE)
      end

      if(vif.out_mon_cb.RVALID && vif.out_mon_cb.RREADY && !r_done)begin
        out_item.RDATA = vif.out_mon_cb.RDATA;
        out_item.RRESP = vif.out_mon_cb.RRESP;
        r_done = 1'b1;
        //`uvm_info("OUT_MON",$sformatf("rdata %0h rresp %0h",out_item.RDATA, out_item.RRESP),UVM_NONE)
      end
      
      if(vif.out_mon_cb.BVALID && vif.out_mon_cb.BREADY)begin
        seq_item bresp_item;
        bresp_item = seq_item::type_id::create("bresp_item");
        bresp_item.BRESP = vif.out_mon_cb.BRESP;
        out_ap.write(bresp_item);
        //$display("////////////////////bvalid_sent////////////////////////////");
        //`uvm_info("BRESP",$sformatf("================bresp %h===================",bresp_item.BRESP),UVM_NONE)
      end
      
      check_tr();
    endtask
      
      task check_tr();
        if(ar_done && r_done)begin
          //`uvm_info("WRITE_OUT_ITEM",$sformatf("out_mon data sent %0b",out_item.sprint),UVM_NONE)
          out_ap.write(out_item);
          ar_done = 1'b0;
          r_done = 1'b0;
        end
    endtask

endclass
