#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <bsd/string.h>

int testfn(int *arr);

// this part runs on x86 only and saves test data, which is compiled into the
// assembly-language driver program.
int main(int argc, char **argv) {
    int test_data[] = {
        1, 2, 3, 4, 5
    };

    if (argc != 2) {
        fprintf(stderr, "Usage: %s save_file\n", argv[0]);
        return 1;
    }

    char *save_file = argv[1];
    char out_fname[128];
    strlcpy(out_fname, save_file, sizeof (out_fname));
    printf("Saving a dump of the input array to %s\n", out_fname);
    FILE *f = fopen(out_fname, "wb");
    if (!f) {
        perror("failed to open the input info to dump it\n");
        return 1;
    }
    size_t remain = sizeof (test_data);
    while (remain > 0) {
        size_t written = fwrite(test_data, 1, remain, f);
        remain -= written;
    }
    fclose(f);

    printf("Exec the function ...\n");
    int result = testfn(test_data);
    printf("testfn(test_data) = %d\n", result);

    strlcat(out_fname, ".out", sizeof (out_fname));
    printf("Saving a dump of the output result to %s\n", out_fname);
    f = fopen(out_fname, "wb");
    if (!f) {
        perror("failed to open the input info to dump it\n");
        return 1;
    }
    remain = sizeof (test_data);
    while (remain > 0) {
        size_t written = fwrite(test_data, 1, remain, f);
        remain -= written;
    }
    fclose(f);
    printf("Done!!\n");
}