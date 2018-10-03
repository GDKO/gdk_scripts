#include <stdio.h>
#include <string.h>
#include <zlib.h>

int main(int argc, char* argv[])
{
    gzFile file;
    char const* const fileName = argv[1];

    if (argc == 1) {
        fprintf(stderr, "Usage: %s <sequence_file>\n", argv[0]);
        return 1;
    }

    if  ((file = gzopen(fileName, "r")) == NULL) {
        printf("Could not open %s\n", fileName);
        return 1;
    }

    char line[5000000];
    int k=0;
    double b=0;
    double i=0;
    int fq = 4;

/*
    char *filename = argv[1];
    char *word = "fa";
    char *ret = strstr(filename, word);
    if (ret) {fq=1;}
*/

    while (!gzeof(file)) {
        if ((gzgets(file, line, sizeof(line))) !=NULL) {
            k++;
                if (k % fq == 0) {
                    b += strlen(line);
                    i++;
                }
        }
    }

    gzclose(file);
    printf("Filename = %s ; Reads = %.0f ; Bases = %.0f\n", argv[1], i, b-i);
    return 0;
}
