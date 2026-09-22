class axi_lt_sequence extends uvm_sequence #(seq_item);
    `uvm_object_utils(axi_lt_sequence)
    seq_item seq1;

    function new(string name = "axi_lt_sequence");
        super.new(name);
    endfunction

    task body();
      repeat(25)begin
            seq1 = seq_item::type_id::create("seq1");
            start_item(seq1);
            assert(seq1.randomize())
            finish_item(seq1);
        end
    endtask

endclass

class reset_sequence extends axi_lt_sequence;
  `uvm_object_utils(reset_sequence)
  seq_item seqr;
  
  function new(string name = "reset_sequence");
    super.new(name);
  endfunction
  
  task body();
      repeat(5)begin
        seqr = seq_item::type_id::create("seqr");
        start_item(seqr);
        assert(seqr.randomize() with {ARESETn == 0;})
        finish_item(seqr);
      end
  endtask
endclass

class write_sequence extends axi_lt_sequence;
  `uvm_object_utils(write_sequence)
  seq_item seq2;
  
  function new(string name = "write_sequence");
    super.new(name);
  endfunction
  
  task body();
    $display("seq2");
    for (int i=0;i<10;i++)begin
      seq2 = seq_item::type_id::create("seq2");
      start_item(seq2);
      assert(seq2.randomize() with {AWADDR == i*4; ARVALID == 1'b0;/* AWADDR[5:2] inside {[0:9],13,14}; AWADDR[1:0] == 2'b00;*/ AWVALID == 1'b1; WVALID == 1'b1; WSTRB == 4'b1111;})
      finish_item(seq2);
    end
  endtask
endclass


class read_sequence extends axi_lt_sequence;
  `uvm_object_utils(read_sequence)
  seq_item seq3;
  
  function new(string name = "read_sequence");
    super.new(name);
  endfunction
  
  task body();
    $display("seq3");
    for(int i=0;i<10;i++)begin
      seq3 = seq_item::type_id::create("seq3");
      start_item(seq3);
      assert(seq3.randomize() with {ARADDR == i*4; AWVALID == 1'b0;/* ARADDR[5:2] inside {[0:9],10,12}; ARADDR[1:0] == 2'b00;*/ ARVALID == 1'b1; WVALID == 1'b0;})
        finish_item(seq3);
    end
  endtask
endclass

class write_error_sequence extends axi_lt_sequence;
  `uvm_object_utils(write_error_sequence)
  seq_item seq4;
  
  function new(string name = "write_error_sequence");
    super.new(name);
  endfunction
  
  task body();
    $display("seq4");
    repeat(25)begin
      seq4 = seq_item::type_id::create("seq4");
      start_item(seq4);
      assert(seq4.randomize() with {AWADDR<32'h3c; ARVALID == 1'b0; !(AWADDR[5:2] inside {[0:9],13,14}); AWVALID == 1'b1;WVALID == 1'b1;})
        finish_item(seq4);
        end
  endtask
endclass

class read_error_sequence extends axi_lt_sequence;
  `uvm_object_utils(read_error_sequence)
  seq_item seq5;
  
  function new(string name = "read_error_sequence");
    super.new(name);
  endfunction
  
  task body();
    $display("seq5");
    repeat(25)begin
      seq5 = seq_item::type_id::create("seq5");
      start_item(seq5);
      assert(seq5.randomize() with {ARADDR < 32'h3c; AWVALID == 1'b0; !(ARADDR[5:2] inside {[0:9],10,12});ARVALID == 1'b1; WVALID == 1'b0;})
        finish_item(seq5);
        end
  endtask
endclass

