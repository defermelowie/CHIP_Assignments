do "compile.do"
vsim -voptargs="+acc" top

# run -a
run 100 us

do "coverage.do"