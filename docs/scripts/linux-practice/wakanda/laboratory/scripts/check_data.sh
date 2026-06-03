#!/usr/bin/env bash

# quick look at a data file
echo "Checking:" $1
echo "Preview:"
head $1 -n 4
# tail $1 -n 4
echo "Total lines:"
wc -l $1
echo "Lines starting with 1:"
grep "^1" $1 | wc -l