class write_addr_error_sequence extends axi_lt_sequence;
    `uvm_object_utils(write_addr_error_sequence)
    seq_item seq6;

    function new(string name = "write_addr_error_sequence");
        super.new(name);
    endfunction

    task body();
      $display("seq6");
      repeat(25)begin
        seq6 = seq_item::type_id::create("seq6");
        start_item(seq6);
        assert(seq6.randomize() with {ARADDR >= 32'h3C; ARVALID == 1'b0;AWVALID == 1'b1; WVALID == 1'b1;})
          finish_item(seq6);
      end
    endtask

endclass

class read_addr_error_sequence extends axi_lt_sequence;
    `uvm_object_utils(read_addr_error_sequence)
    seq_item seq10;

    function new(string name = "read_addr_error_sequence");
        super.new(name);
    endfunction

    task body();
      $display("seq10");
      repeat(25)begin
            seq10 = seq_item::type_id::create("seq10");
            start_item(seq10);
        assert(seq10.randomize() with {ARADDR >= 32'h3C; ARVALID == 1'b1; AWVALID == 1'b0; WVALID == 1'b0;})
            finish_item(seq10);
        end
    endtask

endclass

class write_addr_priority_error_sequence extends axi_lt_sequence;
    `uvm_object_utils(write_addr_priority_error_sequence)
    seq_item seq7;

    function new(string name = "write_addr_priority_error_sequence");
        super.new(name);
    endfunction

    task body();
      $display("seq7");
      repeat(25)begin
            seq7 =seq_item::type_id::create("seq7");
            start_item(seq7);
        assert(seq7.randomize() with {AWADDR>=32'h3C; ARVALID == 1'b0;AWVALID == 1'b1; WVALID == 1'b1; AWADDR[1:0] != 0;})
            finish_item(seq7);
        end
    endtask

endclass

class read_addr_priority_error_sequence extends axi_lt_sequence;
    `uvm_object_utils(read_addr_priority_error_sequence)
    seq_item seq11;

    function new(string name = "read_addr_priority_error_sequence");
        super.new(name);
    endfunction

    task body();
      $display("seq11");
      repeat(25)begin
        seq11 =seq_item::type_id::create("seq11");
        start_item(seq11);
        assert(seq11.randomize() with {ARADDR>=32'h3C; ARVALID == 1'b1;AWVALID == 1'b0; WVALID == 1'b0; ARADDR[1:0] != 0;})
        finish_item(seq11);
        end
    endtask

endclass

class delayed_bready_sequence extends axi_lt_sequence;
    `uvm_object_utils(delayed_bready_sequence)
    seq_item seq8;

    function new(string name = "delayed_bready_sequence");
        super.new(name);
    endfunction

    task body();
      $display("seq8");
      repeat(25)begin
        seq8 = seq_item::type_id::create("seq8");
        start_item(seq8);
        assert(seq8.randomize() with {AWADDR < 32'h3c; /*ARVALID == 1'b0; AWADDR[5:2] inside {[0:9],13,14}; AWADDR[1:0] == 2'b00;*/ AWVALID == 1'b1; WVALID == 1'b1; WSTRB == 4'b1111;bready_delay inside {[1:3]};})            	  
          finish_item(seq8);
        end
    endtask

endclass

class delayed_rready_sequence extends axi_lt_sequence;
    `uvm_object_utils(delayed_rready_sequence)
    seq_item seq9;

    function new(string name = "delayed_rready_sequence");
        super.new(name);
    endfunction

    task body();
      $display("seq9");
      repeat(25)begin
        seq9 = seq_item::type_id::create("seq9");
        start_item(seq9);
        assert(seq9.randomize() with {ARADDR < 32'h3c; ARVALID == 1'b1;/* ARADDR[5:2] inside {[0:9],13,14}; ARADDR[1:0] == 2'b00;*/ AWVALID == 1'b0; WVALID == 1'b0;rready_delay inside {[1:3]};})            	  
          
          finish_item(seq9);
        end
    endtask

endclass

