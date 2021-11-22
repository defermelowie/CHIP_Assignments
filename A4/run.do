do "compile.do"
vsim -voptargs="+acc" top

run -a

# do "coverage.do"
coverage report -details