#include <stdio.h>

int main() {
    double memory_usage, swap_usage;

    // Baca 2 nilai metrik dari stdin
    // Metrik 1: Memory usage (%), Metrik 2: Swap usage (%)
    scanf("%lf %lf", &memory_usage, &swap_usage);

    // Tentukan status Metrik 1 (Memory usage)
    // Ambang: FAIL >=90%, WARN >=75%
    const char *status_memory;
    if (memory_usage >= 90) {
        status_memory = "FAIL";
    } else if (memory_usage >= 75) {
        status_memory = "WARN";
    } else {
        status_memory = "PASS";
    }

    // Tentukan status Metrik 2 (Swap usage)
    // Ambang: FAIL >=25%, WARN >=1%
    const char *status_swap;
    if (swap_usage >= 25) {
        status_swap = "FAIL";
    } else if (swap_usage >= 1) {
        status_swap = "WARN";
    } else {
        status_swap = "PASS";
    }

    // Kembalikan hasil ke stdout
    printf("%s %s\n", status_memory, status_swap);

    return 0;
}