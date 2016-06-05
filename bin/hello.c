typedef void Void;
typedef int Integer;
typedef double Float;
typedef char * String;
typedef void * Pointer;
typedef enum { False, True } Bool;
typedef union {  } UnionType;
typedef struct {  } A;
typedef struct { Float a; } B;
extern Integer puts(String);
extern Integer B$$a(B * self);
extern Integer B$$a1(B * self);
extern Float B$$set_id(B * self, Float n);
extern Float B$$get_id(B * self);
extern Integer A$class$$b(Void);
extern Integer A$class$$b1(Void);
Integer B$$a(B * self)
{
    return puts("hello");
}
Integer B$$a1(B * self)
{
    return puts("world");
}
Float B$$set_id(B * self, Float n)
{
    return self->a = n;
}
Float B$$get_id(B * self)
{
    return self->a;
}
Integer A$class$$b(Void)
{
    return puts("static hello");
}
Integer A$class$$b1(Void)
{
    return puts("static world");
}
Integer main(Void)
{
    Pointer b = calloc(sizeof(B), 1);
    B$$a(b);
    A$class$$b();
    B$$a1(b);
    A$class$$b1();
    A$class$$b1();
    B$$set_id(b, 2.3);
    B$$get_id(b);
    return (5 & (1 << 2));
}
