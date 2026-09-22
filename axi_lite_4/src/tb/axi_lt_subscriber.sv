class axi_lt_subscriber extends uvm_subscriber#(seq_item);
    `uvm_component_utils(axi_lt_subscriber)
    seq_item tr;

    covergroup cg;
        cp_awaddr : coverpoint tr.AWADDR{
            bins awaddr[4] = {[0:32'hffff_ffff]};
        }
        cp_araddr: coverpoint tr.ARADDR{
            bins araddr[4] = {[0:32'hffff_ffff]};
        }
        cp_wdata: coverpoint tr.WDATA{
            bins wdata[3] = {[0:32'hffff_ffff]};
        }
        cp_wstrb: coverpoint tr.WSTRB{
            bins wstrb[] = {1,2,4,8};
        }

        cs_wdata_wstrb :cross cp_wdata, cp_wstrb{
            bins wdata_wstrb = binsof(cp_wdata) && binsof(cp_wstrb);
        }


    endgroup

    function new(string name = "axi_lt_subscriber",uvm_component parent);
        super.new(name,parent);
        cg = new();
    endfunction

    function void write(seq_item t);
        tr = t;
        cg.sample();
    endfunction

endclass
