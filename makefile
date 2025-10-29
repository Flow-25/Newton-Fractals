##
# Project Title
#
# @file
# @version 0.1

.PHONY: all

all: main

image_generate.o: image_generate.ispc
	ispc --target=avx2-i32x8 image_generate.ispc -o image_generate.o --pic

main: main.cpp image_generate.o
	g++ -O2 main.cpp image_generate.o -o main



# end
