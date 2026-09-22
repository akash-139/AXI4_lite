TESTS = axi_lt_test simultaneous_wr_rd_test waited_ready_test error_response_test axi_lt_error_test reset_test continuos_write_test continuos_read_test 
ITERATIONS = 5
 
compile:
	vcs -full64 -sverilog -ntb_opts uvm -licqueue \
    -cm line+cond+fsm+tgl+branch+assert \
    -assert enable_diag \
    axi_lt_design.v axi_lt_sva.sv axi_lt_pkg.sv axi_lt_top.sv \
    -l axi_lt.log
regression: compile
	@echo "======================================"
	@echo " Starting UVM Regression Flow"
	@echo "======================================"
	@set -e; \
    for test in $(TESTS); do \
		for i in $$(seq 1 $(ITERATIONS)); do \
			echo "Running $$test - Iteration $$i with Random Seed..."; \
            ./simv \
            +UVM_TESTNAME=$$test \
            +ntb_random_seed=$$(shuf -i 1-1000000 -n 1) \
            +UVM_TIMEOUT=5000000ns \
            -cm line+cond+fsm+tgl+branch+assert \
            -cm_name $${test}_$${i} \
            -cm_dir regression_merged.vdb \
            -l log_$${test}_$${i}.log; \
		done; \
	done
	@echo "======================================"
	@echo " Regression Complete! Check log files."
	@echo "======================================"
