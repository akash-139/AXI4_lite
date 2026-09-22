class axi_lt_env extends uvm_env;
    `uvm_component_utils(axi_lt_env)
    axi_lt_master_agent m_agnt_h;
    axi_lt_out_agent out_agnt_h;
    axi_lt_scoreboard scb_h;
    axi_lt_subscriber sub_h;

    function new(string name = "axi_lt_env",uvm_component parent);
        super.new(name,parent);
    endfunction
  
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      m_agnt_h = axi_lt_master_agent::type_id::create("m_agnt_h",this);
      out_agnt_h = axi_lt_out_agent::type_id::create("out_agnt_h",this);
      scb_h = axi_lt_scoreboard::type_id::create("scb_h",this);
      sub_h = axi_lt_subscriber::type_id::create("sub_h",this);
    endfunction
  
  	function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
      	out_agnt_h.mon_h.out_ap.connect(scb_h.out_imp);
      	m_agnt_h.mon_h.in_wr_ap.connect(scb_h.in_wr_imp);
      	m_agnt_h.mon_h.in_rd_ap.connect(scb_h.in_rd_imp);
      	m_agnt_h.mon_h.in_wr_ap.connect(sub_h.analysis_export);
      	m_agnt_h.mon_h.in_rd_ap.connect(sub_h.analysis_export);
    endfunction
  
endclass
