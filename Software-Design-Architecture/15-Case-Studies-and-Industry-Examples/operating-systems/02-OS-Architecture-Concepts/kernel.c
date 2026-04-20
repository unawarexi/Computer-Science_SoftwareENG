// kernel.c
// Basic kernel structure and system call simulation

#include <stdio.h>

void system_call() {
    printf("System call invoked!\n");
}

int main() {
    printf("Booting kernel...\n");
    system_call();
    return 0;
}
