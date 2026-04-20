// scheduler.c
// Simulate CPU scheduling algorithms

#include <stdio.h>

void fcfs() {
    printf("First-Come, First-Served scheduling\n");
}

void sjf() {
    printf("Shortest Job First scheduling\n");
}

void round_robin() {
    printf("Round Robin scheduling\n");
}

int main() {
    fcfs();
    sjf();
    round_robin();
    return 0;
}
