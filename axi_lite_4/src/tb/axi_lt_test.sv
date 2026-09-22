class axi_lt_test extends uvm_test;
  `uvm_component_utils(axi_lt_test)
  axi_lt_env env_h;
  axi_lt_sequence seq1;
  write_sequence seq2;
  read_sequence seq3;
  write_error_sequence seq4;
  read_error_sequence seq5;
  write_addr_error_sequence seq6;
  read_addr_error_sequence seq10;
  write_addr_priority_error_sequence seq7;
  read_addr_priority_error_sequence seq11;
  delayed_bready_sequence seq8;
  delayed_rready_sequence seq9;
  reset_sequence seqr;



  function new(string name = "axi_lt_test",uvm_component parent);
      super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_h = axi_lt_env::type_id::create("env_h",this);
    endfunction

    function void end_of_elaboration_phase (uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction

    task run_phase(uvm_phase phase);

      phase.raise_objection(this);
      seq1=axi_lt_sequence::type_id::create("seq1");
      seq2=write_sequence::type_id::create("seq2");
      seq3=read_sequence::type_id::create("seq3");
      seq4=write_error_sequence::type_id::create("seq4");
      seq5=read_error_sequence::type_id::create("seq5");
      seq6=write_addr_error_sequence::type_id::create("seq6");
      seq7=write_addr_priority_error_sequence::type_id::create("seq7");
      seq8=delayed_bready_sequence::type_id::create("seq8");
      seq9=delayed_rready_sequence::type_id::create("seq9");
      seq10=read_addr_error_sequence::type_id::create("seq10");
      seq11=read_addr_priority_error_sequence::type_id::create("seq11");

      //seq1.start(env_h.m_agnt_h.wr_seqr_h);
      //seq1.start(env_h.m_agnt_h.rd_seqr_h);
      seq2.start(env_h.m_agnt_h.wr_seqr_h);
      seq3.start(env_h.m_agnt_h.rd_seqr_h);
      seq4.start(env_h.m_agnt_h.wr_seqr_h);
      seq5.start(env_h.m_agnt_h.rd_seqr_h);
      seq6.start(env_h.m_agnt_h.wr_seqr_h);
      seq10.start(env_h.m_agnt_h.rd_seqr_h);
      seq7.start(env_h.m_agnt_h.wr_seqr_h);
      seq11.start(env_h.m_agnt_h.rd_seqr_h);
      seq8.start(env_h.m_agnt_h.wr_seqr_h);
      seq9.start(env_h.m_agnt_h.rd_seqr_h);

      fork
        seq2.start(env_h.m_agnt_h.wr_seqr_h);
        seq3.start(env_h.m_agnt_h.rd_seqr_h);
      join

      phase.drop_objection(this);
        endtask

endclass

class axi_lt_error_test extends axi_lt_test;
    `uvm_component_utils(axi_lt_error_test)

    delayed_addr seq12;
    delayed_data seq13;
    direct_read_sequence seq14;

    function new(string name = "axi_lt_error_test",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        axi_lt_driver::type_id::set_type_override(axi_lt_error_driver::get_type());
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        seq12=delayed_addr::type_id::create("seq12");
        seq13=delayed_data::type_id::create("seq13");
        seq14=direct_read_sequence::type_id::create("seq14");

        seq12.start(env_h.m_agnt_h.wr_seqr_h);
        seq13.start(env_h.m_agnt_h.wr_seqr_h);
        seq14.start(env_h.m_agnt_h.rd_seqr_h);
        phase.drop_objection(this);
    endtask

endclass

class simultaneous_wr_rd_test extends axi_lt_test;
    `uvm_component_utils(simultaneous_wr_rd_test)


    function new(string name = "simultaneous_wr_rd_test",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        seq1=write_sequence::type_id::create("seq1");
        seq2=write_sequence::type_id::create("seq2");
        seq3=read_sequence::type_id::create("seq3");

        seq1.start(env_h.m_agnt_h.wr_seqr_h);

        fork
            seq2.start(env_h.m_agnt_h.wr_seqr_h);
            seq3.start(env_h.m_agnt_h.rd_seqr_h);
        join
        phase.drop_objection(this);
    endtask

endclass

class error_response_test extends axi_lt_test;
    `uvm_component_utils(error_response_test)


    function new(string name = "error_response_test",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        seq4=write_error_sequence::type_id::create("seq4");
        seq5=read_error_sequence::type_id::create("seq5");
        seq6=write_addr_error_sequence::type_id::create("seq6");
        seq7=write_addr_priority_error_sequence::type_id::create("seq7");
        seq10=read_addr_error_sequence::type_id::create("seq10");
        seq11=read_addr_priority_error_sequence::type_id::create("seq11");


        seq4.start(env_h.m_agnt_h.wr_seqr_h);
        seq5.start(env_h.m_agnt_h.rd_seqr_h);
        seq6.start(env_h.m_agnt_h.wr_seqr_h);
        seq10.start(env_h.m_agnt_h.rd_seqr_h);
        seq7.start(env_h.m_agnt_h.wr_seqr_h);
        seq11.start(env_h.m_agnt_h.rd_seqr_h);

        phase.drop_objection(this);
    endtask

endclass

class waited_ready_test extends axi_lt_test;
    `uvm_component_utils(waited_ready_test)


    function new(string name = "waited_ready_test",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        seq8=delayed_bready_sequence::type_id::create("seq8");
        seq9=delayed_rready_sequence::type_id::create("seq9");

        seq8.start(env_h.m_agnt_h.wr_seqr_h);
        seq9.start(env_h.m_agnt_h.rd_seqr_h);

        phase.drop_objection(this);
    endtask

endclass

class continuos_write_test extends axi_lt_test;
    `uvm_component_utils(continuos_write_test)

    function new(string name = "continous_write_test",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        seq2=write_sequence::type_id::create("seq2");

        seq2.start(env_h.m_agnt_h.wr_seqr_h);

        phase.drop_objection(this);
    endtask

endclass

class continuos_read_test extends axi_lt_test;
    `uvm_component_utils(continuos_read_test)


    function new(string name = "continuos_read_test",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        seq2=write_sequence::type_id::create("seq2");
        seq3=read_sequence::type_id::create("seq3");

        seq2.start(env_h.m_agnt_h.wr_seqr_h);
        seq3.start(env_h.m_agnt_h.rd_seqr_h);

        phase.drop_objection(this);
    endtask

endclass

class reset_test extends axi_lt_test;
    `uvm_component_utils(reset_test)

    function new(string name = "reset_test",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        axi_lt_driver::type_id::set_type_override(axi_lt_error_driver::get_type());
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seqr=reset_sequence::type_id::create("seqr");
        seqr.start(env_h.m_agnt_h.wr_seqr_h);
        phase.drop_objection(this);
    endtask

endclass
