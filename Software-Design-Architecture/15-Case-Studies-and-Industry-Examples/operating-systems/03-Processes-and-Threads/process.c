// process.c
// Simulate process creation and context switching

#include <stdio.h>

void create_process() {
    printf("Process created!\n");
}

void context_switch() {
    printf("Context switch performed!\n");
}

int main() {
    create_process();
    context_switch();
    return 0;
}
