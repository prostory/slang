typedef void Void;
typedef int Integer;
typedef double Float;
typedef char * String;
typedef void * Pointer;
typedef enum { False, True } Bool;
typedef struct {  } Object;
typedef struct {  } Object$Class;
static Object$Class Object$class;
typedef struct {  } A;
typedef struct { Integer a; } A$Class;
static A$Class A$class;
typedef struct { String name; Integer id; Float a; } B;
typedef struct { Integer a; } B$Class;
static B$Class B$class;
extern Integer puts(String);
extern Integer printf(String, ...);
extern B * B$Class$$__alloc__(B$Class * self);
extern B * B$Class$$new(B$Class * self, String var0, Integer var1);
extern Integer B$$a(B * self);
extern Float B$$set_id(B * self, Float n);
extern Float B$$get_id(B * self);
extern Integer A$Class$$b(A$Class * self);
extern Integer B$Class$$b(B$Class * self);
extern Integer B$$__init__1(B * self, String name, Integer id);
extern String B$$name(B * self);
extern Pointer calloc(Integer, Integer);
B * B$Class$$__alloc__(B$Class * self)
{
    return (B *)calloc(sizeof(B), 1);
}
B * B$Class$$new(B$Class * self, String var0, Integer var1)
{
    Pointer obj = B$Class$$__alloc__(self);
    B$$__init__1(obj, var0, var1);
    return obj;
}
Integer B$$a(B * self)
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
    puts("static world");
    return self->a = 5;
}
Integer B$Class$$b(B$Class * self)
{
    puts("static world");
    return self->a = 5;
}
Integer B$$__init__1(B * self, String name, Integer id)
{
    self->name = name;
    return self->id = id;
}
String B$$name(B * self)
{
    return self->name;
}
Integer main(Void)
{
    Pointer b = B$Class$$new(&B$class, "Xiao Peng", 1);
    B$$a(b);
    A$Class$$b(&A$class);
    B$$a(b);
    A$Class$$b(&A$class);
    B$Class$$b(&B$class);
    B$$set_id(b, 2.3);
    B$$get_id(b);
    puts(B$$name(b));
    puts("B");
    puts("Float");
    printf("hello, goto %f\n", B$$get_id(b));
    return (5 & (1 << 2));
}
