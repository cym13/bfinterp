#!/usr/bin/env rdmd

import std.stdio;
import std.string;

struct VM {
    int pos;
    const static int size = 30000;
    char[size] mem;

    char current() {
        return mem[pos];
    }

    void current(char chr) {
        mem[pos] = chr;
    }

    void inc() {
        mem[pos] = cast(char)(mem[pos] + 1) % 256;
    }

    void dec() {
        mem[pos] = cast(char)(mem[pos] - 1) % 256;
    }
}

struct Program {
    string content;
    int    pos;
    int[]  loops;

    char current() {
        return content[pos];
    }
}

void main() {
    VM vm;
    Program prog;
    string input_buffer = "";

    for (int i=0 ; i<vm.size ; i++)
        vm.mem[i] = 0;

    writeln("Enter program:");
    prog.content = chomp(readln());

    while (prog.pos != prog.content.length) {
        switch (prog.current()) {
            case '+':
                vm.inc();
                break;

            case '-':
                vm.dec();
                break;

            case '>':
                vm.pos = (vm.pos + 1) % vm.size;
                break;

            case '<':
                vm.pos = (vm.pos - 1) % vm.size;
                break;

            case '.':
                printf("%c", vm.current());
                break;

            case ',':
                if (input_buffer == "")
                    input_buffer = chop(readln());

                vm.current(input_buffer[0]);
                input_buffer = input_buffer[1 .. $];
                break;

            case '[':
                prog.loops ~= prog.pos;
                break;

            case ']':
                if (vm.current() != 0) {
                    prog.pos = prog.loops[$-1];
                }
                else {
                    prog.loops = prog.loops[0 .. $-1];
                }
                break;

            default:
                continue;
        }
        prog.pos++;
    }
}
