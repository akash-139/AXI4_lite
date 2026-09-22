class axi_lt_master_agent extends uvm_agent;
    `uvm_component_utils(axi_lt_master_agent)
    axi_lt_wr_sequencer wr_seqr_h;
    axi_lt_rd_sequencer rd_seqr_h;
    axi_lt_driver drv_h;
    axi_lt_in_monitor mon_h;

    function new(string name = "axi_lt_master_agent",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
      wr_seqr_h = axi_lt_wr_sequencer::type_id::create("wr_seqr_h",this);
      rd_seqr_h = axi_lt_rd_sequencer::type_id::create("axi_lt_rd_sequencer",this);
      drv_h = axi_lt_driver::type_id::create("drv_h",this);
      mon_h = axi_lt_in_monitor::type_id::create("mon_h",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        drv_h.seq_item_port.connect(wr_seqr_h.seq_item_export);
        drv_h.seq_item_rd_port.connect(rd_seqr_h.seq_item_export);
    endfunction

endclass
