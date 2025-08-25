#!/bin/bash
RUNME=../target/wasm32-wasip1/debug/run-me.wasm
CALCULATE=../target/wasm32-wasip1/debug/calculate.wasm
ADDER=../target/wasm32-wasip1/debug/adder.wasm
OUT=exec.wasm
TEMP=hello.wasm
 
#first choice 
#
#wasm-tools compose $RUNME  -d $CALCULATE -d $ADDER -o $OUT
# 
#second choicea
#
#wasm-tools compose $RUNME   -d $ADDER -d $CALCULATE -o $OUT 

wac plug   $CALCULATE --plug  $ADDER -o $TEMP 
ls  -l $TEMP
# call jco here for now 
#jco transpile hello.wasm -o ./jco  --tla-compat 

