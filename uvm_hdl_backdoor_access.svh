
import uvm_pkg::*;
`include "uvm_macros.svh"
 
class basic_test extends uvm_test;
 
  string force_me = "tb.a.test.my_var";
  int read_var;
  
  `uvm_component_utils(basic_test)
 
  function new(string name = "basic_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
 
    if (uvm_hdl_check_path ("tb.a.test.my_var"))
      `uvm_info ("Test_HDL","Path tb.a.test.my_var exists", UVM_NONE);
 
 
  endfunction : build_phase
 
  virtual task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "Entering test run_phase", UVM_MEDIUM)
   
   phase.raise_objection(this);
   
   if (!uvm_hdl_deposit ("tb.a.test.my_var",5'h8))
      `uvm_error ("Test_HDL","Deposit failed for this path tb.a.test.my_var");
    `uvm_info (get_type_name(),$sformatf("deposit = %0h", tb.a.test.my_var), UVM_NONE);
   
   #50ns 
   
   if (!uvm_hdl_deposit ("tb.a.test.my_var",5'h7))
      `uvm_error ("Test_HDL","Deposit failed for this path tb.a.test.my_var");
    `uvm_info (get_type_name(),$sformatf("deposit = %0h", tb.a.test.my_var), UVM_NONE);
    
    #50ns
    if (!uvm_hdl_force ("tb.a.test.my_var",5'h10))
      `uvm_error ("Test_HDL","Deposit failed for this path tb.a.test.my_var");
    `uvm_info (get_type_name(),$sformatf("force = %0h", tb.a.test.my_var), UVM_NONE);
    
     uvm_hdl_force_time (force_me,5'h9,30);
    
    `uvm_info (get_type_name(),$sformatf("force_time = %0h", tb.a.test.my_var), UVM_NONE);
    
    #20ns
    
    if (!uvm_hdl_read ("tb.a.test.my_var",read_var))
      `uvm_error ("Test_HDL","Deposit failed for this path tb.a.test.my_var");
    `uvm_info (get_type_name(),$sformatf("read value is %d", read_var), UVM_NONE);
    
    phase.drop_objection(this);
 
  endtask
endclass : basic_test
 
 
module tb;
  bbq a();
 
initial run_test("basic_test");
 
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, tb);
  end 
endmodule
 
module xyz;
  reg [4:0] my_var;
endmodule
 
module bbq;
  xyz test();
endmodule
