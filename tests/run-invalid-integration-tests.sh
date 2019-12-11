#!/bin/zsh
test_dir="tests/integration/invalid"
tests=( $(ls $test_dir) )
test_count=( $(ls $test_dir | wc -l) )

for (( i=0; i<$test_count; i=i+1 ))
do
   gtimeout 3s swipl -s app -g "verify('$test_dir/${tests[${i}]}')" -g "writeln('${tests[${i}]}: PASSED')" -t halt ; 
   if [ $? -eq 124 ] ; 
      then echo ${tests[${i}]}: TIMED OUT ;
   fi
done
