#!/bin/zsh
test_dir="tests/integration/valid"
tests=( $(ls $test_dir) )
test_count=( $(ls $test_dir | wc -l) )

for (( i=0; i<$test_count; i=i+1 ))
do
   gtimeout 3s swipl -s app -g "verify('$test_dir/${tests[${i}]}')" -g "writeln('${tests[${i}]}: Passed')" -t halt || echo "${tests[${i}]}: TIMED OUT"
done
