/*
 * Copyright (C) 2012, Benjamin Drung <bdrung@debian.org>
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>

#include <unistd.h>
#include <sched.h>
#include <sys/wait.h>

#ifdef __GNUC__
#define likely(x)   __builtin_expect((x),1)
#define unlikely(x) __builtin_expect((x),0)
#else
#define likely(x)   (x)
#define unlikely(x) (x)
#endif

int main(int argc, char *argv[]) {
    char *command[argc-2];
    cpu_set_t cpu_set;
    int core;
    int n;
    int status;
    pid_t pid;

    if(unlikely(argc < 4)) {
        fprintf(stderr, "Usage: %s core n prog [arguments]\n", argv[0]);
        return EXIT_FAILURE;
    }

    core = atoi(argv[1]);
    if(unlikely(core < 0)) {
        fprintf(stderr, "run: The first parameter must be an unsigned integer.\n");
        return EXIT_FAILURE;
    }

    n = atoi(argv[2]);
    if(unlikely(n < 0)) {
        fprintf(stderr, "run: The second parameter must be an unsigned integer.\n");
        return EXIT_FAILURE;
    }

    for(int i = 3; i < argc; i++) {
        command[i-3] = argv[i];
    }
    command[argc-3] = NULL;

    CPU_ZERO(&cpu_set);
    CPU_SET(core, &cpu_set);
    if(unlikely(sched_setaffinity(getpid(), sizeof(cpu_set), &cpu_set) == -1)) {
        perror("run");
        exit(EXIT_FAILURE);
    }

    for(volatile int i = 0; i < n; i++) {
        pid = vfork();
        if(unlikely(pid == -1)) {
            fprintf(stderr, "run: vfork() %i failed.\n", i);
            return EXIT_FAILURE;
        }
        if(pid == 0) {
            if(execv(command[0], command) == -1) {
                perror("run");
            }
            exit(-1);
        } else {
            wait(&status);
            if (unlikely(WIFEXITED(status) && WEXITSTATUS(status) != 0)) {
                fprintf(stderr, "run: Fork %i exited with status %d.\n", i,
                        WEXITSTATUS(status));
                return EXIT_FAILURE;
            } else if (unlikely(WIFSIGNALED(status))) {
                fprintf(stderr, "run: Fork %i killed by signal %d.\n", i,
                        WTERMSIG(status));
                return EXIT_FAILURE;
            } else if (unlikely(WIFSTOPPED(status))) {
                fprintf(stderr, "run: Fork %i stopped by signal %d.\n", i,
                        WSTOPSIG(status));
                return EXIT_FAILURE;
            }
        }
    }
    return EXIT_SUCCESS;
}
