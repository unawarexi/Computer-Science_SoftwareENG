// network.c
// Simulate networking and distributed system operations

#include <stdio.h>

void open_socket() {
    printf("Socket opened!\n");
}

void rpc_call() {
    printf("Remote procedure call executed!\n");
}

int main() {
    open_socket();
    rpc_call();
    return 0;
}
