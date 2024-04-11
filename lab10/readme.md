1. please make sure the covergroup has the line
   option.per_instance = 1;

2. transfer your files to server IP 172.16.5.130 , or to other server IPs using scp command
   example: assuming to transer test.sv from windows, to /home/myworkdir
   please make sure myworkdir is existing under /home
   scp test.sv root@172.16.5.130:/home/myworkdir/test.sv

3a. commands to setup cadence tool
csh
source /home/installs/cshrc
source /home/ec5018_lab10/coverage.cshrc

3b. compile/simulate all your sv files along with below command
-access +rwc -sv -coverage all -covoverwrite -covtest <testname>
example:
xrun -coverage all -sysv -access +rw design.sv testbench.sv -covoverwrite -covtest test_rand
coverage data is created under cov_work/scope/test_rand

4. create a file called imc.tcl with contents as below
   load -run test_rand
   report -detail -out coverage.rpt -metrics all -source on
   #merge test_dr test_wr -out merged_data -initial_model test_rand
   #load -run merged_data
   #report -detail -out merged.rpt -metrics all -source on
   quit

5. run below command
   imc -batch -init imc.tcl

6. The file coverage.rpt will contain detailed report
