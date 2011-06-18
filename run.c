#include <stdlib.h>
#include <string.h>

// returns the length of the copied string (without \n)
static inline int copy(char *dst, const char *src) {
    int length = strlen(src);
    strncpy(dst, src, length);
    return length;
}

int main(int argc, char *argv[]) {
    int i;
    int n;
    int length;
    char *command;

    n = atoi(argv[1]);

    length = 0;
    for(i = 2; i < argc; i++) {
        length += strlen(argv[i]) + 1;
    }
    command = malloc(length + 12);

    length = 0;
    for(i = 2; i < argc; i++) {
        length += copy(&command[length], argv[i]);
        length += copy(&command[length], " ");
    }
    length += copy(&command[length], "> /dev/null");
    command[length] = '\n';

    for(i = 0; i < n; i++) {
        system(command);
    }
    return 0;
}
