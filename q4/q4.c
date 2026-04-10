#include <stdio.h>
#include <dlfcn.h>
#include <string.h>

typedef int (*fptr)(int, int);

int main() {
    char op[6];      
    int a, b;

    while (scanf("%5s %d %d", op, &a, &b) == 3) {
        char libname[20];


        sprintf(libname, "./lib%s.so", op);
        void* handle = dlopen(libname, RTLD_LAZY);
        fptr func = (fptr)dlsym(handle, op);

        int result = func(a, b);
        printf("%d\n", result);


        dlclose(handle);
    }

    return 0;
}
