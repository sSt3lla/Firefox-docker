#!/usr/bin/bash
for file in /mozconfigs/*
do
	echo "Building $file"
	export MOZCONFIG=$file
	./firefox/mach build
done
