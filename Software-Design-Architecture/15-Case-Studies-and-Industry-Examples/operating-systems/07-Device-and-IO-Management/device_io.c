// device_io.c
// Simulate device and I/O management

#include <stdio.h>

void device_driver() {
    printf("Device driver loaded!\n");
}

void io_operation() {
    printf("I/O operation performed!\n");
}

int main() {
    device_driver();
    io_operation();
    return 0;
}
