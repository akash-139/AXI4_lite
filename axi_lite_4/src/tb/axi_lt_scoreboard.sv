`uvm_analysis_imp_decl(_in_wr)
`uvm_analysis_imp_decl(_in_rd)
`uvm_analysis_imp_decl(_out)

class axi_lt_scoreboard extends uvm_scoreboard;
`uvm_component_utils(axi_lt_scoreboard)

uvm_analysis_imp_in_wr #(seq_item,axi_lt_scoreboard)in_wr_imp;
uvm_analysis_imp_in_rd #(seq_item,axi_lt_scoreboard)in_rd_imp;
uvm_analysis_imp_out #(seq_item,axi_lt_scoreboard)out_imp;

bit [31:0]mem[int];
seq_item exp_rd_q[$];
seq_item exp_wr_q[$];
seq_item exp_wr;
seq_item exp_rd;
seq_item exp_wr_out;
seq_item exp_rd_out;

function new(string name = "axi_lt_scoreboard",uvm_component parent);
    super.new(name,parent);
    in_wr_imp = new("in_wr_imp",this);
    in_rd_imp = new("in_rd_imp",this);
    out_imp = new("out_imp",this);
endfunction


function void write_in_wr(seq_item in);
   
  `uvm_info("WRITE_IN",$sformatf("write in data %h address %h strobe %h and read address %h",in.WDATA,in.AWADDR,in.WSTRB,in.ARADDR[5:2]),UVM_NONE)

  if(in.ARESETn == 0)
      mem.delete();
  
  if(!$cast(exp_wr,in.clone())) `uvm_error("get_type_name()",$sformatf("cloning failed"))
  
    //else `uvm_info("EXP",$sformatf("exp data after cloning %h",exp.sprint),UVM_NONE)
  
    
    //if(exp.WVALID == 1'b1)begin
        if(exp_wr.AWADDR > 32'h3c)begin
          //$display("------------decerr------------");
            exp_wr.BRESP = 2'b11;
        end
      else if(exp_wr.AWADDR[1:0] != 2'b00 || (exp_wr.AWADDR[5:2] > 10 && exp_wr.AWADDR[5:2] < 12) )begin
          //$display("------------slverr------------");
            exp_wr.BRESP = 2'b10;
        end
        else begin
          //$display("got into the data entering loop");
            for(int i=0;i<4;i++)begin
                if(exp_wr.WSTRB[i])begin
                  mem[exp_wr.AWADDR[5:2]][8*i +: 8] = exp_wr.WDATA[8*i +: 8];
                  //$strobe("written data %0h into address %0h",exp.WDATA[8*i +: 8],exp.AWADDR[5:2]);
                end
            end
          
          exp_wr.BRESP = 2'b00;
        end

        exp_wr_q.push_back(exp_wr);
    //end
endfunction


function void write_in_rd(seq_item in);

  //if(exp.ARVALID == 1'b1)begin
   //$display("rvalid high");
  if(!$cast(exp_rd,in.clone())) `uvm_error("get_type_name()",$sformatf("cloning failed"))
    
    if(exp_rd.ARADDR>=32'h3C)begin
          exp_rd.RRESP = 2'b11;
          exp_rd.RDATA = 32'd0;
      end
    else if(exp_rd.ARADDR[1:0] != 2'b00 || (exp_rd.ARADDR[5:2] > 10 && exp_rd.ARADDR[5:2] < 12) )begin
          exp_rd.RRESP = 2'b10;
          exp_rd.RDATA = 32'd0;
      end
      else begin
        $display("got into the data retrieving loop");
        exp_rd.RRESP = 2'b00;
        if(mem.exists(exp_rd.ARADDR[5:2]))
          exp_rd.RDATA = mem[exp_rd.ARADDR[5:2]];
        else begin
          exp_rd.RDATA = 'b0;
          `uvm_info("SCB",$sformatf("data doesn't exist"),UVM_NONE)
        end
      end
          //`uvm_info("EXP_IN",$sformatf("exp data after cloning %h",exp.sprint),UVM_NONE)
          
       // $display("expected data pushed");
   //end
  
  exp_rd_q.push_back(exp_rd);

endfunction

function void write_out(seq_item out);
  
  if(exp_rd_q.size() > 0 )begin
    
    exp_rd_out = exp_rd_q.pop_front();
    
    `uvm_info("BRESP",$sformatf("=====BRESP %h=======",out.BRESP),UVM_MEDIUM)

    if(exp_rd_out.RDATA !== out.RDATA)
      `uvm_error("DATA_MISMATCH",$sformatf("exp data %0h and actual data %0h with exp_addr %0h and actual address %0h",exp_rd_out.RDATA,out.RDATA,exp_rd_out.ARADDR,out.ARADDR))
      else
        `uvm_info("DATA_MATCH",$sformatf("exp data %0h and actual data %0h with exp_addr %0h and actual address %0h",exp_rd_out.RDATA,out.RDATA,exp_rd_out.ARADDR,out.ARADDR),UVM_NONE)

        if(exp_rd_out.RRESP !== out.RRESP)
        `uvm_error("RRESP_MISMATCH",$sformatf("exp rresp %0h and actual rresp %0h",exp_rd_out.RRESP,out.RRESP))
      else
        `uvm_info("RRESP_MATCH",$sformatf("exp rresp %0h and actual rresp %0h \n",exp_rd_out.RRESP,out.RRESP),UVM_NONE)
  end

  if(exp_wr_q.size() > 0 )begin

    exp_wr_out = exp_wr_q.pop_front();
    
    if(exp_wr_out.BRESP !== out.BRESP)
        `uvm_error("BRESP_MISMATCH",$sformatf("exp bresp %0h and actual bresp %0h",exp_wr_out.BRESP,out.BRESP))
    else
        `uvm_info("BRESP_MATCH",$sformatf("exp bresp %0h and actual bresp %0h",exp_wr_out.BRESP,out.BRESP),UVM_NONE)

  end
 

endfunction

endclass
