#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <stdint.h>
#include <chrono>

#define PHYS_ADDR 0xFF210000
#define MAP_SIZE  0x1000
#define REGS_OFFSET 0x000

int main() {
    int fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd < 0) {
        perror("open");
        return 1;
    }

    void *map_base = mmap(NULL, MAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, PHYS_ADDR);
    if (map_base == MAP_FAILED) {
        perror("mmap");
        close(fd);
        return 1;
    }

    static volatile uint32_t *regs = reinterpret_cast<volatile uint32_t *>((uint8_t *)map_base + REGS_OFFSET);
    
    const int N_latency = 1000000;

    printf("Measuring write latency.\n");
    const auto write_start_latency = std::chrono::high_resolution_clock::now();

    for (size_t i = 0; i < N_latency; ++i)
        regs[0] = i;

    const auto write_stop_latency = std::chrono::high_resolution_clock::now();

    const auto duration_latency = std::chrono::duration_cast<std::chrono::nanoseconds>(write_stop_latency - write_start_latency);

    printf("Write time: %f ms\n", std::chrono::duration_cast<std::chrono::microseconds>(duration_latency).count() / 1000.0);
    printf("Write latency: %f ns\n", duration_latency.count() / static_cast<double>(N_latency));

    const int N_burst = 256;

    printf("Measuring burst write throughput.\n");
    const auto write_start_burst = std::chrono::high_resolution_clock::now();

    for (size_t i = 0; i < N_burst; i++) {
        regs[i] = i;
    }

    const auto write_stop_burst = std::chrono::high_resolution_clock::now();

    const auto duration_burst = std::chrono::duration_cast<std::chrono::nanoseconds>(write_stop_burst - write_start_burst);

    printf("Write time: %f ms\n", std::chrono::duration_cast<std::chrono::microseconds>(duration_burst).count() / 1000.0);
    printf("Write throughput: %f MB/s\n", (N_burst * sizeof(uint32_t)) / (duration_burst.count() / 1e9) / (1024 * 1024));

    munmap(map_base, MAP_SIZE);
    close(fd);

    return 0;
}