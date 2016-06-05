typedef void Void;
typedef int Integer;
typedef double Float;
typedef char * String;
typedef void * Pointer;
typedef enum { False, True } Bool;
typedef union {  } UnionType;
typedef struct {  } Object;
typedef struct {  } Object$Class;
static Object$Class Object$class;
typedef struct {  } A;
typedef struct { Integer a; } A$Class;
static A$Class A$class;
typedef struct { Float a; } B;
typedef struct { Integer a; } B$Class;
static B$Class B$class;
extern Integer puts(String);
extern Integer Object$Class$$__alloc__(Object$Class * self);
extern Integer Object$Class$$create(Object$Class * self);
extern Integer B$$a(B * self);
extern Integer B$$a1(B * self);
extern Float B$$set_id(B * self, Float n);
extern Float B$$get_id(B * self);
extern Integer A$Class$$b(A$Class * self);
extern Integer A$Class$$b1(A$Class * self);
extern Integer B$Class$$b1(B$Class * self);
Integer Object$Class$$__alloc__(Object$Class * self)
{
    return 1;
}
Integer Object$Class$$create(Object$Class * self)
{
    return Object$Class$$__alloc__(self);
}
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
Integer A$Class$$b(A$Class * self)
{
    return puts("static hello");
}
Integer A$Class$$b1(A$Class * self)
{
    puts("static world");
    return self->a = 5;
}
Integer B$Class$$b1(B$Class * self)
{
    puts("static world");
    return self->a = 5;
}
Integer main(Void)
{
    Pointer b = calloc(sizeof(B), 1);
    B$$a(b);
    A$Class$$b(&A$class);
    B$$a1(b);
    A$Class$$b1(&A$class);
    B$Class$$b1(&B$class);
    B$$set_id(b, 2.3);
    B$$get_id(b);
    Object$Class$$create(&Object$class);
    return (5 & (1 << 2));
}
