class axi_lt_out_agent extends uvm_agent;
    `uvm_component_utils(axi_lt_out_agent)
    axi_lt_out_monitor mon_h;

  function new(string name = "axi_lt_master_agent",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
      mon_h = axi_lt_out_monitor::type_id::create("mon_h",this);
    endfunction

endclass
