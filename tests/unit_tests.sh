#!/bin/bash
tests_succeded=true
for tst in $(ls $(dirname $0)/test_*)
do
    $tst || tests_succeded=false
done

$tests_succeded
