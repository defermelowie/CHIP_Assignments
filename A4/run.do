do "compile.do"
vsim -voptargs="+acc" top

# run -a
run 10 us

# do "coverage.do"