class axi_lt_wr_sequencer extends uvm_sequencer #(seq_item);
    `uvm_component_utils(axi_lt_wr_sequencer)

    function new(string name = "axi_lt_wr_sequencer",uvm_component parent);
        super.new(name,parent);
    endfunction

endclass
