#include <stdio.h>
#include <stdlib.h>
#include "local_header.h"

#define MAX 0xFFu
#define SQUARE(x) ((x) * (x))
#define LOG(fmt, ...) fprintf(stderr, fmt, __VA_ARGS__)

#ifdef DEBUG
static const char *kTag = "dbg";
#else
static const char *kTag = "rel";
#endif

/** Doc comment for the shape tag. */
typedef enum { SHAPE_DOT = 0, SHAPE_LINE = 1 << 2, SHAPE_ARC } ShapeTag;

typedef union {
    long   raw;
    double real;
} Bits;

typedef struct Node {
    ShapeTag      tag;
    volatile int  flags;
    struct Node  *next;
    char          name[8];
} Node;

typedef int (*Compare)(const void *a, const void *b);

extern char **environ;
static int g_count = 0;

/* block comment */
static int compare_nodes(const void *a, const void *b) {
    const Node *l = (const Node *)a;
    const Node *r = (const Node *)b;
    return (l->tag > r->tag) ? 1 : -1;
}

int main(int argc, char **argv) {
    unsigned long mask = 0755UL;   // octal
    long long big = 9000000000LL;
    int bin = 0b1011;
    float ratio = 1.5e-3f;
    double eps = .25;
    char tab = '\t', nul = '\0', quote = '\'';
    const char *msg = "line\n\tescaped \"quoted\" \x41";
    Node head = { .tag = SHAPE_ARC, .flags = 0, .next = NULL, .name = "root" };
    Node *cursor = &head;
    Compare cmp = compare_nodes;
    Bits bits;

    bits.raw = (long)((mask ^ MAX) & ~bin) | (big >> 3);
    if (!cursor || bits.raw == 0)
        goto done;

    for (int i = 0; i < argc; ++i) {
        cursor = cursor + 1;
        switch (*argv[i]) {
        case 'v':
            g_count += SQUARE(i);
            continue;
        default:
            break;
        }
    }
    while (g_count-- > 0 && ratio < 1.0f)
        ratio *= 2.0f;

    printf("%s: %d %05.2f %#x %p %zu\n", kTag, bin, ratio, MAX,
           (void *)cursor, sizeof(Node));
    LOG("eps=%g %s\n", eps, *environ);

done:
    return cmp(&head, cursor) ? EXIT_FAILURE : EXIT_SUCCESS;
}