class delayed_addr extends axi_lt_sequence;
  `uvm_object_utils(delayed_addr)
  seq_item seq12;
  
  function new(string name = "delayed_addr");
    super.new(name);
  endfunction
  
  task body();
    $display("seq12");
      seq12 = seq_item::type_id::create("seq12");
      start_item(seq12);
      assert(seq12.randomize() with {AWADDR == 32'h4; /*ARVALID == 1'b0; AWADDR[5:2] inside {[0:9],13,14}; AWADDR[1:0] == 2'b00;*/ AWVALID == 1'b1; WVALID == 1'b0; WSTRB == 4'b1111;})
      finish_item(seq12);

      start_item(seq12);
      assert(seq12.randomize() with {AWADDR == 32'h8; /*ARVALID == 1'b0; AWADDR[5:2] inside {[0:9],13,14}; AWADDR[1:0] == 2'b00;*/ AWVALID == 1'b1; WVALID == 1'b0; WSTRB == 4'b1111;})
      finish_item(seq12);
      
      start_item(seq12);
      assert(seq12.randomize() with {AWADDR == 32'hc; /*ARVALID == 1'b0; AWADDR[5:2] inside {[0:9],13,14}; AWADDR[1:0] == 2'b00;*/ AWVALID == 1'b1; WVALID == 1'b0; WSTRB == 4'b1111;})
      finish_item(seq12);

      start_item(seq12);
      assert(seq12.randomize() with {AWADDR < 32'h3c; /*ARVALID == 1'b0; AWADDR[5:2] inside {[0:9],13,14}; AWADDR[1:0] == 2'b00;*/ AWVALID == 1'b0; WVALID == 1'b1; WSTRB == 4'b1111;})
      finish_item(seq12);

  endtask
endclass

class delayed_data extends axi_lt_sequence;
  `uvm_object_utils(delayed_data)
  seq_item seq13;
  
  function new(string name = "delayed_data");
    super.new(name);
  endfunction
  
  task body();
    $display("seq13");
      seq13 = seq_item::type_id::create("seq13");
      start_item(seq13);
      assert(seq13.randomize() with {AWADDR < 32'h3c; /*ARVALID == 1'b0; AWADDR[5:2] inside {[0:9],13,14}; AWADDR[1:0] == 2'b00;*/ AWVALID == 1'b0; WVALID == 1'b1; WSTRB == 4'b1111;})
      finish_item(seq13);

      start_item(seq13);
      assert(seq13.randomize() with {AWADDR < 32'h3c; /*ARVALID == 1'b0; AWADDR[5:2] inside {[0:9],13,14}; AWADDR[1:0] == 2'b00;*/ AWVALID == 1'b0; WVALID == 1'b1; WSTRB == 4'b1111;})
      finish_item(seq13);
      
      start_item(seq13);
      assert(seq13.randomize() with {AWADDR < 32'h3c; /*ARVALID == 1'b0; AWADDR[5:2] inside {[0:9],13,14}; AWADDR[1:0] == 2'b00;*/ AWVALID == 1'b0; WVALID == 1'b1; WSTRB == 4'b1111;})
      finish_item(seq13);


      start_item(seq13);
      assert(seq13.randomize() with {AWADDR == 32'h4; /*ARVALID == 1'b0; AWADDR[5:2] inside {[0:9],13,14}; AWADDR[1:0] == 2'b00;*/ AWVALID == 1'b1; WVALID == 1'b0; WSTRB == 4'b1111;})
      finish_item(seq13);

  endtask
endclass

class direct_read_sequence extends axi_lt_sequence;
  `uvm_object_utils(direct_read_sequence)
  seq_item seq14;
  
  function new(string name = "direct_read_sequence");
    super.new(name);
  endfunction
  
  task body();
      seq14 = seq_item::type_id::create("seq14");
      start_item(seq14);
        assert(seq14.randomize() with {ARADDR == 32'h4; AWVALID == 1'b0;/* ARADDR[5:2] inside {[0:9],10,12}; ARADDR[1:0] == 2'b00;*/ ARVALID == 1'b1; WVALID == 1'b0;})
      finish_item(seq14);
      
      start_item(seq14);
        assert(seq14.randomize() with {ARADDR == 32'h8; AWVALID == 1'b0;/* ARADDR[5:2] inside {[0:9],10,12}; ARADDR[1:0] == 2'b00;*/ ARVALID == 1'b1; WVALID == 1'b0;})
      finish_item(seq14);
     
      start_item(seq14);
        assert(seq14.randomize() with {ARADDR == 32'hc; AWVALID == 1'b0;/* ARADDR[5:2] inside {[0:9],10,12}; ARADDR[1:0] == 2'b00;*/ ARVALID == 1'b1; WVALID == 1'b0;})
      finish_item(seq14);


  endtask
endclass
