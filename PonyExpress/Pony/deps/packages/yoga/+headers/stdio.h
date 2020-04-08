int printf(const char * restrict format, ...);
int fprintf(FILE * restrict stream, const char * restrict format, ...);
int sprintf(char * restrict str, const char * restrict format, ...);
int snprintf(char * restrict str, size_t size, const char * restrict format, ...);
int asprintf(char **ret, const char *format, ...);
int dprintf(int fd, const char * restrict format, ...);
int vprintf(const char * restrict format, va_list ap);
int vfprintf(FILE * restrict stream, const char * restrict format, va_list ap);
int vsprintf(char * restrict str, const char * restrict format, va_list ap);
int vsnprintf(char * restrict str, size_t size, const char * restrict format, va_list ap);
int vasprintf(char **ret, const char *format, va_list ap);
int vdprintf(int fd, const char * restrict format, va_list ap);

