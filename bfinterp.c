#include <stdio.h>
#define MEM_SIZE 30000
#define PROG_SIZE 1024
#define LOOP_BUF_SIZE 1024

int main(int argc, char* argv[])
{
    char mem[MEM_SIZE];
    char* mem_cur = mem;
    char prog[PROG_SIZE];
    char* prog_cur = prog;
    char* loop_buf[LOOP_BUF_SIZE];
    char** last_loop = loop_buf;

    printf("Enter program:\n");
    fgets(prog, 1024, stdin);

    while (*prog_cur != '\0') {
        switch (*prog_cur) {
            case '+':
                *mem_cur = (*mem_cur + 1) % 255;
                break;

            case '-':
                *mem_cur = (*mem_cur - 1) % 255;
                break;

            case '>':
                if (mem_cur == mem + MEM_SIZE - 1)
                    mem_cur = mem;
                else
                    mem_cur = (mem_cur + 1);
                break;

            case '<':
                if (mem_cur == mem)
                    mem_cur = mem + MEM_SIZE - 1;
                else
                    mem_cur = (mem_cur - 1);
                break;

            case '.':
                printf("%c", *mem_cur);
                break;

            case ',':
                *mem_cur = getchar();
                break;


            case '[':
                last_loop++;
                *last_loop = prog_cur;
                break;

            case ']':
                if (*mem_cur != 0)
                    prog_cur = *last_loop;
                else
                    last_loop--;
                break;
        }
        prog_cur++;
    }

    return 0;
}
