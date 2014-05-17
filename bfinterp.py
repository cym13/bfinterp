#!/usr/bin/env python3
# -*- coding: utf-8 -*-

def main():
    mem         = [0] * 30000
    mem_ptr     = 0
    program     = input("Enter program: ")
    program_ptr = 0
    bracket_buf = []
    input_buf   = ""

    while program_ptr != len(program):
        cmd = program[program_ptr]

        if cmd == "<":
            mem_ptr = (mem_ptr - 1) % 30000

        elif cmd == ">":
            mem_ptr = (mem_ptr + 1) % 30000

        elif cmd == "+":
            mem[mem_ptr] = (mem[mem_ptr] + 1) % 256

        elif cmd == "-":
            mem[mem_ptr] = (mem[mem_ptr] - 1) % 256

        elif cmd == ".":
            print(chr(mem[mem_ptr]), end="")

        elif cmd == ",":
            if input_buf == "":
                input_buf = input()

            mem[mem_ptr] = ord(input_buf[0])
            input_buf = input_buf[1:]

        elif cmd == "[":
            bracket_buf.append(program_ptr)

        elif cmd == "]":
            if mem[mem_ptr] != 0:
                program_ptr = bracket_buf[-1]
            else:
                bracket_buf.pop()

        program_ptr += 1

if __name__ == "__main__":
    main()
